<template>
  <div class="min-h-screen bg-gray-100 dark:bg-gray-900">
    <header class="bg-white dark:bg-gray-800 shadow">
      <nav class="container mx-auto px-4 py-4 flex justify-between items-center">
        <NuxtLink to="/" class="text-xl font-bold text-gray-800 dark:text-white">StockSim</NuxtLink>
        <div class="flex space-x-4">
          <NuxtLink v-if="user" to="/" class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">Home</NuxtLink>
          <NuxtLink v-if="user" to="/portfolio" class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">Portfolio</NuxtLink>
          <NuxtLink v-if="user" to="/market" class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">Market</NuxtLink>
          <NuxtLink v-if="user" to="/account" class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">Account</NuxtLink>
          <NuxtLink v-if="user && isAdmin" to="/admin" class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">Admin</NuxtLink>
          <NuxtLink v-if="!user" to="/login" class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">Login</NuxtLink>
          <NuxtLink v-if="!user" to="/register" class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">Register</NuxtLink>
        </div>
      </nav>
    </header>
    <main class="container mx-auto px-4 py-8">
      <slot />
    </main>
    <footer class="bg-white dark:bg-gray-800 shadow mt-8">
      <div class="container mx-auto px-4 py-4 text-center text-gray-600 dark:text-gray-300">
        &copy; 2024 StockSim. All rights reserved.
      </div>
    </footer>
  </div>
</template>

<script setup>
const user = useSupabaseUser()
const supabase = useSupabaseClient()
const isAdmin = ref(false)

// Navigation guard
const route = useRoute()
const publicRoutes = ['/', '/login', '/register', '/confirm']

watch(() => route.path, (newPath) => {
  if (!publicRoutes.includes(newPath) && !user.value) {
    navigateTo('/login')
  }
}, { immediate: true })

// Check if user is admin
watch(user, async (newUser) => {
  if (newUser) {
    const { data, error } = await supabase
      .from('users')
      .select('role')
      .eq('id', newUser.id)
      .single()
    
    if (!error && data) {
      isAdmin.value = data.role === 'admin'
    }
  } else {
    isAdmin.value = false
  }
}, { immediate: true })
</script>