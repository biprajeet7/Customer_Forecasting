-- Identify duplicates and clean customer journey data

;WITH CTE_Dups AS (
    SELECT 
        cj.JourneyID,
        cj.CustomerID,
        cj.ProductID,
        cj.VisitDate,
        cj.Stage,
        cj.Action,
        cj.Duration,
        ROW_NUMBER() OVER (
            PARTITION BY cj.CustomerID, cj.ProductID, cj.VisitDate, cj.Stage, cj.Action
            ORDER BY cj.JourneyID
        ) AS rn
    FROM dbo.customer_journey cj
),
CTE_Clean AS (
    SELECT 
        JourneyID,
        CustomerID,
        ProductID,
        VisitDate,
        UPPER(Stage) AS Stage,
        Action,
        Duration,
        AVG(Duration) OVER (PARTITION BY VisitDate) AS AvgDur,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action
            ORDER BY JourneyID
        ) AS dup_rank
    FROM CTE_Dups
    WHERE rn = 1   -- remove exact duplicates first
)
SELECT 
    JourneyID,
    CustomerID,
    ProductID,
    VisitDate,
    Stage,
    Action,
    COALESCE(Duration, AvgDur) AS Duration
FROM CTE_Clean
WHERE dup_rank = 1   -- retain only one record per duplicate set
ORDER BY JourneyID;
