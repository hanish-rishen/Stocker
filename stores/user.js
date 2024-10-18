import { defineStore } from 'pinia';

export const useUserStore = defineStore('user', {
  state: () => ({
    user: null,
    balance: 10000, // Initial balance
  }),
  actions: {
    setUser(user) {
      this.user = user;
    },
    updateBalance(amount) {
      this.balance += amount;
    },
  },
});