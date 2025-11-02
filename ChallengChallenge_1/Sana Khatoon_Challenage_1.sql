use retail_db;

/*-- Q1: Active Products as a percentage of total products*/
SELECT 
    SUM(active) AS Active_Products, 
    COUNT(product_id) AS Total_Products, 
    (SUM(active) * 100.0 / COUNT(product_id)) AS Active_Percentage 
FROM products;
    
/*-- Q2: Classify Stores into Old and New and count them*/
SELECT
    CASE 
        WHEN opened_at < '2023-01-01' THEN 'Old' 
        ELSE 'New' 
    END AS Store_Classification,
    COUNT(store_id) AS Store_Count
FROM stores
GROUP BY Store_Classification
ORDER BY Store_Count DESC;

    /*3) Top 5 cities by number of customers along with Old and New classification of stores*/
    
    WITH CustomerRanks AS (
    SELECT city, COUNT(customer_id) AS Customer_Count
    FROM customers
    GROUP BY city
    ORDER BY Customer_Count DESC
    LIMIT 5 
    ),
StoreClassifications AS (
    SELECT city,
        CASE 
            WHEN opened_at < '2023-01-01' THEN 'Old' 
            ELSE 'New' 
        END AS Store_Classification
    FROM stores
)
SELECT CR.city, CR.Customer_Count,
GROUP_CONCAT(DISTINCT SC.Store_Classification ORDER BY SC.Store_Classification DESC SEPARATOR ', ') AS Store_Classification
FROM CustomerRanks CR
LEFT JOIN StoreClassifications SC ON CR.city = SC.city
GROUP BY CR.city, CR.Customer_Count
ORDER BY CR.Customer_Count DESC;
    
/*-- Q4: Average order line value (AVG(line_amount))*/

SELECT  AVG(line_amount) AS Average_Order_Line_Value
FROM order_items;
    