#### Case When ####

dbGetQuery(conn, "SELECT CustomerState,
       	CASE
          WHEN CustomerState = 'NY' THEN 'Yes'
          ELSE 'No'
         END AS FromNewYork
       	FROM Customer_T")

dbGetQuery(conn, "SELECT CustomerState,
       	CASE
          WHEN CustomerState = 'FL' THEN 'Yes'
          ELSE 'No'
         END AS FromFlorida
       	FROM Customer_T") 

dbGetQuery(conn, "SELECT ProductID, ProductStandardPrice,
           CASE
              WHEN ProductStandardPrice >= 1000 AND ProductStandardPrice <= 1650
              THEN 'Expensive'
              WHEN ProductStandardPrice >= 500 AND ProductStandardPrice <= 999
              THEN 'Normal'
              WHEN ProductStandardPrice >= 0 AND ProductStandardPrice <= 499
              THEN 'Cheap'
              ELSE 'Not enough information available'
            END AS ProductPricingCategories
            FROM Product_T")


#### CTEs ####

dbGetQuery(conn, "WITH new_york_customer_cities AS
                  (
                    SELECT CustomerName, CustomerCity
                    FROM customer_t
                    WHERE CustomerState = 'NY'
                  )
                  SELECT * from new_york_customer_cities
                  ")

dbGetQuery(conn, "WITH new_york_customer_cities AS
                  (
                    SELECT CustomerName, CustomerCity
                    FROM customer_t
                    WHERE CustomerState = 'NY'
                  )
                  SELECT CustomerCity from new_york_customer_cities
                  ")

dbGetQuery(conn, "WITH new_york_customer_cities(Name, City) AS
                  (
                    SELECT CustomerName, CustomerCity
                    FROM customer_t
                    WHERE CustomerState = 'NY'
                  )
                  SELECT * from new_york_customer_cities
                  ")

dbGetQuery(conn, "SELECT * FROM order_t
                  WHERE orderid IN (
                    SELECT orderid
                    FROM orderline_t
                    WHERE productid IN (
                      SELECT productid
                      FROM product_t
                      WHERE (productdescription LIKE '%Dresser%'
                        OR productdescription LIKE '%Bookcase%'
                        OR productdescription LIKE '%Clock%')
                    )
                  )")

dbGetQuery(conn, "WITH
                  
                  dressers_bookcases_clocks
                  AS
                  (
                    SELECT productid
                    FROM product_t
                    WHERE (productdescription LIKE '%Dresser%'
                      OR productdescription LIKE '%Bookcase%'
                      OR productdescription LIKE '%Clock%')
                  ),
                  
                  orders_of_dressers_bookcases_clocks
                  AS
                  (
                    SELECT orderid
                    FROM orderline_t
                    WHERE productid IN dressers_bookcases_clocks
                  )
           
                  SELECT * FROM order_t
                  WHERE orderid
                  IN orders_of_dressers_bookcases_clocks
                  ")

dbGetQuery(conn, "SELECT * FROM salesperson_t
                  WHERE salespersonid IN (
                    SELECT salespersonid FROM order_t
                    WHERE customerid IN (
                      SELECT customerid from customer_t
                      WHERE customerstate IN ('NY')
                    )
                  )")

dbGetQuery(conn, "WITH
           
                  count_to_5
                  AS
                  (
                    SELECT 1 as n
                    UNION ALL
                    SELECT n + 1
                    FROM count_to_5
                    WHERE n < 5
                  )
                  
                  SELECT *
                  FROM count_to_5
                  ")

dbGetQuery(conn, "WITH num_orders_by_customer
                  AS
                  (
                    SELECT customerid, COUNT(*) AS num_orders
                    FROM order_t
                    GROUP BY customerid
                  )
                  
                  SELECT AVG(num_orders)
                  FROM num_orders_by_customer
                  ")

#### Pivots ####
dbGetQuery(conn, "SELECT
           SUM(CASE WHEN productfinish = 'Cherry' then 1 else 0 end)
           AS Cherry,
           SUM(CASE WHEN productfinish = 'Pine' then 1 else 0 end)
           AS Pine,
           SUM(CASE WHEN productfinish = 'Walnut' then 1 else 0 end)
           AS Walnut,
           SUM (CASE WHEN productfinish = 'Leather' then 1 else 0 end)
           AS Leather,
           SUM(CASE WHEN productfinish = 'Birch' then 1 else 0 end)
           AS Birch,
           SUM (CASE WHEN productfinish = 'Oak' then 1 else 0 end)
           AS Oak,
           SUM (CASE WHEN productfinish IS NULL then 1 else 0 end)
           AS None
           FROM product_t")

dbGetQuery(conn, "SELECT 
           MAX(CASE WHEN productfinish = 'Cherry' then productstandardprice else 0 end) 
           AS Cherry,
           MAX(CASE WHEN productfinish = 'Pine' then productstandardprice else 0 end) 
           AS Pine,
           MAX(CASE WHEN productfinish = 'Walnut' then productstandardprice else 0 end) 
           AS Walnut,
           MAX(CASE WHEN productfinish = 'Leather' then productstandardprice else 0 end) 
           AS Leather,
           MAX(CASE WHEN productfinish = 'Birch' then productstandardprice else 0 end) 
           AS Birch,
           MAX(CASE WHEN productfinish = 'Oak' then productstandardprice else 0 end) 
           AS Oak
           from product_t")

dbGetQuery(conn, "SELECT SalespersonID AS SalesPerson,           
           SUM(CASE WHEN OrderDate LIKE '%09%' THEN 1 ELSE 0 END) AS Year_09,
           SUM(CASE WHEN OrderDate LIKE '%10%' THEN 1 ELSE 0 END) AS Year_10
           FROM order_t WHERE SalespersonID NOT NULL GROUP BY SalespersonID")

