# 💳 Banking Customer, Loan & Risk Analytics

[![Live Dashboard](https://img.shields.io/badge/🚀%20Live-Dashboard-success?style=for-the-badge)](https://salar13684-lgtm.github.io/banking-customer-loan-risk-analytics/)

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Analytics-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![SQL](https://img.shields.io/badge/SQL-Analytics-blue?style=for-the-badge)](#)
[![Banking Analytics](https://img.shields.io/badge/Banking-Analytics-purple?style=for-the-badge)](#)
[![Risk Analytics](https://img.shields.io/badge/Risk-Analytics-0A66C2?style=for-the-badge)](#)

## 📊 Project Overview

**Banking Customer, Loan & Risk Analytics** is an end-to-end PostgreSQL analytics and business intelligence portfolio project focused on customer demographics, banking relationships, loan portfolio exposure, borrowing behavior, loan applications, payment patterns, delinquency, regional exposure, and descriptive risk-oriented indicators.

The project starts with relational banking data, applies structured SQL analytics in PostgreSQL, produces dashboard-ready analytical datasets, and presents the results through an interactive HTML dashboard.

The project is explicitly scoped to **descriptive banking analytics and SQL analysis**. Risk-related findings describe observed portfolio exposure, loan status, payment behavior, delinquency, and regional indicators; they do **not** represent a predictive credit-risk model.

> **Project type:** Banking Analytics · Loan Portfolio Analytics · Customer Analytics · Credit Risk Analytics · SQL Analytics · Business Intelligence

## 🚀 Live Interactive Dashboard

### [👉 Launch the Live Dashboard](https://salar13684-lgtm.github.io/banking-customer-loan-risk-analytics/)

The dashboard contains six analytical areas:

1. **Executive Overview**
2. **Customer Intelligence**
3. **Loan Portfolio & Regional Exposure**
4. **Loan Application Funnel**
5. **Payment & Delinquency Analysis**
6. **Regional Risk & Exposure**

The dashboard is implemented as a standalone `dashboard.html` file containing the analytical data required by the visualizations. The repository also retains the CSV extracts used to document and validate the dashboard outputs.

---

# 🎯 Business Objectives

The project is designed to answer practical banking and portfolio questions including:

- How many customers, accounts, loans, applications, and payments are represented?
- What is the total loan amount and outstanding portfolio exposure?
- Which customer segments dominate the customer base?
- Which regions carry the greatest loan exposure?
- Which loan types contribute the most outstanding exposure?
- What is the composition of Current, Paid Off, Closed, Delinquent, and Default loans?
- How does the loan application funnel perform?
- How does application activity change over time?
- What payment statuses and delinquency levels are observed?
- Which regions have the highest observed late-payment rates?
- How does payment behavior vary across customer segments?
- Which customers show repeated or severe late-payment behavior?
- How can exposure and payment behavior be combined into a descriptive risk-oriented view?
- What business actions can be recommended from the analysis?

---

# 🖼️ Dashboard Screenshots

Place the following screenshots in the repository's `screenshots/` folder:

### 01 — Executive Overview
![Executive Overview](screenshots/banking-customer-loan-risk-analytics-executive-overview.jpg.jpg)

### 02 — Customer Segment Analysis
![Customer Segment Analysis](screenshots/banking-customer-segment-analysis-postgresql.jpg.jpg)

### 03 — Loan Portfolio & Regional Exposure
![Loan Portfolio and Regional Exposure](screenshots/banking-loan-portfolio-regional-exposure-analysis.jpg.jpg)

### 04 — Loan Application Funnel
![Loan Application Funnel](screenshots/banking-loan-application-funnel-analysis-postgresql.jpg.jpg)

### 05 — Payment & Delinquency Risk Analysis
![Payment and Delinquency Risk](screenshots/banking-payment-delinquency-risk-analysis.jpg.jpg)

### 06 — Regional Credit Risk & Payment Exposure
![Regional Credit Risk and Payment Exposure](screenshots/Regional%20Credit%20Risk%20%26%20Payment%20Exposure.jpg)

---

# 📌 Executive KPI Snapshot

The dashboard's analytical dataset contains:

| KPI | Value |
|---|---:|
| Total Customers | **10,000** |
| Total Accounts | **10,860** |
| Total Loans | **22,000** |
| Total Loan Amount | **62.77B** |
| Outstanding Loan Exposure | **40.71B** |
| Total Loan Applications | **30,000** |
| Total Payment Amount | **16.42B** |
| Observed Late-Payment Rate | **24.70%** |
| Loan Payment Records | **352,103** |

---

# 🔄 Analytical Workflow

```text
Source Customer, Account, Loan,
Application & Payment Data
              │
              ▼
       PostgreSQL Data Setup
              │
              ▼
     Data Exploration & Quality
              │
              ▼
       Customer Analytics
              │
              ▼
     Loan Portfolio Analytics
              │
              ▼
 Customer Borrowing Intelligence
              │
              ▼
 Loan Application & Approval
           Analysis
              │
              ▼
 Payment & Delinquency Analysis
              │
              ▼
 Risk-Oriented Portfolio Analysis
              │
              ▼
      Dashboard-Ready Data
              │
              ▼
     Interactive BI Dashboard
              │
              ▼
        GitHub Pages
```

---

# 🛠️ Technologies & Skills

### Database & SQL
- PostgreSQL
- SQL
- SELECT / WHERE / ORDER BY
- GROUP BY / HAVING
- INNER JOIN / LEFT JOIN
- CASE expressions
- CTEs
- Subqueries
- EXISTS / NOT EXISTS
- Window functions
- RANK / DENSE_RANK
- LAG
- DATE_TRUNC
- COALESCE
- NULLIF
- CAST
- Aggregations
- KPI calculations
- Data-quality validation
- Financial sanity checks

### Analytics
- Customer Analytics
- Customer Segmentation
- Customer Demographics
- Account Analytics
- Loan Portfolio Analytics
- Loan Exposure Analysis
- Borrowing Intelligence
- Loan Application Analytics
- Approval / Rejection Analysis
- Regional Analysis
- Time-Series Analysis
- Payment Behavior Analysis
- Delinquency Analysis
- Customer Risk Indicators
- Regional Risk Analysis
- Business KPI Analysis
- Business Insight Generation

### Dashboard
- HTML
- CSS
- JavaScript
- Chart.js
- Interactive region filtering
- Metric toggles
- KPI cards
- Tables
- Bar charts
- Line charts
- Delinquency charts
- Regional exposure visualization
- Executive reporting

### Deployment
- GitHub
- GitHub Actions
- GitHub Pages
- Static dashboard deployment

---

# 🧩 SQL Analysis Coverage

The SQL workflow is organized into **8 major analytical phases**, followed by a dashboard extraction layer.

| Phase | Analysis |
|---|---|
| 01 | Schema & Data Setup |
| 02 | Data Exploration & Quality |
| 03 | Customer Analytics |
| 04 | Loan Portfolio Analytics |
| 05 | Customer Borrowing Behavior & Loan Intelligence |
| 06 | Loan Application & Approval Analytics |
| 07 | Loan Payments & Delinquency Analytics |
| 08 | Risk-Oriented Portfolio Analysis |
| 09 | Dashboard Data Extraction |

The repository also contains consolidated `Analysis.sql` and `Complete Analysis.sql` scripts covering the end-to-end analytical workflow.

---

# 👥 Customer Analytics

Customers are analyzed across:

- Age
- Gender
- Employment status
- Annual income
- Customer segment
- City
- Region
- Customer tenure
- Account ownership
- Account type
- Account status
- Account balance
- Loan ownership
- Multiple-loan behavior
- Customer borrowing exposure

### Customer Segments

The dashboard contains four customer segments:

| Segment | Customers | Share | Average Income |
|---|---:|---:|---:|
| Mass Market | **5,147** | **51.47%** | **61,818.54** |
| Mass Affluent | **3,047** | **30.47%** | **124,481.45** |
| Affluent | **1,410** | **14.10%** | **251,055.09** |
| Premium | **396** | **3.96%** | **605,216.43** |

**Mass Market** is the largest customer segment, while **Premium** is the smallest and has the highest average income.

---

# 💳 Loan Portfolio & Exposure Analytics

The analysis covers:

- Total loan count
- Total loan amount
- Outstanding exposure
- Average loan amount
- Loan type performance
- Loan status composition
- Interest rates
- Loan terms
- Regional exposure
- Borrower concentration
- Top borrowers
- Monthly loan activity
- Portfolio growth
- Customer borrowing behavior

### Loan Types

The dashboard analyzes:

- Mortgage
- Business
- Auto
- Personal
- Education

**Mortgage** is the largest outstanding exposure category with approximately **24.20B** outstanding.

### Loan Status

| Loan Status | Loans | Share |
|---|---:|---:|
| Current | **14,091** | **64.05%** |
| Paid Off | **4,339** | **19.72%** |
| Closed | **1,660** | **7.55%** |
| Delinquent | **1,387** | **6.30%** |
| Default | **523** | **2.38%** |

Delinquent and Default loans together represent **1,910 loans (8.68%)** and approximately **2.87B** of outstanding exposure.

---

# 🌍 Regional Portfolio Analytics

The project analyzes customer and loan exposure across:

- Punjab
- Sindh
- Khyber Pakhtunkhwa
- Balochistan
- Islamabad Capital

### Regional Exposure

Punjab has the largest outstanding loan exposure at approximately **17.77B**.

The regional analysis keeps **customer count, loan count, total loan amount, and outstanding exposure** as separate analytical measures.

### Why Regional Exposure Matters

A region's risk profile should not be evaluated using late-payment rate alone. The financial impact also depends on how much outstanding exposure is concentrated in that region.

---

# 📝 Loan Application & Approval Analytics

The application analysis covers:

- Application volume
- Requested amount
- Application status
- Approval rate
- Rejection rate
- Withdrawal rate
- Loan-type performance
- Customer-segment behavior
- Regional application performance
- Application-to-loan relationships
- Decision processing time
- Monthly application trends

### Application Funnel

| Application Status | Applications | Share |
|---|---:|---:|
| Approved | **22,000** | **73.33%** |
| Rejected | **5,814** | **19.38%** |
| Withdrawn | **2,186** | **7.29%** |

The dashboard tracks application activity from **January 2021 through October 2024**.

---

# 💰 Payment & Delinquency Analytics

The payment analysis covers:

- Payment count
- Payment amount
- Payment status
- Days late
- Average days late
- Maximum days late
- Late-payment rate
- Missed payments
- Repeated late payments
- Severe delinquency
- Loan-level payment behavior
- Customer-level payment behavior
- Segment payment behavior
- Regional payment behavior

### Payment Status

| Status | Payment Records |
|---|---:|
| Paid | **321,294** |
| Late | **24,819** |
| Missed | **5,990** |

The dashboard reports an observed late-payment rate of **24.70%** based on its analytical definition.

### Delinquency Buckets

The dashboard separates payment behavior into:

- On Time
- 1–7 Days Late
- 8–30 Days Late
- 31–60 Days Late
- 61+ Days Late

There are **7,572 payment records** in the **61+ days late** bucket.

---

# ⚠️ Customer Risk-Oriented Analysis

The customer-level risk analysis combines observed borrowing and payment behavior.

The descriptive customer payment flags include:

- **No Late Payments**
- **Occasional Late Payments**
- **Repeated Late Payments**
- **High Payment Concern**

The dashboard's risk lens is designed to identify patterns that may deserve portfolio review without presenting them as predictive credit scores.

### Important Risk Scope

This project does **not** calculate:

- Probability of Default
- Credit Score
- Expected Loss
- PD / LGD / EAD
- Machine-learning predictions
- Production underwriting decisions

It is a **descriptive risk-oriented analytics project**.

---

# 🌍 Regional Risk & Payment Exposure

The dashboard compares regional:

- Outstanding exposure
- Loan count
- Payment count
- Late-payment count
- Observed late-payment rate
- Average days late

### Key Regional Findings

- **Balochistan** has the highest observed late-payment rate at **25.58%**.
- **Khyber Pakhtunkhwa** follows at **25.55%**.
- **Punjab** has the largest outstanding exposure at approximately **17.77B**.
- Punjab's observed late-payment rate is **24.29%**.

This demonstrates why both **risk behavior and exposure size** should be considered when evaluating a regional portfolio.

---

# 📈 Time-Series Analysis

The project includes monthly application analysis from **January 2021 through October 2024**.

Monthly analysis includes:

- Application count
- Approved applications
- Rejected applications
- Approval rate
- Rejection rate

The SQL workflow also uses date functions and window-function patterns such as `LAG()` in portfolio analysis.

---

# 💡 Key Business Insights

### 1. Mass Market dominates the customer base

Mass Market customers represent **51.47%** of the customer base.

**Recommendation:** Maintain scalable banking products and services for the mass-market population while developing targeted offerings for higher-value segments.

### 2. Mortgage exposure dominates the loan portfolio

Mortgage loans carry approximately **24.20B** in outstanding exposure.

**Recommendation:** Closely monitor mortgage portfolio performance because concentration in a major loan category can materially affect overall portfolio exposure.

### 3. Punjab carries the largest outstanding exposure

Punjab has approximately **17.77B** in outstanding exposure.

**Recommendation:** Monitor Punjab using both exposure and payment-behavior metrics rather than relying on a single regional risk rate.

### 4. Current loans represent the majority of the portfolio

Current loans account for **64.05%** of loan records.

**Recommendation:** Continue monitoring the current portfolio for migration into delinquency or default.

### 5. Delinquent and default loans require focused monitoring

Delinquent and Default loans together account for **1,910 loans** and approximately **2.87B** in outstanding exposure.

**Recommendation:** Prioritize accounts with both material exposure and adverse payment behavior.

### 6. The application funnel is predominantly approved

Approved applications represent **73.33%** of applications.

**Recommendation:** Track application outcomes by loan type, region and customer segment to understand where approval patterns differ.

### 7. Late-payment behavior is visible across the portfolio

The dashboard reports an observed late-payment rate of **24.70%**.

**Recommendation:** Separate short delays, repeated late payments and severe delinquency when designing collection and monitoring strategies.

### 8. Regional late-payment rates are relatively close

The highest observed rate is **25.58%** in Balochistan while Punjab has the lowest observed rate at **24.29%** among the five regions.

**Recommendation:** Combine late-payment rate with outstanding exposure before prioritizing regional risk actions.

---

# 📊 Interactive Dashboard Features

## Executive Overview

Provides:

- Executive KPI cards
- Customer count
- Account count
- Loan count
- Total lending
- Outstanding exposure
- Application count
- Payment amount
- Observed late-payment rate
- Portfolio overview
- High-level regional and loan insights

## Customer Intelligence

Provides:

- Customer segment distribution
- Customer segment profile
- Average income by segment
- Average age by segment
- Customer composition analysis

## Loan Portfolio & Regional Exposure

Provides:

- Region filter
- Outstanding exposure by region
- Loan portfolio by type
- Loan status composition
- Regional exposure detail
- Exposure-focused portfolio analysis

## Loan Applications

Provides:

- Application funnel
- Approved applications
- Rejected applications
- Withdrawn applications
- Monthly application activity
- Volume toggle
- Outcomes toggle
- Rates toggle

## Payment & Delinquency

Provides:

- Payment status distribution
- Payment status detail
- Payment amount analysis
- Delinquency distribution
- Delinquency bucket detail
- Days-late analysis

## Regional Risk Lens

Provides:

- Region filtering
- Observed late-payment rate
- Outstanding exposure
- Average days late
- Regional risk indicators
- Exposure vs. payment behavior comparison

---

# 📁 Repository Structure

```text
banking-customer-loan-risk-analytics/
│
├── .github/
│   └── workflows/
│       └── deploy-dashboard.yml
│
├── dashboard-data/
│   ├── dashboard.html
│   ├── 09_dashboard_data.sql
│   ├── application_funnel.csv
│   ├── application_trend.csv
│   ├── customer_risk_overview.csv
│   ├── customer_segments.csv
│   ├── delinquency.csv
│   ├── executive_kpis.csv
│   ├── loan_status.csv
│   ├── loan_type_performance.csv
│   ├── payment_behavior.csv
│   ├── regional_exposure.csv
│   ├── regional_risk.csv
│   └── segment_payment_behavior.csv
│
├── raw-data/
│   ├── customers.csv
│   ├── accounts.csv
│   ├── loans.csv
│   ├── loan_applications.csv
│   └── loan_payments.csv
│
├── screenshots/
│   ├── banking-customer-loan-risk-analytics-executive-overview.jpg.jpg
│   ├── banking-customer-segment-analysis-postgresql.jpg.jpg
│   ├── banking-loan-portfolio-regional-exposure-analysis.jpg.jpg
│   ├── banking-loan-application-funnel-analysis-postgresql.jpg.jpg
│   ├── banking-payment-delinquency-risk-analysis.jpg.jpg
│   └── Regional Credit Risk & Payment Exposure.jpg
│
├── sql-analysis/
│   ├── 01_schema_setup.sql
│   ├── 02_data_exploration_quality.sql
│   ├── 03_customer_analytics.sql
│   ├── 04_loan_portfolio_analytics.sql
│   ├── 05_customer_borrowing_intelligence.sql
│   ├── 06_loan_application_analytics.sql
│   ├── 07_payment_delinquency_analytics.sql
│   ├── 08_risk_oriented_portfolio_analysis.sql
│   ├── 09_dashboard_data.sql
│   ├── Analysis.sql
│   └── Complete Analysis.sql
│
├── LICENSE
└── README.md
```

---

# 🔍 Data & Methodology Notes

- The dataset is **synthetic banking data** created for portfolio and SQL analytics demonstration.
- The project uses PostgreSQL as the analytical database.
- The analysis covers **10,000 customers**, **10,860 accounts**, **22,000 loans**, **30,000 applications**, and **352,103 payment records**.
- Core loan portfolio analysis uses loan amount and outstanding exposure as the primary financial measures.
- Application analysis separates Approved, Rejected and Withdrawn outcomes.
- Payment analysis separates Paid, Late and Missed statuses and also evaluates `days_late`.
- Delinquency is analyzed using defined days-late buckets.
- Regional risk analysis keeps exposure and payment behavior as distinct measures.
- Risk-related insights are descriptive and do not constitute a predictive credit-risk model.
- The dashboard's analytical data is embedded in `dashboard.html`; the hosted dashboard does not require the repository CSV files at runtime.
- The dashboard uses Chart.js through a CDN for its visualizations.
- Monetary values are displayed without a currency symbol because the supplied analytical data does not specify a currency.

---

# 👨‍💼 Recruiter-Relevant Skills Demonstrated

This project demonstrates practical ability in:

- PostgreSQL
- SQL analytics
- Data exploration
- Data-quality validation
- Relational joins
- CTEs
- Subqueries
- CASE expressions
- Window functions
- Aggregations
- Customer segmentation
- Customer analytics
- Loan portfolio analytics
- Borrowing intelligence
- Application funnel analysis
- Payment analysis
- Delinquency analysis
- Regional exposure analysis
- Descriptive risk analytics
- Business KPI development
- Business insight generation
- Interactive dashboard design
- Data visualization
- Executive reporting
- GitHub Actions
- GitHub Pages
- Analytical storytelling

---

# 📂 Project Resources

| Folder / File | Purpose |
|---|---|
| `raw-data/` | Original customer, account, loan, application and payment data |
| `sql-analysis/` | PostgreSQL analytical workflow |
| `dashboard-data/` | Dashboard HTML and analytical extracts |
| `screenshots/` | Dashboard presentation images |
| `.github/workflows/` | GitHub Pages deployment workflow |
| `README.md` | Project documentation |

---

# 🚀 How to Explore the Project

### 1. View the dashboard

**[Launch the Live Dashboard](https://salar13684-lgtm.github.io/banking-customer-loan-risk-analytics/)**

### 2. Review the SQL

Open the `sql-analysis/` folder and follow the numbered analytical workflow.

### 3. Review the source data

Open `raw-data/` to inspect the five relational banking datasets.

### 4. Review the dashboard data

Open `dashboard-data/` to inspect the analytical extracts and standalone dashboard.

### 5. Review the dashboard visuals

Open `screenshots/` to see the executive, customer, portfolio, application, payment and regional-risk views.

---

**Muhammad Salar Shah**

BS Financial Technology Student

Data Analytics | Business Analytics | SQL | Python | Power BI | Aspiring Credit Risk & Fraud Analytics

---

## 🤝 Connect With Me

### LinkedIn

www.linkedin.com/in/salar-shah-7bb2683a2

### GitHub

https://github.com/salar13684-lgtm

### Portfolio

https://salar-shah-portfolio.vercel.app

---

## ⭐ Support

If you found this project useful, consider giving it a ⭐ on GitHub.

It helps support my work and encourages me to build more Business Analytics and FinTech projects.

---

# 📜 License

This project is licensed under the MIT License.
