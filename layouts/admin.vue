<template>
  <div class="min-h-screen bg-gray-100 dark:bg-gray-900">
    <header class="bg-white dark:bg-gray-800 shadow">
      <nav class="container mx-auto px-4 py-4 flex justify-between items-center">
        <NuxtLink to="/admin" class="text-xl font-bold text-gray-800 dark:text-white">Admin Dashboard</NuxtLink>
        <div class="flex space-x-4">
          <NuxtLink to="/admin/users" class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">Users</NuxtLink>
          <NuxtLink to="/admin/stocks" class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">Stocks</NuxtLink>
          <NuxtLink to="/admin/transactions" class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">Transactions</NuxtLink>
          <UButton @click="logout" color="danger">Logout</UButton>
        </div>
      </nav>
    </header>
    <main class="container mx-auto px-4 py-8">
      <slot />
    </main>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()

const logout = async () => {
  try {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
    navigateTo('/login')
  } catch (error) {
    console.error('Error during logout:', error)
  }
}
</script>