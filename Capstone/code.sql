/*-- Looking how the database is structured
SELECT *
 FROM subscriptions
 LIMIT 5;
--Looking for the unqiue segments
 SELECT DISTINCT segment
 FROM subscriptions;
 --Finding the date range for this field
 SELECT  MIN(subscription_start), MAX(subscription_start)
 FROM subscriptions; */
 
 /*
--Question 2
--Creating temporary date table 
 WITH months AS(
   SELECT
   '2017-01-01' AS first_day,
   '2017-01-31' AS last_day
   UNION
   SELECT
   '2017-02-01' AS first_day,
   '2017-02-28' AS last_day
   UNION
   SELECT
   '2017-03-01' AS first_day,
   '2017-03-31' AS last_day
 ),
 --Using cross join to combine the temp. table to the Codeflix Source
 cross_join AS(
 SELECT *
 FROM subscriptions 
 CROSS JOIN months),
 --Using newly created table to find customers who have churned
 status AS(
 SELECT id, first_day AS month,
   CASE
   	WHEN (subscription_start < first_day)
   	AND (
    	subscription_end > first_day
    OR subscription_end IS NULL) THEN 1 ELSE 0
   END as is_active,
  CASE
   WHEN subscription_end BETWEEN first_day AND last_day
   THEN 1 ELSE 0
   END as is_canceled
   FROM cross_join
    ),
  --Table to aggregate the results from the previous query
status_aggregate AS(
SELECT month, 
  sum(is_active) as sum_is_active,
  sum(is_canceled) as sum_is_canceled
  FROM status
GROUP BY month)
--Finally the overall churn rate is found
SELECT month, 1.0*sum_is_canceled/sum_is_active 
FROM status_aggregate; 
*/

 --question 3
 WITH months AS(
   SELECT
   '2017-01-01' AS first_day,
   '2017-01-31' AS last_day
   UNION
   SELECT
   '2017-02-01' AS first_day,
   '2017-02-28' AS last_day
   UNION
   SELECT
   '2017-03-01' AS first_day,
   '2017-03-31' AS last_day
 ),
 cross_join AS(
 SELECT *
 FROM subscriptions 
 CROSS JOIN months),
 status AS(
 SELECT id, first_day AS month,
   CASE
   	WHEN (subscription_start < first_day)
   AND
   segment = '87'
   	AND (
    	subscription_end > first_day
    OR subscription_end IS NULL) THEN 1 ELSE 0
   END as is_active_87,
CASE
   	WHEN (subscription_start < first_day)
   AND
   segment = '30'
   	AND (
    	subscription_end > first_day
    OR subscription_end IS NULL) THEN 1 ELSE 0
   END as is_active_30,
  CASE
   WHEN subscription_end BETWEEN first_day AND last_day
   AND segment = '87'
   THEN 1 ELSE 0
   END as is_canceled_87,
     CASE
   WHEN subscription_end BETWEEN first_day AND last_day
   AND segment = '30'
   THEN 1 ELSE 0
   END as is_canceled_30
   FROM cross_join
 ),
status_aggregate AS(
SELECT month, 
  sum(is_active_87) as sum_is_active_87,sum(is_active_30) as sum_is_active_30,
  sum(is_canceled_87) as sum_is_canceled_87,sum(is_canceled_30) as sum_is_canceled_30
  FROM status
GROUP BY month)
SELECT month, sum_is_canceled_87,sum_is_active_87,sum_is_canceled_30,sum_is_active_30, 1.0 * sum_is_canceled_87/sum_is_active_87 as '87_churn',
			 1.0 * sum_is_canceled_30/sum_is_active_30 as '30_churn'
FROM status_aggregate; 