DROP DATABASE IF EXISTS airline CASCADE;
CREATE DATABASE airline;
USE airline;

CREATE TABLE data_2005 (year INT, month INT, dayofmonth INT, dayofweek INT, deptime INT, crsdeptime INT, arrtime INT, crsarrtime INT, uniquecarrier STRING, flightnum INT, tailnum STRING, actualelapsedtime INT, crselapsedtime INT, airtime INT, arrdelay INT, depdelay INT, origin STRING, dest STRING, distance INT, taxiin INT, taxiout INT, cancelled INT, cancellationcode STRING, diverted INT, carrierdelay INT, weatherdelay INT, nasdelay INT, securitydelay INT, lateaircraftdelay INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' tblproperties("skip.header.line.count"="1");
CREATE TABLE data_2006 (year INT, month INT, dayofmonth INT, dayofweek INT, deptime INT, crsdeptime INT, arrtime INT, crsarrtime INT, uniquecarrier STRING, flightnum INT, tailnum STRING, actualelapsedtime INT, crselapsedtime INT, airtime INT, arrdelay INT, depdelay INT, origin STRING, dest STRING, distance INT, taxiin INT, taxiout INT, cancelled INT, cancellationcode STRING, diverted INT, carrierdelay INT, weatherdelay INT, nasdelay INT, securitydelay INT, lateaircraftdelay INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' tblproperties("skip.header.line.count"="1"); 
CREATE TABLE data_2007 (year INT, month INT, dayofmonth INT, dayofweek INT, deptime INT, crsdeptime INT, arrtime INT, crsarrtime INT, uniquecarrier STRING, flightnum INT, tailnum STRING, actualelapsedtime INT, crselapsedtime INT, airtime INT, arrdelay INT, depdelay INT, origin STRING, dest STRING, distance INT, taxiin INT, taxiout INT, cancelled INT, cancellationcode STRING, diverted INT, carrierdelay INT, weatherdelay INT, nasdelay INT, securitydelay INT, lateaircraftdelay INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' tblproperties("skip.header.line.count"="1"); 
CREATE TABLE data_2008 (year INT, month INT, dayofmonth INT, dayofweek INT, deptime INT, crsdeptime INT, arrtime INT, crsarrtime INT, uniquecarrier STRING, flightnum INT, tailnum STRING, actualelapsedtime INT, crselapsedtime INT, airtime INT, arrdelay INT, depdelay INT, origin STRING, dest STRING, distance INT, taxiin INT, taxiout INT, cancelled INT, cancellationcode STRING, diverted INT, carrierdelay INT, weatherdelay INT, nasdelay INT, securitydelay INT, lateaircraftdelay INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' tblproperties("skip.header.line.count"="1"); 
CREATE TABLE airport_info (code STRING, airport_name STRING, city STRING, state STRING, country STRING, lat DOUBLE, long DOUBLE) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' tblproperties("skip.header.line.count"="1");

LOAD DATA INPATH 'warehouse/airline_data/2005.csv' OVERWRITE INTO TABLE data_2005;
LOAD DATA INPATH 'warehouse/airline_data/2006.csv' OVERWRITE INTO TABLE data_2006;
LOAD DATA INPATH 'warehouse/airline_data/2007.csv' OVERWRITE INTO TABLE data_2007;
LOAD DATA INPATH 'warehouse/airline_data/2008.csv' OVERWRITE INTO TABLE data_2008;
LOAD DATA INPATH 'warehouse/airline_data/airports.csv' OVERWRITE INTO TABLE airport_info;

CREATE TABLE origin_2005
AS SELECT origin, COUNT(*) AS outbound_count
FROM data_2005
GROUP BY origin; 

CREATE TABLE origin_2006
AS SELECT origin, COUNT(*) AS outbound_count
FROM data_2006
GROUP BY origin;

CREATE TABLE origin_2007
AS SELECT origin, COUNT(*) AS outbound_count
FROM data_2007
GROUP BY origin;

CREATE TABLE origin_2008
AS SELECT origin, COUNT(*) AS outbound_count
FROM data_2008
GROUP BY origin;



CREATE TABLE dest_2005
AS SELECT dest, COUNT(*) AS inbound_count
FROM data_2005
GROUP BY dest; 

CREATE TABLE dest_2006
AS SELECT dest, COUNT(*) AS inbound_count
FROM data_2006
GROUP BY dest;

CREATE TABLE dest_2007
AS SELECT dest, COUNT(*) AS inbound_count
FROM data_2007
GROUP BY dest;

CREATE TABLE dest_2008
AS SELECT dest, COUNT(*) AS inbound_count
FROM data_2008
GROUP BY dest;



CREATE TABLE total_origin
AS SELECT origin_2005.origin AS orig_05, origin_2005.outbound_count AS outbound_count_05, origin_2006.origin AS orig_06, origin_2006.outbound_count AS outbound_count_06, origin_2007.origin AS orig_07, origin_2007.outbound_count AS outbound_count_07, origin_2008.origin AS orig_08, origin_2008.outbound_count AS outbound_count_08
FROM origin_2005 FULL OUTER JOIN origin_2006 ON (origin_2005.origin = origin_2006.origin) FULL OUTER JOIN origin_2007 ON (origin_2007.origin = origin_2006.origin) FULL OUTER JOIN origin_2008 ON (origin_2008.origin = origin_2007.origin);

CREATE TABLE refined_total_origin
AS SELECT * FROM total_origin 
WHERE (orig_05 IS NOT NULL) AND (orig_06 IS NOT NULL) AND (orig_07 IS NOT NULL) AND (orig_08 IS NOT NULL);

CREATE TABLE fin_origin
AS SELECT orig_05 AS origin, (outbound_count_05 + outbound_count_06 + outbound_count_07 + outbound_count_08) AS total_outbound
FROM refined_total_origin;



CREATE TABLE total_dest
AS SELECT dest_2005.dest AS dest_05, dest_2005.inbound_count AS inbound_count_05, dest_2006.dest AS dest_06, dest_2006.inbound_count AS inbound_count_06, dest_2007.dest AS dest_07, dest_2007.inbound_count AS inbound_count_07, dest_2008.dest AS dest_08, dest_2008.inbound_count AS inbound_count_08
FROM dest_2005 FULL OUTER JOIN dest_2006 ON (dest_2005.dest = dest_2006.dest) FULL OUTER JOIN dest_2007 ON (dest_2007.dest = dest_2006.dest) FULL OUTER JOIN dest_2008 ON (dest_2008.dest = dest_2007.dest);

CREATE TABLE refined_total_dest
AS SELECT * FROM total_dest
WHERE (dest_05 IS NOT NULL) AND (dest_06 IS NOT NULL) AND (dest_07 IS NOT NULL) AND (dest_08 IS NOT NULL);

CREATE TABLE fin_dest
AS SELECT dest_05 AS dest, (inbound_count_05 + inbound_count_06 + inbound_count_07 + inbound_count_08) AS total_inbound
FROM refined_total_dest;



CREATE TABLE fin_all 
AS SELECT fin_origin.origin AS city_code, fin_origin.total_outbound, fin_dest.total_inbound, (fin_origin.total_outbound + fin_dest.total_inbound) AS total_flights
FROM fin_origin FULL OUTER JOIN fin_dest ON (fin_origin.origin = fin_dest.dest)
ORDER BY total_flights DESC; 

CREATE TABLE top_20
AS SELECT * FROM fin_all
ORDER BY total_flights DESC
LIMIT 20;

CREATE TABLE final_output
AS SELECT airport_info.city, top_20.city_code, top_20.total_outbound, top_20.total_inbound, top_20.total_flights
FROM top_20 JOIN airport_info ON (top_20.city_code = airport_info.code) 
ORDER BY top_20.total_flights DESC;

SELECT * FROM final_output;

