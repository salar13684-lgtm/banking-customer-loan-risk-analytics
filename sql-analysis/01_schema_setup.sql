--Schema And Setup
CREATE TABLE customers (
    customer_id VARCHAR(20),
    age INT,
    gender VARCHAR(20),
    employment_status VARCHAR(50),
    annual_income NUMERIC(15,2),
    customer_segment VARCHAR(50),
    city VARCHAR(100),
    region VARCHAR(100),
    customer_since DATE
);

CREATE TABLE accounts (
    account_id VARCHAR(20),
    customer_id VARCHAR(20),
    account_type VARCHAR(50),
    account_status VARCHAR(30),
    account_balance NUMERIC(15,2),
    opened_date DATE
);

CREATE TABLE loans (
    loan_id VARCHAR(20),
    customer_id VARCHAR(20),
    loan_type VARCHAR(50),
    loan_amount NUMERIC(15,2),
    outstanding_amount NUMERIC(15,2),
    interest_rate NUMERIC(5,2),
    loan_term_months INT,
    loan_status VARCHAR(30),
    application_date DATE,
    disbursement_date DATE,
    maturity_date DATE
);

CREATE TABLE loan_applications (
    application_id VARCHAR(20),
    customer_id VARCHAR(20),
    loan_id VARCHAR(20),
    loan_type VARCHAR(50),
    requested_amount NUMERIC(15,2),
    application_date DATE,
    decision_date DATE,
    application_status VARCHAR(30)
);

CREATE TABLE loan_payments (
    payment_id VARCHAR(20),
    loan_id VARCHAR(20),
    payment_date DATE,
    payment_amount NUMERIC(15,2),
    payment_status VARCHAR(30),
    days_late INT
);