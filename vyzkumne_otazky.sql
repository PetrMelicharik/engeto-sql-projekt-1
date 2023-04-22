-- otázka číslo 1

CREATE OR REPLACE TABLE t_avg_pay_yearly AS
SELECT
tap.payroll_year,
tap.code,
tap.name,
tap.avarage_pay,
tap2.payroll_year AS payroll_year_2,
tap2.avarage_pay AS avarage_pay_2
FROM t_avg_pay tap
JOIN t_avg_pay tap2
ON
tap2.payroll_year = tap.payroll_year +1
WHERE tap2.code = tap.code
;

SELECT *,
CASE
	WHEN avarage_pay_2 > avarage_pay THEN 1
	ELSE 0
END AS compare
FROM t_avg_pay_yearly tapy
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


-- otázka číslo 5

CREATE OR REPLACE TABLE t_gdp_avg_payprice
AS
SELECT
tpmssf.country,
tpmssf.`year`,
tpmssf.GDP,
tcapap.avarage_payment,
tcapap.avarage_product_price
FROM t_petr_melicharik_sql_secondary_final tpmssf
JOIN t_compare_avg_pay_and_price tcapap
ON tpmssf.`year` = tcapap.payroll_year
WHERE country = 'Czech republic'
;

SELECT
tgap.`year`,
tgap.GDP,
tgap.avarage_payment,
tgap.avarage_product_price,
tgap2.`year`,
tgap2.GDP,
tgap2.avarage_payment,
tgap2.avarage_product_price,
round((tgap2.GDP - tgap.GDP) / tgap.GDP * 100, 2) AS gdp_change,
round((tgap2.avarage_payment - tgap.avarage_payment) / tgap.avarage_payment * 100, 2) AS pay_change,
round((tgap2.avarage_product_price  - tgap.avarage_product_price) / tgap.avarage_product_price * 100, 2) AS product_change
FROM t_gdp_avg_payprice tgap
JOIN t_gdp_avg_payprice tgap2
ON tgap2.`year` = tgap.`year` +1
;

