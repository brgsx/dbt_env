{{ config(materialized='table') }}
{% set words = ("municipal","2020","de","do","em") %}
{% set parts = ["part1","part2","part3","part4","part5","part6","part7"] %}
{% set part = ["part1","part2","part3","part4","part5","part6","part7"] %}

WITH base AS (SELECT 
  DATE_TRUNC(CAST(datehour AS date), MONTH) AS month, 
  SPLIT(title, "_")[SAFE_OFFSET(1)] AS part1,
  SPLIT(title, "_")[SAFE_OFFSET(2)] AS part2,
  SPLIT(title, "_")[SAFE_OFFSET(3)] AS part3,
  SPLIT(title, "_")[SAFE_OFFSET(4)] AS part4,
  SPLIT(title, "_")[SAFE_OFFSET(5)] AS part5,
  SPLIT(title, "_")[SAFE_OFFSET(6)] AS part6,
  SPLIT(title, "_")[SAFE_OFFSET(7)] AS part7,
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
{% for part in parts %}
CASE WHEN {{part}} IN {{words}} THEN null ELSE {{part}} END AS {{part}},
{% endfor %}
SUM(total_views) total_views
FROM base 
GROUP BY 1,2,3,4,5,6,7
ORDER BY 2 DESC