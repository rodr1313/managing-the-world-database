SHOW TABLES IN world;
DESCRIBE country;
DESCRIBE city;
DESCRIBE countrylanguage;
ALTER TABLE city ADD COLUMN is_population_large BOOLEAN;
ALTER TABLE country ADD COLUMN region_code CHAR(3) DEFAULT 'NA';
ALTER TABLE city ADD CONSTRAINT check_population CHECK (population >= 0);
ALTER TABLE country ADD CONSTRAINT unique_country_code UNIQUE (code);
CREATE INDEX idx_city_name ON city (name);
EXPLAIN SELECT * FROM city WHERE name = 'New York';  -- Without index
-- Create index, then re-run the explain command:
EXPLAIN SELECT * FROM city WHERE name = 'New York';  -- With index
CREATE VIEW high_population_cities AS
SELECT name, countrycode, population
FROM city
WHERE population > 1000000;
CREATE VIEW countries_with_languages AS
SELECT country.name, countrylanguage.language
FROM country
JOIN countrylanguage ON country.code = countrylanguage.countrycode
WHERE countrylanguage.language != 'English';
CREATE USER 'db_user'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT ON world.city TO 'db_user'@'localhost';
GRANT SELECT ON world.country TO 'db_user'@'localhost';
GRANT INSERT, UPDATE ON world.city TO 'db_user'@'localhost';
REVOKE INSERT, UPDATE ON world.country FROM 'db_user'@'localhost';
GRANT SELECT ON high_population_cities TO 'db_user'@'localhost';
SELECT name
FROM country
WHERE population > 50000000 AND population < 200000000;
SELECT name
FROM country
WHERE population IN (20000000, 50000000);
SELECT name, population
FROM city
WHERE population BETWEEN 1000000 AND 10000000
AND region != 'Asia';
SELECT name
FROM country
WHERE population > 100000000 OR region = 'Europe';
SELECT name
FROM city
WHERE name LIKE 'A%' AND name NOT LIKE '%n';
SELECT countrycode
FROM city
WHERE population > 1000000
GROUP BY countrycode
HAVING COUNT(*) > 5;
SELECT countrycode
FROM countrylanguage
GROUP BY countrycode
HAVING COUNT(*) > 3;
SELECT city.name, country.name, countrylanguage.language
FROM city
JOIN country ON city.countrycode = country.code
JOIN countrylanguage ON country.code = countrylanguage.countrycode
WHERE countrylanguage.language != 'English';
SELECT country.name, (SELECT SUM(population) FROM city WHERE city.countrycode = country.code) AS total_population
FROM country;
SELECT name, population
FROM city
ORDER BY population DESC
LIMIT 10;
EXPLAIN SELECT name, population
FROM city
ORDER BY population DESC
LIMIT 10;
CREATE INDEX idx_population ON city(population);
EXPLAIN SELECT name, population
FROM city
ORDER BY population DESC
LIMIT 10;
CREATE INDEX idx_city_population_name ON city(population, name);
EXPLAIN SELECT name, population
FROM city
WHERE population > 1000000 AND name LIKE 'A%';
START TRANSACTION;
INSERT INTO city (name, countrycode, population) VALUES ('New City', 'XYZ', 500000);
ROLLBACK;
START TRANSACTION;
INSERT INTO city (name, countrycode, population) VALUES ('New City', 'XYZ', 500000);
UPDATE country SET population = population + 500000 WHERE code = 'XYZ';
COMMIT;
START TRANSACTION;
SAVEPOINT before_insert;
INSERT INTO city (name, countrycode, population) VALUES ('New City', 'XYZ', 500000);
ROLLBACK TO SAVEPOINT before_insert;
COMMIT;


