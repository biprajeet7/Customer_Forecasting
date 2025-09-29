-- Display products with price classification

SELECT 
    p.ProductID AS ID,
    p.ProductName AS Name,
    p.Price AS ProductPrice,
    
    CASE 
        WHEN p.Price <= 49 THEN 'Low'
        WHEN p.Price >= 50 AND p.Price <= 200 THEN 'Medium'
        ELSE 'High'
    END AS PriceLevel

FROM dbo.products p;
