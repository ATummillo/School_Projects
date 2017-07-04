data_2005 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2005.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2006 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2006.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2007 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2007.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2008 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2008.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;


red_2005 = FOREACH data_2005 GENERATE $16, $17;
red_2006 = FOREACH data_2006 GENERATE $16, $17;
red_2007 = FOREACH data_2007 GENERATE $16, $17;
red_2008 = FOREACH data_2008 GENERATE $16, $17;

origin_2005 = GROUP red_2005 BY origin;
origin_2006 = GROUP red_2006 BY origin;
origin_2007 = GROUP red_2007 BY origin;
origin_2008 = GROUP red_2008 BY origin;

dest_2005 = GROUP red_2005 BY dest;
dest_2006 = GROUP red_2006 BY dest;
dest_2007 = GROUP red_2007 BY dest;
dest_2008 = GROUP red_2008 BY dest;

origin_count_2005 = FOREACH origin_2005 GENERATE $0, COUNT($1) as outbound_count;
origin_count_2006 = FOREACH origin_2006 GENERATE $0, COUNT($1) as outbound_count;
origin_count_2007 = FOREACH origin_2007 GENERATE $0, COUNT($1) as outbound_count;
origin_count_2008 = FOREACH origin_2008 GENERATE $0, COUNT($1) as outbound_count;

dest_count_2005 = FOREACH dest_2005 GENERATE $0, COUNT($1) as inbound_count;
dest_count_2006 = FOREACH dest_2006 GENERATE $0, COUNT($1) as inbound_count;
dest_count_2007 = FOREACH dest_2007 GENERATE $0, COUNT($1) as inbound_count;
dest_count_2008 = FOREACH dest_2008 GENERATE $0, COUNT($1) as inbound_count;

combined_2005 = JOIN origin_count_2005 BY $0 FULL OUTER, dest_count_2005 BY $0;
combined_2006 = JOIN origin_count_2006 BY $0 FULL OUTER, dest_count_2006 BY $0;
combined_2007 = JOIN origin_count_2007 BY $0 FULL OUTER, dest_count_2007 BY $0;
combined_2008 = JOIN origin_count_2008 BY $0 FULL OUTER, dest_count_2008 BY $0;

total_2005 = FOREACH combined_2005 GENERATE $0 as name, $1 as outbound_count, $3 as inbound_count, ($1 + $3) as total_count;
total_2006 = FOREACH combined_2006 GENERATE $0 as name, $1 as outbound_count, $3 as inbound_count, ($1 + $3) as total_count;
total_2007 = FOREACH combined_2007 GENERATE $0 as name, $1 as outbound_count, $3 as inbound_count, ($1 + $3) as total_count;
total_2008 = FOREACH combined_2008 GENERATE $0 as name, $1 as outbound_count, $3 as inbound_count, ($1 + $3) as total_count;

total_5_6 = JOIN total_2005 BY $0 FULL OUTER, total_2006 BY $0;
total_5_6_7 = JOIN total_5_6 BY $0 FULL OUTER, total_2007 BY $0;
total_all = JOIN total_5_6_7 BY $0 FULL OUTER, total_2008 BY $0;

total_all_red = FOREACH total_all GENERATE $0 as name, ($1 + $5 + $9 + $13) as outbound_count, ($2 + $6 + $10 + $14) as inbound_count, ($3 + $7 + $11 + $15) as total_count;
total_all_red_sorted = ORDER total_all_red BY total_count DESC;

top20 = LIMIT total_all_red_sorted 20;

DUMP top20;





