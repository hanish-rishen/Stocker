<template>
  <div>
    <h1 class="text-3xl font-bold mb-4">Stock Management</h1>
    <UButton @click="showAddStockModal = true" color="primary" class="mb-4">Add New Stock</UButton>
    <div v-if="stocks.length > 0">
      <div v-for="stock in stocks" :key="stock.id" class="mb-4 p-4 bg-white dark:bg-gray-800 rounded shadow">
        <h2 class="text-xl font-semibold">{{ stock.name }} ({{ stock.symbol }})</h2>
        <p>Current Price: ${{ stock.current_price.toFixed(2) }}</p>
        <UButton @click="editStock(stock)" color="warning" class="mt-2 mr-2">
          Edit
        </UButton>
        <UButton @click="deleteStock(stock.id)" color="danger" class="mt-2">
          Delete
        </UButton>
      </div>
    </div>
    <p v-else>No stocks found.</p>

    <!-- Add/Edit Stock Modal -->
    <UModal v-model="showAddStockModal">
      <div class="p-4">
        <h2 class="text-2xl font-bold mb-4">{{ editingStock ? 'Edit' : 'Add' }} Stock</h2>
        <form @submit.prevent="saveStock">
          <UInput v-model="stockForm.symbol" label="Symbol" class="mb-2" required />
          <UInput v-model="stockForm.name" label="Name" class="mb-2" required />
          <UInput v-model="stockForm.current_price" label="Current Price" type="number" step="0.01" class="mb-2" required />
          <UButton type="submit" color="primary" class="mt-2">Save</UButton>
        </form>
      </div>
    </UModal>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()
const stocks = ref([])
const showAddStockModal = ref(false)
const editingStock = ref(null)
const stockForm = ref({ symbol: '', name: '', current_price: 0 })

definePageMeta({
  layout: 'admin'
})

onMounted(async () => {
  await fetchStocks()
})

const fetchStocks = async () => {
  try {
    const { data, error } = await supabase
      .from('stocks')
      .select('*')
    if (error) throw error
    stocks.value = data
  } catch (error) {
    console.error('Error fetching stocks:', error)
  }
}

const editStock = (stock) => {
  editingStock.value = stock
  stockForm.value = { ...stock }
  showAddStockModal.value = true
}

const saveStock = async () => {
  try {
    if (editingStock.value) {
      const { error } = await supabase
        .from('stocks')
        .update(stockForm.value)
        .eq('id', editingStock.value.id)
      if (error) throw error
    } else {
      const { error } = await supabase
        .from('stocks')
        .insert(stockForm.value)
      if (error) throw error
    }
    await fetchStocks()
    showAddStockModal.value = false
    editingStock.value = null
    stockForm.value = { symbol: '', name: '', current_price: 0 }
  } catch (error) {
    console.error('Error saving stock:', error)
  }
}

const deleteStock = async (id) => {
  if (confirm('Are you sure you want to delete this stock?')) {
    try {
      const { error } = await supabase
        .from('stocks')
        .delete()
        .eq('id', id)
      if (error) throw error
      await fetchStocks()
    } catch (error) {
      console.error('Error deleting stock:', error)
    }
  }
}
</script>