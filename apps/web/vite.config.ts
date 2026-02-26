import path from 'path';
import { defineConfig, loadEnv } from 'vite';
import react from '@vitejs/plugin-react';
import { VitePWA } from 'vite-plugin-pwa';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, '.', '');
  return {
    server: {
      port: 3000,
      host: '0.0.0.0',
    },
    plugins: [
      tailwindcss(),
      react(),
      VitePWA({
        registerType: 'prompt',
        strategies: 'injectManifest',
        srcDir: 'public',
        filename: 'service-worker.js',
        injectRegister: false, // We'll use the prompt component, which handles registration
        manifest: {
          name: 'Profeplan',
          short_name: 'Profeplan',
          description: 'Planejamento Pedagógico Inteligente com IA',
          theme_color: '#ffffff', // User requested Blue and White theme, assuming white background is safer for general UI, but header is blue.
          background_color: '#ffffff',
          display: 'standalone',
          orientation: 'portrait',
          icons: [
            {
              src: 'icon-512.png',
              sizes: '512x512',
              type: 'image/png',
              purpose: 'any maskable'
            }
          ]
        }
      })
    ],
    resolve: {
      alias: {
        '@': path.resolve(__dirname, './src'),
      }
    },
    build: {
      chunkSizeWarningLimit: 750,
      rollupOptions: {
        output: {
          manualChunks: {
            react: ['react', 'react-dom', 'react-router-dom'],
            supabase: ['@supabase/supabase-js'],
            pdf: ['jspdf', 'pdf-parse', 'pdfjs-dist'],
            ai: ['@google/generative-ai'],
            ui: ['lucide-react', 'react-hook-form']
          }
        }
      }
    }
  };
});
