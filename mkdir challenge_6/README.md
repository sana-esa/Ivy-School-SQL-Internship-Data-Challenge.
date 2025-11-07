# Challenge 6: Cohort Analysis

## 🎯 Purpose

The objective of this challenge was to perform a **Cohort Analysis** to categorize customers based on the time difference between their first and second order dates. This analysis helps in understanding customer behavior and retention patterns.

## 💾 Deliverables

This folder contains the following files:

| File Name | Description |
| :--- | :--- |
| `challenge6_cohort_analysis.sql` | The SQL script containing the solution, including the creation of the `Cohort_Table` view and the final queries. |
| `challenge6_cohort_table_ss.png` | Screenshot showing the structure or a sample output of the created `Cohort_Table` view. |
| `challenge6_avg_diff_days.png` | Screenshot showing the result for Question 2: Average difference in days between the first and second order for each cohort. |

## 🚀 Key Tasks Performed

1.  **SQL View Creation:** Created a SQL view named `Cohort_Table` to calculate the difference in days between a customer's first and second order.
2.  **Cohort Assignment:** Categorized customers into four distinct cohorts based on the calculated day difference:
    * **Cohort 1:** 0 – 30 days
    * **Cohort 2:** 31 – 60 days
    * **Cohort 3:** 61 – 90 days
    * **Cohort 4:** More than 90 days
3.  **Analysis:** Solved the following two business questions using the derived cohort data:
    * Percentage of customers in each Cohort.
    * Average difference in days between the first and second order for each cohort.

## 💡 Results Summary (Example)

*(Replace this section with your actual key findings)*

The analysis showed that **Cohort 1 (0-30 days)** had the highest percentage of customers, indicating strong immediate re-ordering behavior. The average difference in days for Cohort 3 was approximately 75 days.
