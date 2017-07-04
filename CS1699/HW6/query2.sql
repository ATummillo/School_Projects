DROP DATABASE IF EXISTS airline_2 CASCADE;
CREATE DATABASE airline_2;
USE airline_2;

CREATE TABLE data_2005 (year INT, month INT, dayofmonth INT, dayofweek INT, deptime INT, crsdeptime INT, arrtime INT, crsarrtime INT, uniquecarrier STRING, flightnum INT, tailnum STRING, actualelapsedtime INT, crselapsedtime INT, airtime INT, arrdelay INT, depdelay INT, origin STRING, dest STRING, distance INT, taxiin INT, taxiout INT, cancelled INT, cancellationcode STRING, diverted INT, carrierdelay INT, weatherdelay INT, nasdelay INT, securitydelay INT, lateaircraftdelay INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' tblproperties("skip.header.line.count"="1");
CREATE TABLE data_2006 (year INT, month INT, dayofmonth INT, dayofweek INT, deptime INT, crsdeptime INT, arrtime INT, crsarrtime INT, uniquecarrier STRING, flightnum INT, tailnum STRING, actualelapsedtime INT, crselapsedtime INT, airtime INT, arrdelay INT, depdelay INT, origin STRING, dest STRING, distance INT, taxiin INT, taxiout INT, cancelled INT, cancellationcode STRING, diverted INT, carrierdelay INT, weatherdelay INT, nasdelay INT, securitydelay INT, lateaircraftdelay INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' tblproperties("skip.header.line.count"="1"); 
CREATE TABLE data_2007 (year INT, month INT, dayofmonth INT, dayofweek INT, deptime INT, crsdeptime INT, arrtime INT, crsarrtime INT, uniquecarrier STRING, flightnum INT, tailnum STRING, actualelapsedtime INT, crselapsedtime INT, airtime INT, arrdelay INT, depdelay INT, origin STRING, dest STRING, distance INT, taxiin INT, taxiout INT, cancelled INT, cancellationcode STRING, diverted INT, carrierdelay INT, weatherdelay INT, nasdelay INT, securitydelay INT, lateaircraftdelay INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' tblproperties("skip.header.line.count"="1"); 
CREATE TABLE data_2008 (year INT, month INT, dayofmonth INT, dayofweek INT, deptime INT, crsdeptime INT, arrtime INT, crsarrtime INT, uniquecarrier STRING, flightnum INT, tailnum STRING, actualelapsedtime INT, crselapsedtime INT, airtime INT, arrdelay INT, depdelay INT, origin STRING, dest STRING, distance INT, taxiin INT, taxiout INT, cancelled INT, cancellationcode STRING, diverted INT, carrierdelay INT, weatherdelay INT, nasdelay INT, securitydelay INT, lateaircraftdelay INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' tblproperties("skip.header.line.count"="1"); 
CREATE TABLE plane_info (tailnum STRING, type STRING, manufacturer STRING, issue_date STRING, model STRING, status STRING, aircraft_type STRING, engine_type STRING, year INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' tblproperties("skip.header.line.count"="1");

LOAD DATA INPATH 'warehouse/airline_data/2005.csv' OVERWRITE INTO TABLE data_2005;
LOAD DATA INPATH 'warehouse/airline_data/2006.csv' OVERWRITE INTO TABLE data_2006;
LOAD DATA INPATH 'warehouse/airline_data/2007.csv' OVERWRITE INTO TABLE data_2007;
LOAD DATA INPATH 'warehouse/airline_data/2008.csv' OVERWRITE INTO TABLE data_2008;
LOAD DATA INPATH 'warehouse/airline_data/plane-data.csv' OVERWRITE INTO TABLE plane_info;

CREATE TABLE planes_2005
AS SELECT tailnum, arrdelay
FROM data_2005;

CREATE TABLE planes_2006
AS SELECT tailnum, arrdelay
FROM data_2006;

CREATE TABLE planes_2007
AS SELECT tailnum, arrdelay
FROM data_2007;

CREATE TABLE planes_2008
AS SELECT tailnum, arrdelay
FROM data_2008;



Create TABLE planeyear_2005
AS SELECT plane_info.year, planes_2005.tailnum, planes_2005.arrdelay
FROM planes_2005 JOIN plane_info ON (planes_2005.tailnum = plane_info.tailnum)
WHERE (plane_info.year IS NOT NULL) AND (planes_2005.tailnum IS NOT NULL) AND (planes_2005.arrdelay IS NOT NULL);

Create TABLE planeyear_2006
AS SELECT plane_info.year, planes_2006.tailnum, planes_2006.arrdelay
FROM planes_2006 JOIN plane_info ON (planes_2006.tailnum = plane_info.tailnum)
WHERE (plane_info.year IS NOT NULL) AND (planes_2006.tailnum IS NOT NULL) AND (planes_2006.arrdelay IS NOT NULL);

Create TABLE planeyear_2007
AS SELECT plane_info.year, planes_2007.tailnum, planes_2007.arrdelay
FROM planes_2007 JOIN plane_info ON (planes_2007.tailnum = plane_info.tailnum)
WHERE (plane_info.year IS NOT NULL) AND (planes_2007.tailnum IS NOT NULL) AND (planes_2007.arrdelay IS NOT NULL);

Create TABLE planeyear_2008
AS SELECT plane_info.year, planes_2008.tailnum, planes_2008.arrdelay
FROM planes_2008 JOIN plane_info ON (planes_2008.tailnum = plane_info.tailnum)
WHERE (plane_info.year IS NOT NULL) AND (planes_2008.tailnum IS NOT NULL) AND (planes_2008.arrdelay IS NOT NULL);


CREATE TABLE plane_year_all
AS SELECT *
FROM planeyear_2005 
UNION ALL 
SELECT *
FROM planeyear_2006
UNION ALL
SELECT *
FROM planeyear_2007
UNION ALL
SELECT * 
FROM planeyear_2008;


CREATE TABLE final_output 
AS SELECT year, AVG(arrdelay) AS avg_delay
FROM plane_year_all 
GROUP BY year
ORDER BY avg_delay DESC;

SELECT * FROM final_output;







