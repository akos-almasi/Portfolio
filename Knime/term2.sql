-- Creating table for gender ratio and loading data from csv file
DROP SCHEMA IF EXISTS knime;
CREATE SCHEMA knime;
USE knime;

DROP TABLE IF EXISTS PopShare;
CREATE TABLE PopShare
(Country VARCHAR (100),
Codes VARCHAR(50),
Years INTEGER,
Population INTEGER, 
PRIMARY KEY(Country, Years));

SHOW VARIABLES LIKE "secure_file_priv";
SET GLOBAL local_infile= 'on';
SHOW VARIABLES LIKE "local_infile";

LOAD DATA LOCAL INFILE "C:\\Users\\Admin\\Desktop\\DE1\\Term2\\share-population-female-updated.csv"
INTO TABLE PopShare
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(Country, Codes, Years, Population);

-- Creating table for countries' codes and loading data from csv file
DROP TABLE IF EXISTS countries;
CREATE TABLE countries
(country VARCHAR (100),
country_code VARCHAR (50), 
PRIMARY KEY(country));

LOAD DATA LOCAL INFILE "C:\\Users\\Admin\\Desktop\\DE1\\Term2\\countries.csv"
INTO TABLE countries
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(@col1, @col2, @dummy, @dummy, @dummy)
SET country=@col1, country_code=@col2;