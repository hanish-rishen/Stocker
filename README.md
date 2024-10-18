# Stock Market Simulation

This project is a stock market simulation using Nuxt.js for the frontend, Go for the API, Rust for the backend, and Supabase for the database.

## Setup

1. Install dependencies:
   ```
   npm install
   ```

2. Set up Supabase:
   - Create a new project on Supabase
   - Copy the `supabase/schema.sql` content and run it in the Supabase SQL editor
   - Update the `.env` file with your Supabase URL and API key

3. Install Go dependencies:
   ```
   cd api
   go mod tidy
   ```

4. Install Rust dependencies:
   ```
   cd backend
   cargo build
   ```

## Running the project

To run all components together:

```
npm run start:all
```

This will start the Nuxt.js dev server, Go API, and Rust backend concurrently.

## Project Structure

- `/`: Nuxt.js frontend
- `/api`: Go API for stock data
- `/backend`: Rust backend for business logic
- `/supabase`: Supabase schema and configuration

## Admin Panel

The admin panel is currently managed through the Supabase dashboard. Access it by logging into your Supabase account and navigating to your project.