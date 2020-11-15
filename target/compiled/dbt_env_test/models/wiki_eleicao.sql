WITH base AS (SELECT 
  DATE_TRUNC(CAST(datehour AS date), MONTH) AS month, 
  CASE WHEN SPLIT(title, "_")[SAFE_OFFSET(1)] IN ("municipal") THEN null ELSE SPLIT(title, "_")[SAFE_OFFSET(1)] END AS part1,
  CASE WHEN SPLIT(title, "_")[SAFE_OFFSET(2)] IN ("de","do") THEN null ELSE SPLIT(title, "_")[SAFE_OFFSET(2)] END AS part2,
  SPLIT(title, "_")[SAFE_OFFSET(3)] AS part3,
  CASE WHEN SPLIT(title, "_")[SAFE_OFFSET(4)] IN ("2020","em") THEN null ELSE SPLIT(title, "_")[SAFE_OFFSET(4)] END AS part4,
  CASE WHEN SPLIT(title, "_")[SAFE_OFFSET(5)] IN ("2020","em") THEN null ELSE SPLIT(title, "_")[SAFE_OFFSET(5)] END AS part5,
  CASE WHEN SPLIT(title, "_")[SAFE_OFFSET(6)] IN ("2020","em") THEN null ELSE SPLIT(title, "_")[SAFE_OFFSET(6)] END AS part6,
  CASE WHEN SPLIT(title, "_")[SAFE_OFFSET(7)] IN ("2020","em") THEN null ELSE SPLIT(title, "_")[SAFE_OFFSET(7)] END AS part7,
  SUM(views) AS total_views
FROM `bigquery-public-data.wikipedia.pageviews_*` 
WHERE DATE(datehour) >= "2020-11-01" 
AND  LOWER(title) LIKE "%eleição%" 
AND LOWER(title) 
LIKE "%municipal%" 
AND title LIKE "%2020%"
GROUP BY 
   1
  ,2
  ,3
  ,4
  ,5
  ,6
  ,7
  ,8
ORDER BY 
1
,total_views DESC)

SELECT 
ARRAY_TO_STRING([part1,part2,part3,part4,part5,part6,part7], ' ') AS citys,
SUM(total_views) total_views
FROM base 
GROUP BY 1
ORDER BY 2 DESC