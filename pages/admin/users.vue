<template>
  <div>
    <h1 class="text-3xl font-bold mb-4">User Management</h1>
    <div v-if="users.length > 0">
      <div v-for="user in users" :key="user.id" class="mb-4 p-4 bg-white dark:bg-gray-800 rounded shadow">
        <h2 class="text-xl font-semibold">{{ user.email }}</h2>
        <p>Balance: ${{ user.balance.toFixed(2) }}</p>
        <p>Role: {{ user.role }}</p>
        <UButton @click="changeUserRole(user)" color="warning" class="mt-2">
          Change Role
        </UButton>
      </div>
    </div>
    <p v-else>No users found.</p>
  </div>
</template>

<script setup>
const supabase = useSupabaseClient()
const users = ref([])

definePageMeta({
  layout: 'admin'
})

onMounted(async () => {
  await fetchUsers()
})

const fetchUsers = async () => {
  try {
    const { data, error } = await supabase
      .from('users')
      .select('*')
    if (error) throw error
    users.value = data
  } catch (error) {
    console.error('Error fetching users:', error)
  }
}

const changeUserRole = async (user) => {
  const newRole = user.role === 'user' ? 'admin' : 'user'
  try {
    const { error } = await supabase
      .from('users')
      .update({ role: newRole })
      .eq('id', user.id)
    if (error) throw error
    await fetchUsers()
  } catch (error) {
    console.error('Error changing user role:', error)
  }
}
</script>