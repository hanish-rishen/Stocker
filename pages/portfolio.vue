<template>
  <div>
    <h1 class="text-3xl font-bold mb-4">Your Portfolio</h1>
    <div v-if="portfolio.length > 0">
      <div v-for="stock in portfolio" :key="stock.symbol" class="mb-4 p-4 bg-white dark:bg-gray-800 rounded shadow">
        <h2 class="text-xl font-semibold">{{ stock.name }} ({{ stock.symbol }})</h2>
        <p>Quantity: {{ stock.quantity }}</p>
        <p>Average Buy Price: ${{ stock.average_buy_price.toFixed(2) }}</p>
        <p>Current Price: ${{ stock.current_price.toFixed(2) }}</p>
        <p :class="stock.profit >= 0 ? 'text-green-600' : 'text-red-600'">
          Profit/Loss: ${{ stock.profit.toFixed(2) }}
        </p>
        <UButton @click="sellStock(stock)" color="danger" class="mt-2">Sell</UButton>
      </div>
    </div>
    <p v-else>You don't have any stocks in your portfolio yet.</p>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()
const user = useSupabaseUser()
const portfolio = ref([])

onMounted(async () => {
  if (user.value) {
    await fetchPortfolio()
  }
})

const fetchPortfolio = async () => {
  try {
    const { data, error } = await supabase
      .from('portfolio')
      .select(`
        *,
        stocks (
          symbol,
          name,
          current_price
        )
      `)
      .eq('user_id', user.value.id)

    if (error) throw error

    portfolio.value = data.map(item => ({
      ...item.stocks,
      quantity: item.quantity,
      average_buy_price: item.average_buy_price,
      profit: (item.stocks.current_price - item.average_buy_price) * item.quantity
    }))
  } catch (error) {
    console.error('Error fetching portfolio:', error)
  }
}

const sellStock = async (stock) => {
  try {
    const { error: transactionError } = await supabase
      .from('transactions')
      .insert({
        user_id: user.value.id,
        stock_id: stock.id,
        type: 'sell',
        quantity: 1,
        price: stock.current_price
      })

    if (transactionError) throw transactionError

    alert(`Successfully sold 1 share of ${stock.symbol}`)
    await fetchPortfolio()
  } catch (error) {
    console.error('Error selling stock:', error)
    alert('An error occurred while selling the stock')
  }
}
</script>