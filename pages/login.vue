<template>
  <div class="flex items-center justify-center min-h-screen bg-gray-100 dark:bg-gray-900">
    <div class="w-full max-w-md p-6 bg-white dark:bg-gray-800 rounded-lg shadow-md">
      <h1 class="text-2xl font-bold mb-6 text-center">Login</h1>
      <form @submit.prevent="handleLogin">
        <UInput
          v-model="email"
          type="email"
          placeholder="Email"
          class="mb-4"
          required
        />
        <UInput
          v-model="password"
          type="password"
          placeholder="Password"
          class="mb-4"
          required
        />
        <UButton
          type="submit"
          color="primary"
          class="w-full"
          :loading="loading"
        >
          Login
        </UButton>
      </form>
      <div class="mt-4 text-center">
        <NuxtLink to="/register" class="text-blue-500 hover:underline">
          Don't have an account? Register
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()
const user = useSupabaseUser()

const email = ref('')
const password = ref('')
const loading = ref(false)

const handleLogin = async () => {
  try {
    loading.value = true
    const { error } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    })
    if (error) throw error
    navigateTo('/')
  } catch (error) {
    alert(error.error_description || error.message)
  } finally {
    loading.value = false
  }
}

// Redirect if user is already logged in
watch(user, (newUser) => {
  if (newUser) {
    navigateTo('/')
  }
}, { immediate: true })
</script>