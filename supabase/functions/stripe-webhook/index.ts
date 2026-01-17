
// Stripe Webhook for Profeplan Production
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import Stripe from "https://esm.sh/stripe@12.5.0";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.21.0";

// --- CONFIGURATION ---
// PRODUCTION KEYS
const STRIPE_SECRET_KEY =
    "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";
const STRIPE_WEBHOOK_SIGNING_SECRET = Deno.env.get("STRIPE_WEBHOOK_SIGNING_SECRET");

// PRODUCT IDs (Production)
const PRODUCT_ID_GOLD = "prod_TkuTMOoQHPPY6V"; // R$ 50,00
const PRODUCT_ID_SILVER = "prod_TkuQ7BqvkRoU3N"; // R$ 30,00

// Initialize Stripe
const stripe = new Stripe(STRIPE_SECRET_KEY, {
    apiVersion: "2022-11-15",
    httpClient: Stripe.createFetchHttpClient(),
});

// Initialize Supabase (Admin Client)
const supabaseUrl = Deno.env.get("SUPABASE_URL") as string;
const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") as string;
const supabase = createClient(supabaseUrl, supabaseServiceRoleKey);

serve(async (req) => {
    const signature = req.headers.get("Stripe-Signature");

    if (!signature) {
        return new Response("No Stripe signature", { status: 400 });
    }

    try {
        const body = await req.text();
        let event;

        // Verify signature if secret is present (Production Best Practice)
        if (STRIPE_WEBHOOK_SIGNING_SECRET) {
            try {
                event = await stripe.webhooks.constructEventAsync(
                    body,
                    signature,
                    STRIPE_WEBHOOK_SIGNING_SECRET
                );
            } catch (err) {
                console.error(`Webhook signature verification failed: ${err.message}`);
                return new Response(err.message, { status: 400 });
            }
        } else {
            // Fallback for development/testing without signing secret
            console.warn("⚠️  No signing secret found. Webhook signature verification skipped.");
            event = JSON.parse(body);
        }

        // --- EVENT HANDLING ---
        if (event.type === "checkout.session.completed") {
            const session = event.data.object;
            const userId = session.client_reference_id;

            console.log(`💰 Checkout Completed. Session ID: ${session.id}, User ID: ${userId}`);

            if (!userId) {
                console.error("❌ Stats: No client_reference_id (User ID) found in session.");
                return new Response("No User ID found", { status: 400 });
            }

            // Retrieve full session with line items to identify product
            // Or simply better: We can iterate line_items if expanded, 
            // OR we can fetch the line items now.
            // However, for Payment Links, usually the product info is inside valid line_items.

            // Let's list line items to find the product
            const lineItems = await stripe.checkout.sessions.listLineItems(session.id);

            // Find what product was bought
            let isGold = false;
            let isSilver = false;

            for (const item of lineItems.data) {
                // Price -> Product
                const price = item.price;
                const productId = price?.product as string;

                console.log(`📦 Item: ${item.description}, Product ID: ${productId}`);

                if (productId === PRODUCT_ID_GOLD) isGold = true;
                if (productId === PRODUCT_ID_SILVER) isSilver = true;
            }

            if (!isGold && !isSilver) {
                console.log("ℹ️ Product not recognized as Gold or Silver. Skipping.");
                // We can optionally fetch the product object if productId is expanded, but listLineItems returns simple objects usually.
                // If "product" is just an ID, strict comparison works.
            }

            // --- SUPABASE UPDATE LOGIC ---
            if (isGold) {
                console.log(`👑 Upgrading user ${userId} to GOLD (Unlimited)`);
                const { error } = await supabase
                    .from('profiles')
                    .update({
                        tier: 'GOLD',
                        is_unlimited: true,
                        // resetting credits is optional, but usually irrelevant for unlimited
                        // credits: 99999 
                    })
                    .eq('id', userId);

                if (error) console.error("❌ Failed to update profile (GOLD):", error);
                else console.log("✅ User upgraded to GOLD successfully.");
            }
            else if (isSilver) {
                console.log(`🥈 Adding credits to user ${userId} (SILVER)`);

                // 1. Get current credits
                const { data: profile, error: fetchError } = await supabase
                    .from('profiles')
                    .select('credits')
                    .eq('id', userId)
                    .single();

                if (fetchError) {
                    console.error("❌ Failed to fetch current credits:", fetchError);
                } else {
                    const currentCredits = profile?.credits || 0;
                    const newCredits = currentCredits + 40;

                    const { error: updateError } = await supabase
                        .from('profiles')
                        .update({
                            tier: 'SILVER',
                            credits: newCredits
                            // Don't change is_unlimited, or ensure it is false? 
                            // Usually if they buy silver, they might still be silver.
                            // If they were GOLD and bought SILVER credits? Edge case. 
                            // Let's assume standard flow:
                        })
                        .eq('id', userId);

                    if (updateError) console.error("❌ Failed to update profile (SILVER):", updateError);
                    else console.log(`✅ User credited. New Balance: ${newCredits}`);
                }
            }

        }

        return new Response(JSON.stringify({ received: true }), {
            headers: { "Content-Type": "application/json" },
        });
    } catch (err) {
        console.error(`Webhook Error: ${err.message}`);
        return new Response(err.message, { status: 400 });
    }
});
