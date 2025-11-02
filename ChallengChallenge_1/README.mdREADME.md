# vy-School-SQL-Challenge.
SQL Solutions for the Ivy School Data Challenge.
# 🚀 Day 1: Marketing Snapshots - Retail Data Challenge

Welcome to the **Ivy School SQL Challenge** repository!

This project documents my journey through the data challenge, showcasing my SQL skills and analytical approach.

## 🎯 Day 1 Challenge: Marketing Snapshots

**Purpose:** The Marketing team requested four simple, actionable snapshots from a retail database.

### Deliverables:
* SQL queries for all 4 questions.
* **Result Screenshots** (To be added once generated).

### Files:
* **`Day 1 - Solution.sql`**: Contains the final, clean, and optimized SQL queries.
* **`Sana Khatoon_Challenage_1.sql`**: My initial working file, which includes alternative methods like using **`WITH` clauses (CTEs)** and **`CASE WHEN`** statements for comparison.

### Key Questions & SQL Insights:

| Q No. | Business Question | SQL Concept Used | Key Analytical Decision |
| :---: | :--- | :--- | :--- |
| **Q1** | Active Products as a % of total products | Conditional Aggregation (`IF/SUM`) | Calculated the exact percentage of products marked active. |
| **Q2** | Classify Stores (Old/New) and count them | Conditional Logic (`IF/CASE`) | Classified stores opened **before 2023 as 'Old'**. |
| **Q3** | Top 5 cities by customer count + store classification | Joins (`INNER JOIN`), Ranking (`LIMIT`) | Joined `customers` and `stores` to link customer data with store opening status. |
| **Q4** | Average order line value (`AVG(line_amount)`) | Aggregation (`AVG`), Filtering (`WHERE`) | **Crucial:** Used **`WHERE status <> "Cancelled"`** to ensure the average is based only on *successful* sales, providing a true business metric. |

### 💡 My Key Learning:
The difference between my two files highlights a key learning: analytical rigor matters. For Q4, filtering out 'Cancelled' orders gives a realistic sales average, which is much more valuable to the Marketing team than a raw, unfiltered average.

---
