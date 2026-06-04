-- =========================================
-- 💳 FINANCIAL FRAUD DETECTION PROJECT
-- =========================================

CREATE DATABASE fraud_db;
USE fraud_db;

-- =========================================
-- 1. TABLE CREATION
-- =========================================
CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    merchant VARCHAR(100),
    amount INT,
    txn_type VARCHAR(50),
    city VARCHAR(50),
    status VARCHAR(20)
);

-- =========================================
-- 2. SAMPLE DATA
-- =========================================
INSERT INTO transactions VALUES
(1,101,'Amit Sharma','Amazon',5000,'Online','Pune','Success'),
(2,102,'Neha Verma','Flipkart',12000,'Online','Mumbai','Success'),
(3,103,'Ravi Kumar','Amazon',50000,'Online','Delhi','Fraud'),
(4,104,'Pooja Singh','Myntra',8000,'Online','Pune','Success'),
(5,105,'Arjun Mehta','Apple Store',90000,'Offline','Mumbai','Fraud'),
(6,101,'Amit Sharma','Amazon',7000,'Online','Pune','Success'),
(7,106,'Karan Patel','Flipkart',150000,'Online','Delhi','Fraud'),
(8,107,'Sneha Iyer','Myntra',3000,'Online','Pune','Success'),
(9,108,'Vikas Rao','Amazon',200000,'Offline','Bangalore','Fraud'),
(10,102,'Neha Verma','Flipkart',4000,'Online','Mumbai','Success'),
(11,109,'Rahul Jain','Samsung',60000,'Offline','Delhi','Fraud'),
(12,110,'Isha Desai','Apple Store',10000,'Online','Pune','Success'),
(13,101,'Amit Sharma','Amazon',200000,'Online','Pune','Fraud'),
(14,111,'Manish Gupta','Flipkart',2500,'Online','Mumbai','Success'),
(15,112,'Tanya Roy','Myntra',7000,'Online','Kolkata','Success');

-- =========================================
-- 3. BASIC ANALYSIS QUERIES
-- =========================================

-- 1) Highest Transaction
SELECT customer_name, amount
FROM transactions
WHERE amount = (SELECT MAX(amount) FROM transactions);

-- 2) Lowest Transaction
SELECT customer_name, amount
FROM transactions
WHERE amount = (SELECT MIN(amount) FROM transactions);

-- 3) Above Average Transactions
SELECT customer_name, amount
FROM transactions
WHERE amount > (SELECT AVG(amount) FROM transactions);

-- 4) Same City as Amit Sharma
SELECT customer_name, city
FROM transactions
WHERE city = (
    SELECT city FROM transactions
    WHERE customer_name = 'Amit Sharma'
);

-- 5) Fraud Transactions (Highest Fraud Amount)
SELECT customer_name, amount
FROM transactions
WHERE status = 'Fraud'
AND amount = (
    SELECT MAX(amount) FROM transactions
    WHERE status = 'Fraud'
);

-- 6) Customers Spending Above Average Fraud Amount
SELECT customer_name, amount
FROM transactions
WHERE amount > (
    SELECT AVG(amount) FROM transactions
    WHERE status = 'Fraud'
);

-- 7) Customers from Fraud Merchant List
SELECT customer_name, merchant
FROM transactions
WHERE merchant IN (
    SELECT merchant
    FROM transactions
    WHERE status = 'Fraud'
);

-- 8) Same Merchant as Neha Verma
SELECT customer_name, merchant
FROM transactions
WHERE merchant = (
    SELECT merchant
    FROM transactions
    WHERE customer_name = 'Neha Verma'
);

-- 9) Second Highest Transaction
SELECT customer_name, amount
FROM transactions
ORDER BY amount DESC
LIMIT 1,1;

-- 10) Transactions Greater Than Any Fraud Transaction
SELECT customer_name, amount
FROM transactions
WHERE amount > ANY (
    SELECT amount FROM transactions
    WHERE status = 'Fraud'
);

-- =========================================
-- 4. ADVANCED FRAUD ANALYSIS
-- =========================================

-- 11) Transactions less than average amount
SELECT customer_name, amount
FROM transactions
WHERE amount < (SELECT AVG(amount) FROM transactions);

-- 12) High value cities (>3 transactions)
SELECT city
FROM transactions
GROUP BY city
HAVING COUNT(*) > 3;

-- 13) Customers from high activity cities
SELECT customer_name, city
FROM transactions
WHERE city IN (
    SELECT city
    FROM transactions
    GROUP BY city
    HAVING COUNT(*) > 2
);

-- 14) Customers NOT involved in fraud
SELECT customer_name
FROM transactions
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM transactions
    WHERE status = 'Fraud'
);

-- 15) Duplicate transaction amounts
SELECT customer_name, amount
FROM transactions
WHERE amount IN (
    SELECT amount
    FROM transactions
    GROUP BY amount
    HAVING COUNT(*) > 1
);

-- =========================================
-- END OF PROJECT
-- =========================================