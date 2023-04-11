CREATE OR REPLACE TABLE t_avg_pay AS
SELECT
cp.payroll_year,
cpib.code,
cpib.name,
avg(value) AS avarage_pay
FROM czechia_payroll cp  
JOIN czechia_payroll_calculation cpc
ON cp.calculation_code = cpc.code
JOIN czechia_payroll_industry_branch cpib
ON cp.industry_branch_code = cpib.code
JOIN czechia_payroll_unit cpu
ON cp.unit_code = cpu.code
JOIN czechia_payroll_value_type cpvt
ON cp.value_type_code = cpvt.code
WHERE cp.value_type_code = '5958'
GROUP BY cp.payroll_year, cpib.name
ORDER BY cpib.name, cp.payroll_year
;


CREATE OR REPLACE TABLE t_avg_price AS
SELECT 
YEAR (date_from) AS yearly_price,
cpc.code,
cpc.name,
cpc.price_value,
cpc.price_unit,
AVG (value) AS avarage_price
FROM czechia_price cp
JOIN czechia_price_category cpc
ON cp.category_code = cpc.code
JOIN czechia_region cr 
ON cp.region_code = cr.code
GROUP BY yearly_price, cpc.name 
ORDER BY cpc.name, yearly_price
;


CREATE OR REPLACE TABLE t_petr_melicharik_SQL_primary_final AS
SELECT
payroll_year AS `year`,
tap.code AS industry_code,
tap.name AS industry_name,
avarage_pay,
tap2.code AS product_code,
tap2.name AS product_name,
price_value,
price_unit,
avarage_price
FROM t_avg_pay tap
JOIN t_avg_price tap2
ON tap.payroll_year = tap2.yearly_price 
;


CREATE OR REPLACE TABLE t_petr_melicharik_sql_secondary_final AS
SELECT
e.country,
e.`year`,
e.GDP,
e.population,
e.gini
FROM economies e
JOIN countries c 
ON e.country = c.country
WHERE c.continent = 'Europe' AND `year` BETWEEN 2006 AND 2018
ORDER BY country, `year`
;



