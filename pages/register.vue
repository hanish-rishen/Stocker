<template>
  <div class="flex items-center justify-center min-h-screen bg-gray-100 dark:bg-gray-900">
    <div class="w-full max-w-md p-6 bg-white dark:bg-gray-800 rounded-lg shadow-md">
      <h1 class="text-2xl font-bold mb-6 text-center">Register</h1>
      <form @submit.prevent="handleRegister">
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
        <UInput
          v-model="confirmPassword"
          type="password"
          placeholder="Confirm Password"
          class="mb-4"
          required
        />
        <UButton
          type="submit"
          color="primary"
          class="w-full"
          :loading="loading"
        >
          Register
        </UButton>
      </form>
      <div class="mt-4 text-center">
        <NuxtLink to="/login" class="text-blue-500 hover:underline">
          Already have an account? Login
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
const confirmPassword = ref('')
const loading = ref(false)

const handleRegister = async () => {
  if (password.value !== confirmPassword.value) {
    alert("Passwords don't match")
    return
  }
  try {
    loading.value = true
    const { error } = await supabase.auth.signUp({
      email: email.value,
      password: password.value,
    })
    if (error) throw error
    alert('Registration successful! Please check your email for verification.')
    navigateTo('/login')
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