-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  balance DECIMAL(10, 2) NOT NULL DEFAULT 10000.00,
  role TEXT NOT NULL DEFAULT 'user',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create stocks table
CREATE TABLE IF NOT EXISTS stocks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  symbol TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  current_price DECIMAL(10, 2) NOT NULL,
  last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create portfolio table
CREATE TABLE IF NOT EXISTS portfolio (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  stock_id UUID REFERENCES stocks(id),
  quantity INTEGER NOT NULL,
  average_buy_price DECIMAL(10, 2) NOT NULL,
  UNIQUE(user_id, stock_id)
);

-- Create transactions table
CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  stock_id UUID REFERENCES stocks(id),
  type TEXT NOT NULL CHECK (type IN ('buy', 'sell')),
  quantity INTEGER NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create roles for database security
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin') THEN
    CREATE ROLE admin;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'user') THEN
    CREATE ROLE user;
  END IF;
END
$$;

-- Grant privileges
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT SELECT, INSERT, UPDATE ON users, portfolio, transactions TO user;
GRANT SELECT ON stocks TO user;

-- Create row-level security policies
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolio ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY user_isolation ON users
  FOR ALL
  USING (auth.uid() = id);

CREATE POLICY portfolio_isolation ON portfolio
  FOR ALL
  USING (auth.uid() = user_id);

CREATE POLICY transaction_isolation ON transactions
  FOR ALL
  USING (auth.uid() = user_id);

-- Function to update user balance after a transaction
CREATE OR REPLACE FUNCTION update_user_balance()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.type = 'buy' THEN
    UPDATE users SET balance = balance - (NEW.quantity * NEW.price)
    WHERE id = NEW.user_id;
  ELSIF NEW.type = 'sell' THEN
    UPDATE users SET balance = balance + (NEW.quantity * NEW.price)
    WHERE id = NEW.user_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update user balance after a transaction
CREATE TRIGGER after_transaction_insert
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_user_balance();

-- Function to update portfolio after a transaction
CREATE OR REPLACE FUNCTION update_portfolio()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.type = 'buy' THEN
    INSERT INTO portfolio (user_id, stock_id, quantity, average_buy_price)
    VALUES (NEW.user_id, NEW.stock_id, NEW.quantity, NEW.price)
    ON CONFLICT (user_id, stock_id)
    DO UPDATE SET
      quantity = portfolio.quantity + NEW.quantity,
      average_buy_price = (portfolio.average_buy_price * portfolio.quantity + NEW.price * NEW.quantity) / (portfolio.quantity + NEW.quantity);
  ELSIF NEW.type = 'sell' THEN
    UPDATE portfolio
    SET quantity = quantity - NEW.quantity
    WHERE user_id = NEW.user_id AND stock_id = NEW.stock_id;
    
    DELETE FROM portfolio
    WHERE user_id = NEW.user_id AND stock_id = NEW.stock_id AND quantity <= 0;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update portfolio after a transaction
CREATE TRIGGER after_transaction_insert_update_portfolio
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_portfolio();