import { defineStore } from 'pinia';

export const usePortfolioStore = defineStore('portfolio', {
  state: () => ({
    stocks: [],
  }),
  actions: {
    addStock(stock) {
      const existingStock = this.stocks.find(s => s.symbol === stock.symbol);
      if (existingStock) {
        existingStock.quantity += stock.quantity;
        existingStock.averageBuyPrice = (existingStock.averageBuyPrice * existingStock.quantity + stock.price * stock.quantity) / (existingStock.quantity + stock.quantity);
      } else {
        this.stocks.push({
          ...stock,
          averageBuyPrice: stock.price,
        });
      }
    },
    removeStock(symbol, quantity) {
      const stockIndex = this.stocks.findIndex(s => s.symbol === symbol);
      if (stockIndex !== -1) {
        if (this.stocks[stockIndex].quantity > quantity) {
          this.stocks[stockIndex].quantity -= quantity;
        } else {
          this.stocks.splice(stockIndex, 1);
        }
      }
    },
  },
});