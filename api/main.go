package main

import (
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

type Stock struct {
	Symbol string  `json:"symbol"`
	Name   string  `json:"name"`
	Price  float64 `json:"price"`
	Change float64 `json:"change"`
}

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Println("Warning: Error loading .env file. Using default environment variables.")
	}

	r := gin.Default()

	r.GET("/api/stocks", getStocks)

	port := os.Getenv("GO_API_PORT")
	if port == "" {
		port = "8080"
	}
	r.Run(":" + port)
}

func getStocks(c *gin.Context) {
	// Mock data for now, replace with actual API call later
	stocks := []Stock{
		{Symbol: "AAPL", Name: "Apple Inc.", Price: 155.23, Change: 1.2},
		{Symbol: "MSFT", Name: "Microsoft Corporation", Price: 290.45, Change: -0.5},
		{Symbol: "AMZN", Name: "Amazon.com Inc.", Price: 3200.10, Change: 2.1},
	}

	c.JSON(http.StatusOK, stocks)
}
