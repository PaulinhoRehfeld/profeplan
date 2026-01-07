import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.profeplan.app',
  appName: 'PROFEPLAN',
  webDir: 'dist',
  plugins: {
    Keyboard: {
      resize: 'body',
    },
  },
};

export default config;
