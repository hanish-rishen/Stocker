<template>
  <div>
    <h1 class="text-3xl font-bold mb-4">Admin Dashboard</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <div class="bg-white dark:bg-gray-800 p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-2">User Management</h2>
        <UButton to="/admin/users" color="primary">Manage Users</UButton>
      </div>
      <div class="bg-white dark:bg-gray-800 p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-2">Stock Management</h2>
        <UButton to="/admin/stocks" color="primary">Manage Stocks</UButton>
      </div>
      <div class="bg-white dark:bg-gray-800 p-4 rounded shadow">
        <h2 class="text-xl font-semibold mb-2">Transaction History</h2>
        <UButton to="/admin/transactions" color="primary">View Transactions</UButton>
      </div>
    </div>
  </div>
</template>

<script setup>
definePageMeta({
  layout: 'admin'
})
</script>