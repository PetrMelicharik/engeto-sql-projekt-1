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

-- otázka číslo 4

CREATE OR REPLACE TABLE t_avg_pay_all
SELECT
payroll_year,
round(avg(avarage_pay),0) AS avarage_payment
FROM t_avg_pay tap
GROUP BY payroll_year
;

CREATE OR REPLACE TABLE t_avg_price_all
SELECT
yearly_price,
round(avg(avarage_price), 2) AS avarage_product_price
FROM t_avg_price tap
GROUP BY yearly_price
;

CREATE OR REPLACE TABLE t_compare_avg_pay_and_price
SELECT
tapa.payroll_year,
tapa.avarage_payment,
tapa2.avarage_product_price
FROM t_avg_pay_all tapa
JOIN t_avg_price_all tapa2
ON tapa.payroll_year = tapa2.yearly_price
;

SELECT *,
round((tcapap2.avarage_payment - tcapap.avarage_payment) / tcapap.avarage_payment * 100, 1) AS yearly_pay_change,
round((tcapap2.avarage_product_price - tcapap.avarage_product_price) /tcapap.avarage_product_price * 100, 1) AS yearly_price_change
FROM t_compare_avg_pay_and_price tcapap
JOIN t_compare_avg_pay_and_price tcapap2
ON tcapap2.payroll_year = tcapap.payroll_year + 1
;


