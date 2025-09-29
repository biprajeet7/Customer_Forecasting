-- Retrieve customer details with corresponding geographic information

SELECT 
    cust.CustomerID AS ID,
    cust.CustomerName AS Name,
    cust.Email AS EmailAddress,
    cust.Gender,
    cust.Age,
    geo.Country,
    geo.City
FROM dbo.geography geo
INNER JOIN dbo.customers cust
    ON geo.GeographyID = cust.GeographyID;
