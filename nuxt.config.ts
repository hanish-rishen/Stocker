// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-04-03',
  devtools: { enabled: true },
  modules: [
    '@nuxtjs/tailwindcss',
    '@nuxt/ui',
    '@pinia/nuxt',
    '@nuxtjs/color-mode',
    '@nuxtjs/supabase'
  ],
  colorMode: {
    preference: 'system',
    fallback: 'light',
    hid: 'nuxt-color-mode-script',
    globalName: '__NUXT_COLOR_MODE__',
    componentName: 'ColorScheme',
    classPrefix: '',
    classSuffix: '-mode',
    storageKey: 'nuxt-color-mode'
  },
  ui: {
    global: true,
    icons: ['heroicons', 'simple-icons']
  },
  runtimeConfig: {
    public: {
      goApiUrl: process.env.GO_API_URL || 'http://localhost:8080',
      rustBackendUrl: process.env.RUST_BACKEND_URL || 'http://localhost:8081',
    }
  },
  supabase: {
    redirectOptions: {
      login: '/login',
      callback: '/confirm',
      exclude: ['/', '/register', '/admin', '/admin/users', '/admin/stocks', '/admin/transactions'],
    }
  }
})