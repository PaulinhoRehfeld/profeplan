
import { loadStripe } from '@stripe/stripe-js';
import { supabase } from './supabaseClient';

// Replace with your actual Publishable Key from Stripe Dashboard
// Ideally this should be in import.meta.env.VITE_STRIPE_PUBLISHABLE_KEY
const STRIPE_PUBLISHABLE_KEY = import.meta.env.VITE_STRIPE_PUBLISHABLE_KEY;
if (!STRIPE_PUBLISHABLE_KEY) {
    console.error("VITE_STRIPE_PUBLISHABLE_KEY is missing via import.meta.env");
}

export const stripePromise = loadStripe(STRIPE_PUBLISHABLE_KEY);

export const createCheckoutSession = async (priceId: string, userId: string, mode: 'payment' | 'subscription' = 'payment', planType: string) => {
    try {
        const { data: { session } } = await supabase.auth.getSession();

        // Determine Return URL (Mobile vs Web)
        const isMobile = /Android|iPhone|iPad|iPod/i.test(navigator.userAgent) || (window as any).Capacitor?.isNative;
        const returnUrl = isMobile
            ? 'com.profeplan.app://stripe-callback'
            : window.location.origin;

        // Call Supabase Edge Function to create session
        const { data, error } = await supabase.functions.invoke('create-checkout', {
            body: { priceId, userId, mode, planType, returnUrl },
            headers: {
                Authorization: `Bearer ${session?.access_token}`
            }
        });

        if (error) {
            throw error;
        }

        if (!data?.sessionId) {
            throw new Error('Session ID not returned from backend');
        }

        // Redirect to Stripe Checkout
        const stripe = await stripePromise;
        if (!stripe) throw new Error('Stripe failed to initialize');

        const result = await (stripe as any).redirectToCheckout({
            sessionId: data.sessionId,
        });

        if (result.error) {
            throw new Error(result.error.message);
        }

    } catch (error: any) {
        console.error('Error creating checkout session:', error);
        throw error;
    }
};
