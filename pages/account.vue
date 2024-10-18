<template>
  <div>
    <h1 class="text-3xl font-bold mb-4">Your Account</h1>
    <div v-if="userData" class="bg-white dark:bg-gray-800 p-4 rounded shadow">
      <p>Email: {{ userData.email }}</p>
      <p>Balance: ${{ userData.balance.toFixed(2) }}</p>
    </div>
    <h2 class="text-2xl font-bold mt-8 mb-4">Transaction History</h2>
    <div v-if="transactions.length > 0">
      <div v-for="transaction in transactions" :key="transaction.id" class="mb-2 p-2 bg-gray-100 dark:bg-gray-700 rounded">
        <p>{{ transaction.type }} {{ transaction.stocks.symbol }} - {{ transaction.quantity }} shares at ${{ transaction.price.toFixed(2) }}</p>
        <p class="text-sm text-gray-600 dark:text-gray-400">{{ new Date(transaction.date).toLocaleString() }}</p>
      </div>
    </div>
    <p v-else>No transactions yet.</p>
    <UButton @click="logout" color="danger" class="mt-4">Logout</UButton>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()
const user = useSupabaseUser()
const userData = ref(null)
const transactions = ref([])

onMounted(async () => {
  if (user.value) {
    await fetchUserData()
    await fetchTransactions()
  }
})

const fetchUserData = async () => {
  try {
    const { data, error } = await supabase
      .from('users')
      .select('*')
      .eq('id', user.value.id)
      .single()

    if (error) throw error
    userData.value = data
  } catch (error) {
    console.error('Error fetching user data:', error)
  }
}

const fetchTransactions = async () => {
  try {
    const { data, error } = await supabase
      .from('transactions')
      .select(`
        *,
        stocks (
          symbol
        )
      `)
      .eq('user_id', user.value.id)
      .order('date', { ascending: false })

    if (error) throw error
    transactions.value = data
  } catch (error) {
    console.error('Error fetching transactions:', error)
  }
}

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