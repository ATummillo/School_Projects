data_2005 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2005.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2006 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2006.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2007 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2007.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2008 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2008.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;

red_2005 = FOREACH data_2005 GENERATE $8 as carrier, $18 as dist;
red_2006 = FOREACH data_2006 GENERATE $8 as carrier, $18 as dist;
red_2007 = FOREACH data_2007 GENERATE $8 as carrier, $18 as dist;
red_2008 = FOREACH data_2008 GENERATE $8 as carrier, $18 as dist;

carrier_2005 = GROUP red_2005 BY carrier;
carrier_2006 = GROUP red_2006 BY carrier;
carrier_2007 = GROUP red_2007 BY carrier;
carrier_2008 = GROUP red_2008 BY carrier;

count_2005 = FOREACH carrier_2005 GENERATE $0, (DOUBLE) COUNT($1) as total_flights;
count_2006 = FOREACH carrier_2006 GENERATE $0, (DOUBLE) COUNT($1) as total_flights;
count_2007 = FOREACH carrier_2007 GENERATE $0, (DOUBLE) COUNT($1) as total_flights;
count_2008 = FOREACH carrier_2008 GENERATE $0, (DOUBLE) COUNT($1) as total_flights;

count_5_6 = JOIN count_2005 BY $0 FULL OUTER, count_2006 BY $0;
count_5_6_7 = JOIN count_5_6 BY $0 FULL OUTER, count_2007 BY $0;
count_all = JOIN count_5_6_7 BY $0 FULL OUTER, count_2008 BY $0;

filtered_all = FILTER count_all BY $0 is not null AND $2 is not null AND $4 is not null AND $6 is not null;

final_growth = FOREACH filtered_all GENERATE $0, (($3 - $1)/$1)*100 as growth_5_6, (($5 - $3)/$3)*100 as growth_6_7, (($7 - $5)/$5)*100 as growth_7_8;

total_growth = FOREACH final_growth GENERATE $0, $1, $2, $3, ($1 + $2 + $3) as total;

ranked_growth = ORDER total_growth BY total DESC;

DUMP ranked_growth;
