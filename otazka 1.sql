
CREATE OR REPLACE TABLE t_avg_pay_comp 
AS
SELECT
tpmspf.industry_name,
tpmspf.`year` AS year1,
ROUND (tpmspf.avarage_pay,0) AS avg_pay_2006,
tpmspf2.`year` AS year2,
ROUND (tpmspf2.avarage_pay,0) AS avg_pay_2018
FROM t_petr_melicharik_sql_primary_final tpmspf
JOIN t_petr_melicharik_sql_primary_final tpmspf2 
ON tpmspf.industry_name = tpmspf2.industry_name 
WHERE tpmspf.`year` = 2006 AND tpmspf2.`year` = 2018
GROUP BY industry_name 
;


SELECT *,
CASE 
	WHEN avg_pay_2018 > avg_pay_2006 THEN 1
	ELSE 0	
END AS pay_raise
FROM t_avg_pay_comp tapc
;