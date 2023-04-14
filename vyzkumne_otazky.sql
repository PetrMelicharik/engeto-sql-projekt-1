-- otázka číslo 1

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


-- otázka číslo 2

SELECT
`year`,
round(avg(avarage_pay),0) AS avg_pay_in_year,
product_name,
round(avg(avarage_price),1) AS avg_product_price_in_year,
floor(round(avg(avarage_pay),0)/round(avg(avarage_price),1)) AS quantity_to_buy
FROM t_petr_melicharik_sql_primary_final tpmspf
WHERE product_code IN (111301,114201) AND `year` IN (2006, 2018)
GROUP BY `year`, product_code
;

-- otázka číslo 3

SELECT
tap.name,
tap2.yearly_price,
tap2.avarage_price,
tap.yearly_price,
tap.avarage_price,
round((tap.avarage_price - tap2.avarage_price) / tap2.avarage_price  * 100, 1) AS percentual_change
FROM t_avg_price tap
JOIN t_avg_price tap2
ON tap.name = tap2.name
AND tap.yearly_price = tap2.yearly_price +12
ORDER BY percentual_change
;

