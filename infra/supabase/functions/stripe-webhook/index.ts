import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import Stripe from "https://esm.sh/stripe@12.5.0";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.108.2";

const STRIPE_SECRET_KEY = Deno.env.get("STRIPE_SECRET_KEY");
const STRIPE_WEBHOOK_SIGNING_SECRET = Deno.env.get("STRIPE_WEBHOOK_SIGNING_SECRET");
const SUPABASE_URL = Deno.env.get("SUPABASE_URL");

function resolveSupabaseAdminKey(): string | undefined {
  const serializedKeys = Deno.env.get("SUPABASE_SECRET_KEYS");
  if (serializedKeys) {
    try {
      const keys = JSON.parse(serializedKeys) as Record<string, unknown>;
      const selectedKey = keys["stripe_webhook"] ?? keys.default;
      if (typeof selectedKey === "string" && selectedKey.trim()) {
        return selectedKey.trim();
      }
    } catch {
      console.error("[stripe-webhook] SUPABASE_SECRET_KEYS is not valid JSON");
    }
  }

  return Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")?.trim() || undefined;
}

const SUPABASE_ADMIN_KEY = resolveSupabaseAdminKey();

const PRODUCT_ID_GOLD = "prod_UtI9NVcQK04CrP";
const PRODUCT_ID_SILVER = "prod_UyXrOejWaOHI4j";
const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

function json(body: Record<string, unknown>, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

function stripeObjectId(value: unknown): string | null {
  if (typeof value === "string" && value.trim()) return value.trim();
  if (value && typeof value === "object" && "id" in value) {
    const id = (value as { id?: unknown }).id;
    return typeof id === "string" && id.trim() ? id.trim() : null;
  }
  return null;
}

function checkoutEmail(session: Record<string, any>): string | null {
  const value = session.customer_details?.email ?? session.customer_email;
  if (typeof value !== "string") return null;
  const normalized = value.trim().toLowerCase();
  return normalized || null;
}

serve(async (req) => {
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);

  if (!STRIPE_SECRET_KEY || !STRIPE_WEBHOOK_SIGNING_SECRET || !SUPABASE_URL || !SUPABASE_ADMIN_KEY) {
    console.error("[stripe-webhook] Missing required environment configuration");
    return json({ error: "Webhook not configured" }, 503);
  }

  const signature = req.headers.get("Stripe-Signature");
  if (!signature) return json({ error: "Missing Stripe signature" }, 400);

  const stripe = new Stripe(STRIPE_SECRET_KEY, {
    apiVersion: "2022-11-15",
    httpClient: Stripe.createFetchHttpClient(),
  });
  const supabase = createClient(SUPABASE_URL, SUPABASE_ADMIN_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  try {
    const body = await req.text();
    let event: any;

    try {
      event = await stripe.webhooks.constructEventAsync(
        body,
        signature,
        STRIPE_WEBHOOK_SIGNING_SECRET
      );
    } catch (err) {
      const message = err instanceof Error ? err.message : "Invalid signature";
      console.warn(`[stripe-webhook] Signature verification failed: ${message}`);
      return json({ error: "Invalid Stripe signature" }, 400);
    }

    const eventCreatedAt = typeof event.created === "number"
      ? new Date(event.created * 1000).toISOString()
      : new Date().toISOString();

    if (event.type === "checkout.session.completed") {
      const session = event.data.object as Record<string, any>;
      const lineItems = await stripe.checkout.sessions.listLineItems(session.id);

      let plan: "SILVER" | "GOLD" | null = null;
      let productId: string | null = null;

      for (const item of lineItems.data) {
        const candidate = stripeObjectId(item.price?.product);
        if (!candidate) continue;
        if (candidate === PRODUCT_ID_GOLD) {
          plan = "GOLD";
          productId = candidate;
          break;
        }
        if (candidate === PRODUCT_ID_SILVER) {
          plan = "SILVER";
          productId = candidate;
          break;
        }
      }

      let userId: string | null = null;
      const clientReferenceId = typeof session.client_reference_id === "string"
        ? session.client_reference_id.trim()
        : "";

      if (clientReferenceId && UUID_RE.test(clientReferenceId)) {
        userId = clientReferenceId;
      } else {
        const email = checkoutEmail(session);
        if (email) {
          const { data: profiles, error: profileLookupError } = await supabase
            .from("profiles")
            .select("id")
            .ilike("email", email)
            .limit(2);

          if (profileLookupError) throw new Error(`Profile lookup failed: ${profileLookupError.message}`);
          if (profiles?.length === 1) userId = String(profiles[0].id);
        }
      }

      const { data, error } = await supabase.rpc("process_stripe_checkout_event", {
        p_event_id: event.id,
        p_event_type: event.type,
        p_user_id: userId,
        p_plan: plan,
        p_product_id: productId,
        p_subscription_id: stripeObjectId(session.subscription),
        p_customer_id: stripeObjectId(session.customer),
        p_customer_email: checkoutEmail(session),
        p_event_created_at: eventCreatedAt,
      });

      if (error) throw new Error(`Checkout fulfillment RPC failed: ${error.message}`);
      if (data?.result === "failed") throw new Error(data.error || "Checkout fulfillment failed");

      console.log(JSON.stringify({
        level: data?.result === "pending_identity" ? "WARN" : "INFO",
        event: "checkout.session.completed",
        eventId: event.id,
        plan,
        productId,
        fulfillment: data?.result ?? "unknown",
        hasResolvedUser: Boolean(userId),
      }));

      return json({ received: true, result: data?.result ?? "processed" });
    }

    if (
      event.type === "customer.subscription.updated" ||
      event.type === "customer.subscription.deleted"
    ) {
      const subscription = event.data.object as Record<string, any>;
      const subscriptionId = stripeObjectId(subscription);
      if (!subscriptionId) throw new Error("Subscription event missing subscription id");

      const { data, error } = await supabase.rpc("process_stripe_subscription_event", {
        p_event_id: event.id,
        p_event_type: event.type,
        p_subscription_id: subscriptionId,
        p_customer_id: stripeObjectId(subscription.customer),
        p_status: typeof subscription.status === "string" ? subscription.status : null,
        p_cancel_at_period_end: subscription.cancel_at_period_end === true,
        p_event_created_at: eventCreatedAt,
      });

      if (error) throw new Error(`Subscription fulfillment RPC failed: ${error.message}`);
      if (data?.result === "failed") throw new Error(data.error || "Subscription fulfillment failed");

      console.log(JSON.stringify({
        level: data?.result === "pending_identity" ? "WARN" : "INFO",
        event: event.type,
        eventId: event.id,
        subscriptionId,
        fulfillment: data?.result ?? "unknown",
      }));

      return json({ received: true, result: data?.result ?? "processed" });
    }

    return json({ received: true, result: "ignored_event_type" });
  } catch (err) {
    const message = err instanceof Error ? err.message : "Unknown webhook error";
    console.error(`[stripe-webhook] Processing failed: ${message}`);
    return json({ error: "Webhook processing failed" }, 500);
  }
});
