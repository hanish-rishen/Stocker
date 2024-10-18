<template>
  <div class="flex items-center justify-center min-h-screen bg-gray-100 dark:bg-gray-900">
    <div class="w-full max-w-md p-6 bg-white dark:bg-gray-800 rounded-lg shadow-md">
      <h1 class="text-2xl font-bold mb-6 text-center">Confirming your account...</h1>
      <p class="text-center">{{ message }}</p>
    </div>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()
const message = ref('Please wait while we confirm your account...')

onMounted(async () => {
  const route = useRoute()
  const { error } = await supabase.auth.verifyOtp({
    token_hash: route.hash.substring(1),
    type: 'signup',
  })

  if (error) {
    message.value = 'There was an error confirming your account. Please try again.'
  } else {
    message.value = 'Your account has been confirmed! Redirecting to login...'
    setTimeout(() => {
      navigateTo('/login')
    }, 2000)
  }
})
</script>