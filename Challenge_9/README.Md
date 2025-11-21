Day 9: Advertisement Analysis & Customer Segmentation 📊

Institute: Ivy Professional School

Challenge: Day 9 - SQL Coding Challenge

Topic: Advertisement Analysis, Churn Prediction & Purchase Cycle Analysis

📝 Problem Statement

The goal of this challenge was to analyze web event data to identify customer engagement patterns. Specifically, I was tasked with:

Identifying Churned High-Value Customers:

Find customers who had more than 5 sessions in 2025.

BUT have had no activity in the past 45 days (assuming the current date is Sept 1st, 2025).

Purchase Cycle Analysis:

Calculate the average number of events a user takes to finally make a purchase.

Segment these users into 4 equal groups (Quartiles) based on their purchase speed.

💡 My Solution Approach

1. Handling Date Formats

The raw data stored dates as strings (e.g., 'dd-mm-yyyy HH:MM'). Instead of assuming the format was standard, I used:

STR_TO_DATE(event_datetime, '%d-%m-%Y %H:%i')


This ensured robust parsing and accurate time-based comparisons.

2. Accurate Session Counting (Churn Analysis)

For the first task, simply counting rows (COUNT(*)) would be inaccurate because multiple events can occur in a single session.

My Logic: COUNT(DISTINCT session_id)

Why: This ensures we are counting actual user visits, not just clicks/interactions, providing a true measure of "sessions."

3. Purchase Path Logic (Gap Analysis)

To find the number of events between purchases, I treated this as a "Gaps and Islands" problem:

Used Window Functions (SUM() OVER) to create custom partitions for every purchase cycle.

Calculated the running total of non-purchase events.

Used LAG() to find the difference between the current purchase and the previous state to get the exact count of events leading up to that specific sale.

Finally, used NTILE(4) to segment users into quartiles.

🛠️ Tech Stack & Concepts Used

Database: MySQL

Concepts:

Common Table Expressions (CTEs)

Window Functions (NTILE, LAG, SUM OVER)

Date Parsing (STR_TO_DATE)

Advanced Aggregation (GROUP BY, HAVING)

Data Cleaning (Null handling)

📂 Files

Sana Khatoon_Challenge_9.sql: The complete SQL script containing the solution.

Day 9.docx: The original problem statement.

🚀 Key Learnings

Data Integrity: Always validate how dates are stored before performing calculations.

Granularity: The importance of distinguishing between an 'event' and a 'session' when defining business metrics.

Advanced Segmentation: How to use NTILE to quickly bucket users for marketing analysis.

Connect with me for more data analytics updates!
