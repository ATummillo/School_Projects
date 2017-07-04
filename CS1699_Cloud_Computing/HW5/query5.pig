data_2005 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2005.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2006 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2006.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2007 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2007.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2008 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2008.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;


red_2005 = FOREACH data_2005 GENERATE $16 as origin, $17 as dest, $18 as dist;
red_2006 = FOREACH data_2006 GENERATE $16 as origin, $17 as dest, $18 as dist;
red_2007 = FOREACH data_2007 GENERATE $16 as origin, $17 as dest, $18 as dist;
red_2008 = FOREACH data_2008 GENERATE $16 as origin, $17 as dest, $18 as dist;

red_all = COGROUP red_2005 BY (origin, dest), red_2006 BY (origin, dest), red_2007 BY (origin, dest), red_2008 BY (origin, dest);
count_all = FOREACH red_all GENERATE $0, COUNT($1) as num_flights;
sort_all = ORDER count_all BY num_flights DESC;

top20 = LIMIT sort_all 20;

dump top20;
