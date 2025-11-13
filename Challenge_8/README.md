Day 8: Web Event Analytics SQL Challenge

📊 Project Overview

This repository contains the SQL solutions for Day 8 of the Data Analytics Challenge, focusing on Web Event Analysis from the retail_db dataset.

The project addresses key business intelligence and feature engineering requirements by processing raw event logs (page_view, add_to_cart, checkout, purchase) to derive meaningful insights into user behavior and marketing performance.

🎯 Challenge Objectives

The solutions cover three main analytical tasks:

#

Feature Name

Analytical Goal

1

Product Brand Performance

Compute the total add_to_cart counts grouped by the product_brand.

2

Campaign Funnel Conversion Rates

Measure sequential conversion rates (page_view $\rightarrow$ add_to_cart $\rightarrow$ checkout $\rightarrow$ purchase) segmented by utm_campaign.

3

User 30-Day Activity Features

Engineer a per-user feature table capturing activity metrics within a 30-day lookback window.

💻 SQL Solution File

File Name

Description

Sana Khatoon_Challenge_8.sql

Contains the complete, structured MySQL/SQL solutions for all three objectives.

🔑 Technical Breakdown and Key Concepts

The SQL code employs robust techniques to ensure accurate time-series analysis and conversion metrics:

1. Product Brand Performance

Approach: Uses JSON_EXTRACT to parse the product_id from the event_json column, aggregates the counts, and then performs a JOIN with the products table to group the final output by brand.

2. Campaign Funnel Conversion Rates

Query Name: Campaign_Funnel_Conversion_Rates

Technique: The solution utilizes a Common Table Expression (CTE) (UserFunnelSteps) to establish the chronological order of events. It finds the MIN() timestamp for each critical event (add_to_cart_ts, checkout_ts, purchase_ts) per user and campaign.

Conversion Logic: Conversion rates are calculated by checking the sequential flow (checkout_ts >= add_to_cart_ts) to ensure true, forward-moving conversions are counted, providing an accurate measure of marketing channel performance.

3. User 30-Day Activity Features

Query Name: User_30Day_Activity_Features

Technique: This feature engineering task utilizes a Reference Date CTE to determine the latest event time (MaxDateTime) in the dataset.

Lookback Logic: All features (sessions_30d, add_to_carts_30d, purchases_30d) are calculated using a 30-day lookback window defined dynamically with DATE_SUB(RefDateTime, INTERVAL 30 DAY), ensuring accurate, time-bound metrics for model building or reporting.
