<template>
  <div>
    <h1 class="text-3xl font-bold mb-4">Stock Market</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <div v-for="stock in stocks" :key="stock.symbol" class="bg-white dark:bg-gray-800 p-4 rounded shadow">
        <h2 class="text-xl font-semibold">{{ stock.name }} ({{ stock.symbol }})</h2>
        <p>Price: ${{ stock.current_price.toFixed(2) }}</p>
        <p :class="stock.change >= 0 ? 'text-green-600' : 'text-red-600'">
          Change: {{ stock.change >= 0 ? '+' : '' }}{{ stock.change.toFixed(2) }}%
        </p>
        <UButton @click="buyStock(stock)" color="primary" class="mt-2">Buy</UButton>
      </div>
    </div>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()
const user = useSupabaseUser()
const stocks = ref([])

onMounted(async () => {
  try {
    const { data, error } = await supabase
      .from('stocks')
      .select('*')
    if (error) throw error
    stocks.value = data
  } catch (error) {
    console.error('Error fetching stocks:', error)
  }
})

const buyStock = async (stock) => {
  if (!user.value) {
    alert('Please login to buy stocks')
    return
  }

  try {
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('balance')
      .eq('id', user.value.id)
      .single()

    if (userError) throw userError

    if (userData.balance < stock.current_price) {
      alert('Insufficient balance')
      return
    }

    const { error: transactionError } = await supabase
      .from('transactions')
      .insert({
        user_id: user.value.id,
        stock_id: stock.id,
        type: 'buy',
        quantity: 1,
        price: stock.current_price
      })

    if (transactionError) throw transactionError

    alert(`Successfully bought 1 share of ${stock.symbol}`)
  } catch (error) {
    console.error('Error buying stock:', error)
    alert('An error occurred while buying the stock')
  }
}
</script>