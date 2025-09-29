-- Normalize and clean engagement data

SELECT 
    e.EngagementID AS ID,
    e.ContentID,
    e.CampaignID,
    e.ProductID,
    UPPER(REPLACE(e.ContentType, 'Socialmedia', 'Social Media')) AS NormalizedContentType,
    PARSENAME(REPLACE(e.ViewsClicksCombined, '-', '.'), 2) AS Views,
    PARSENAME(REPLACE(e.ViewsClicksCombined, '-', '.'), 1) AS Clicks,
    e.Likes,
    FORMAT(CAST(e.EngagementDate AS DATE), 'dd.MM.yyyy') AS FormattedDate
FROM dbo.engagement_data e
WHERE e.ContentType <> 'Newsletter';
