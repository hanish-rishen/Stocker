<template>
  <div>
    <h1 class="text-3xl font-bold mb-4">Transaction History</h1>
    <div v-if="transactions.length > 0">
      <div v-for="transaction in transactions" :key="transaction.id" class="mb-4 p-4 bg-white dark:bg-gray-800 rounded shadow">
        <p>User: {{ transaction.users.email }}</p>
        <p>Stock: {{ transaction.stocks.symbol }}</p>
        <p>Type: {{ transaction.type }}</p>
        <p>Quantity: {{ transaction.quantity }}</p>
        <p>Price: ${{ transaction.price.toFixed(2) }}</p>
        <p>Date: {{ new Date(transaction.date).toLocaleString() }}</p>
      </div>
    </div>
    <p v-else>No transactions found.</p>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()
const transactions = ref([])

definePageMeta({
  layout: 'admin'
})

onMounted(async () => {
  await fetchTransactions()
})

const fetchTransactions = async () => {
  try {
    const { data, error } = await supabase
      .from('transactions')
      .select(`
        *,
        users (email),
        stocks (symbol)
      `)
      .order('date', { ascending: false })
    if (error) throw error
    transactions.value = data
  } catch (error) {
    console.error('Error fetching transactions:', error)
  }
}
</script>