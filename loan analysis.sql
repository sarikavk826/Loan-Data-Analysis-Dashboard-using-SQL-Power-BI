USE abx;

CREATE TABLE loan_data (
    -- Unique Identifier
    id INT NOT NULL PRIMARY KEY,

    -- Categorical & Descriptive Columns
    address_state VARCHAR(2) NOT NULL,
    application_type VARCHAR(50) NOT NULL,
    emp_length VARCHAR(50),
    emp_title VARCHAR(100),
    grade CHAR(1) NOT NULL,
    home_ownership VARCHAR(50) NOT NULL,
    loan_status VARCHAR(50) NOT NULL,
    purpose VARCHAR(50) NOT NULL,
    sub_grade CHAR(2) NOT NULL,
    term VARCHAR(50) NOT NULL,
    verification_status VARCHAR(50) NOT NULL,

    -- Date Columns (Converted to YYYY-MM-DD format)
    issue_date DATE NOT NULL,
    last_credit_pull_date DATE NOT NULL,
    last_payment_date DATE, -- Allows for NULL if payment is missing
    next_payment_date DATE, -- Allows for NULL if payment is missing

    -- Other ID / Integer Columns
    member_id BIGINT NOT NULL,
    loan_amount INT NOT NULL,
    total_acc INT NOT NULL,

    -- Numerical / Monetary Columns
    annual_income DECIMAL(10, 2) NOT NULL, -- Up to 10 digits total, 2 after decimal
    dti DECIMAL(10, 4) NOT NULL,
    installment DECIMAL(10, 2) NOT NULL,
    int_rate DECIMAL(5, 4) NOT NULL,
    total_payment DECIMAL(10, 2) NOT NULL
);


-- Checking the total imported rows
SELECT count(*) FROM abx.loan_data;


-- Checking the data
SELECT * FROM abx.loan_data;


-- Checking the null
SELECT *
FROM abx.loan_data
WHERE
    id IS NULL
    OR address_state IS NULL
    OR application_type IS NULL
    OR emp_length IS NULL
    OR emp_title IS NULL
    OR grade IS NULL
    OR home_ownership IS NULL
    OR loan_status IS NULL
    OR purpose IS NULL
    OR sub_grade IS NULL
    OR term IS NULL
    OR verification_status IS NULL
    OR issue_date IS NULL
    OR last_credit_pull_date IS NULL
    OR last_payment_date IS NULL
    OR next_payment_date IS NULL
    OR member_id IS NULL
    OR loan_amount IS NULL
    OR total_acc IS NULL
    OR annual_income IS NULL
    OR dti IS NULL
    OR installment IS NULL
    OR int_rate IS NULL
    OR total_payment IS NULL;

-- Checking duplicates 
SELECT 
    id,
    COUNT(*) AS duplicate_count
FROM abx.loan_data
GROUP BY id
HAVING COUNT(*) > 1;

SELECT 
    address_state,
    application_type,
    emp_length,
    emp_title,
    grade,
    home_ownership,
    loan_status,
    purpose,
    sub_grade,
    term,
    verification_status,
    issue_date,
    last_credit_pull_date,
    last_payment_date,
    next_payment_date,
    member_id,
    loan_amount,
    total_acc,
    annual_income,
    dti,
    installment,
    int_rate,
    total_payment,
    COUNT(*) AS duplicate_count
FROM abx.loan_data
GROUP BY 
    address_state,
    application_type,
    emp_length,
    emp_title,
    grade,
    home_ownership,
    loan_status,
    purpose,
    sub_grade,
    term,
    verification_status,
    issue_date,
    last_credit_pull_date,
    last_payment_date,
    next_payment_date,
    member_id,
    loan_amount,
    total_acc,
    annual_income,
    dti,
    installment,
    int_rate,
    total_payment
HAVING COUNT(*) > 1;


-- Total Loan Applications
SELECT count(*) as Total_Loan_Application FROM abx.loan_data;

