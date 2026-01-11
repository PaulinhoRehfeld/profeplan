
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"
import Stripe from "https://esm.sh/stripe@12.0.0?target=deno"

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') ?? '', {
    apiVersion: '2022-11-15',
    httpClient: Stripe.createFetchHttpClient(),
})

const endpointSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET')

serve(async (req) => {
    const signature = req.headers.get('stripe-signature')

    let event
    const body = await req.text()

    try {
        event = stripe.webhooks.constructEvent(body, signature!, endpointSecret!)
    } catch (err) {
        return new Response(`Webhook Error: ${err.message}`, { status: 400 })
    }

    const supabase = createClient(
        Deno.env.get('SUPABASE_URL') ?? '',
        Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // Handle the event
    switch (event.type) {
        case 'checkout.session.completed':
            const session = event.data.object
            const userId = session.client_reference_id

            if (session.payment_status === 'paid') {
                const planType = session.metadata?.planType;
                const userId = session.client_reference_id; // Ensure we get it from session if defined there, or metadata

                if (planType === 'credits_40') {
                    // Fetch current credits to increment
                    const { data: profile } = await supabase.from('profiles').select('credits').eq('id', userId).single();
                    if (profile) {
                        const currentCredits = profile.credits || 0;
                        await supabase.from('profiles').update({ credits: currentCredits + 40 }).eq('id', userId);
                    }
                } else if (planType === 'gold') {
                    await supabase.from('profiles').update({
                        tier: 'GOLD',
                        is_unlimited: true
                    }).eq('id', userId);
                }
            }
            break;
        default:
            console.log(`Unhandled event type ${event.type}`)
    }

    return new Response(JSON.stringify({ received: true }), {
        headers: { 'Content-Type': 'application/json' },
        status: 200,
    })
})
