# Challenge 1 — Marketing Snapshots

**Repository:** Ivy School SQL Challenge  
**Purpose:** SQL Solutions for the Ivy School Data Challenge

---

## 🚀 Day 1: Marketing Snapshots — Retail Data Challenge

This project documents my SQL journey through the challenge, showcasing analytical skills and solutions for Marketing’s quick insights.

### 🎯 Challenge Overview
The Marketing team requested **four simple, actionable snapshots** from a retail database.  

**Deliverables:**
- Optimized SQL queries (`challenge1_sales_summary.sql`)  
- Initial working file with alternative methods (`Sana_Khatoon_Challenge1.sql`)  
- Result screenshots (see below)

---

## Key Questions & SQL Concepts

| Q No. | Business Question | SQL Concept Used | Key Analytical Decision |
|-------|-----------------|-----------------|------------------------|
| Q1 | Active Products as % of total products | Conditional Aggregation (IF/SUM) | Calculated exact % of active products |
| Q2 | Classify Stores (Old/New) and count | Conditional Logic (IF/CASE) | Stores opened before 2023 classified as 'Old' |
| Q3 | Top 5 cities by customer count + store classification | Joins, Ranking (LIMIT) | Linked customer and store data for classification |
| Q4 | Average order line value (AVG(line_amount)) | Aggregation (AVG), Filtering (WHERE) | Filtered out "Cancelled" orders for accurate average |

---

## 📊 Key Results

- **Monthly sales summary (top revenue months):**  
  ![Monthly Sales](images/Monthly_sales_summary.png)

- **Marketing snapshot:**  
  ![Marketing Snapshot](images/Marketing_snapshot.png)

---

## 💡 Key Learning
- Filtering cancelled orders gives realistic business metrics.  
- Using alternative SQL approaches (CTEs, CASE WHEN) improved understanding of analytical options.  
- Small adjustments in logic can create much more actionable insights for business teams.

---

## Files
- `challenge1_sales_summary.sql` — Final optimized queries  
- `Sana_Khatoon_Challenge1.sql` — Initial working file with alternative approaches  
- `images/` — Screenshots of results