-- MTD (month to date) Loan Applications
SELECT COUNT(id) AS Total_Applications FROM abx.loan_data
WHERE MONTH(issue_date) = 12;

SELECT COUNT(id) AS Total_Applications FROM abx.loan_data
WHERE MONTH(issue_date) = 12 and Year(issue_date) = 2021; #need to choose latest issue date

-- PMTD (Previous month to date) Loan Applications
SELECT COUNT(id) AS Total_Applications FROM abx.loan_data
WHERE MONTH(issue_date) = 11;

-- Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM abx.loan_data;

-- MTD Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM abx.loan_data
WHERE MONTH(issue_date) = 12;

-- PMTD Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM abx.loan_data
WHERE MONTH(issue_date) = 11;

-- Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM abx.loan_data;

-- MTD Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM abx.loan_data
WHERE MONTH(issue_date) = 12;

-- PMTD Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM abx.loan_data
WHERE MONTH(issue_date) = 11;

-- Average Interest Rate
SELECT ROUND(AVG(int_rate*100),2) Avg_Int_Rate  FROM abx.loan_data;

-- MTD Average Interest
SELECT ROUND(AVG(int_rate*100),2) Avg_Int_Rate  FROM abx.loan_data
WHERE MONTH(issue_date) = 12;

-- PMTD Average Interest
SELECT ROUND(AVG(int_rate*100),2) Avg_Int_Rate  FROM abx.loan_data
WHERE MONTH(issue_date) = 11;

-- Avg DTI
SELECT AVG(dti)*100 AS Avg_DTI FROM abx.loan_data;

-- MTD Avg DTI
SELECT AVG(dti)*100 AS MTD_Avg_DTI FROM abx.loan_data
WHERE MONTH(issue_date) = 12;

-- PMTD Avg DTI
SELECT AVG(dti)*100 AS PMTD_Avg_DTI FROM abx.loan_data
WHERE MONTH(issue_date) = 11;

-- Good Loan Percentage
SELECT ROUND(COUNT(*)/ (SELECT COUNT(*) FROM abx.loan_data)*100,2) AS Good_Loan_Percentage
FROM abx.loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'; 


SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / 
	COUNT(id) AS Good_Loan_Percentage
FROM abx.loan_data;

-- Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications 
FROM abx.loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'; 

-- Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount
FROM abx.loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'; 

-- Bad Loan Percentage
SELECT ROUND(COUNT(*)/ (SELECT COUNT(*) FROM abx.loan_data)*100,2) AS Bad_Loan_Percentage
FROM abx.loan_data
WHERE loan_status = 'Charged Off' ; 

SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM abx.loan_data;

-- Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Applications FROM abx.loan_data
WHERE loan_status = 'Charged Off';

-- Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM abx.loan_data
WHERE loan_status = 'Charged Off';

-- Bad Loan Amount Received
SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM abx.loan_data
WHERE loan_status = 'Charged Off';

-- LOAN STATUS
SELECT
        loan_status,
        COUNT(id) AS LoanCount,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
    FROM
        abx.loan_data
    GROUP BY
        loan_status;

SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM abx.loan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status;

-- BANK LOAN REPORT | OVERVIEW
SELECT 
	MONTH(issue_date) AS Month_Munber, 
	Monthname(issue_date) AS Month_name, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM abx.loan_data
GROUP BY MONTH(issue_date), Monthname(issue_date)
ORDER BY MONTH(issue_date);

-- STATE
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM abx.loan_data
GROUP BY address_state
ORDER BY address_state;

-- TERM
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM abx.loan_data
GROUP BY term
ORDER BY term;

-- EMPLOYEE LENGTH
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM abx.loan_data
GROUP BY emp_length
ORDER BY emp_length;

-- PURPOSE
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM abx.loan_data
GROUP BY purpose
ORDER BY purpose;

-- HOME OWNERSHIP
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM abx.loan_data
GROUP BY home_ownership
ORDER BY home_ownership;

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM abx.loan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose;