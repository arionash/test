-- Drop tables if they exist
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS sales_reps;

-- Create product catalog
CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT,
    price REAL
);

-- Create customer table
CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    region TEXT,
    industry TEXT
);

-- Create sales reps table
CREATE TABLE sales_reps (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    region TEXT
);

-- Create sales table
CREATE TABLE sales (
    id INTEGER PRIMARY KEY,
    product_id INTEGER,
    customer_id INTEGER,
    sales_rep_id INTEGER,
    quantity INTEGER,
    total_amount REAL,
    sale_date TEXT,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(id)
);

-- Sample products
INSERT INTO products (name, category, price) VALUES
('AI Assistant Pro', 'Software', 299.00),
('AI Analytics Engine', 'Software', 999.00),
('SupportBot Basic', 'Software', 99.00);

-- Sample customers
INSERT INTO customers (name, region, industry) VALUES
('Acme Corp', 'North America', 'Retail'),
('Globex Inc.', 'Europe', 'Finance'),
('Initech', 'Asia', 'Technology'),
('Umbrella Co', 'North America', 'Healthcare');

-- Sample sales reps
INSERT INTO sales_reps (name, region) VALUES
('Alice Johnson', 'North America'),
('Bob Smith', 'Europe'),
('Charlie Kim', 'Asia');

-- Sample sales records
INSERT INTO sales (product_id, customer_id, sales_rep_id, quantity, total_amount, sale_date) VALUES
(1, 1, 1, 5, 1495.00, '2025-05-10'),
(2, 2, 2, 2, 1998.00, '2025-05-15'),
(3, 3, 3, 10, 990.00, '2025-04-01'),
(1, 4, 1, 1, 299.00, '2025-05-20'),
(3, 1, 1, 3, 297.00, '2025-05-25');
