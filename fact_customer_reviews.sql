-- Standardize review text by trimming and fixing whitespace

SELECT 
    r.ReviewID AS ID,
    r.CustomerID AS CustID,
    r.ProductID AS ProdID,
    r.ReviewDate AS DateReviewed,
    r.Rating AS Stars,
    LTRIM(RTRIM(REPLACE(r.ReviewText, '  ', ' '))) AS CleanedReview
FROM dbo.customer_reviews r;
