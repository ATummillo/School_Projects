data_2005 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2005.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2006 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2006.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2007 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2007.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;
data_2008 = load 'hdfs://localhost:9000/user/anthonytummillo/pig_space/2008.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'UNIX', 'SKIP_INPUT_HEADER') AS (year:int, month:int, day_of_month:int, day_of_week:int, dep_time:int, crs_dep_time:int, arr_time:int, crs_arr_time:int, unique_carrier:chararray, flight_num:int, tail_num:chararray, actual_elapsed_time:int, crs_elapsed_time:int, air_time:int, arr_delay:int, dep_delay:int, origin:chararray, dest:chararray, distance:int, taxi_in:int, taxi_out:int, cancelled:int, cancellation_code:chararray, diverted:int, carrier_delay:int, weather_delay:int, nas_delay:int, security_delay:int, late_aircraft_delay:int) ;


filtered_2005 = FILTER data_2005 BY $14 > 15;
filtered_2006 = FILTER data_2006 BY $14 > 15;
filtered_2007 = FILTER data_2007 BY $14 > 15;
filtered_2008 = FILTER data_2008 BY $14 > 15;

filtered_red_2005 = FOREACH filtered_2005 GENERATE $8 as carrier, $14 as total_delay, $24 as carrier_delay;
grouped_filt_2005 = GROUP filtered_red_2005 BY $0;
filtered_red_2006 = FOREACH filtered_2006 GENERATE $8 as carrier, $14 as total_delay, $24 as carrier_delay;
grouped_filt_2006 = GROUP filtered_red_2006 BY $0;
filtered_red_2007 = FOREACH filtered_2007 GENERATE $8 as carrier, $14 as total_delay, $24 as carrier_delay;
grouped_filt_2007 = GROUP filtered_red_2007 BY $0;
filtered_red_2008 = FOREACH filtered_2008 GENERATE $8 as carrier, $14 as total_delay, $24 as carrier_delay;
grouped_filt_2008 = GROUP filtered_red_2008 BY $0;

delayed_2005 = FOREACH grouped_filt_2005 GENERATE $0, (DOUBLE) SUM($1.total_delay) as total_time_delayed, (DOUBLE) SUM($1.carrier_delay) as carrier_time_delayed;
delayed_2006 = FOREACH grouped_filt_2006 GENERATE $0, (DOUBLE) SUM($1.total_delay) as total_time_delayed, (DOUBLE) SUM($1.carrier_delay) as carrier_time_delayed;
delayed_2007 = FOREACH grouped_filt_2007 GENERATE $0, (DOUBLE) SUM($1.total_delay) as total_time_delayed, (DOUBLE) SUM($1.carrier_delay) as carrier_time_delayed;
delayed_2008 = FOREACH grouped_filt_2008 GENERATE $0, (DOUBLE) SUM($1.total_delay) as total_time_delayed, (DOUBLE) SUM($1.carrier_delay) as carrier_time_delayed;

delayed_5_6 = JOIN delayed_2005 BY $0 FULL OUTER, delayed_2006 BY $0;
delayed_5_6_7 = JOIN delayed_5_6 BY $0 FULL OUTER, delayed_2007 BY $0;
delayed_all = JOIN delayed_5_6_7 BY $0 FULL OUTER, delayed_2008 BY $0;

filtered_delayed = FILTER delayed_all BY $0 is not null AND $3 is not null AND $6 is not null AND $9 is not null;

final_delayed = FOREACH filtered_delayed GENERATE $0 as carrier, ($1 + $4 + $7 + $10) as total_delayed, ($2 + $5 + $8 + $11) as carrier_delayed;

final_calc = FOREACH final_delayed GENERATE $0 as carrier, ($2/$1)*100 as percent_carrier;

sorted_final = ORDER final_calc BY percent_carrier DESC;

DUMP sorted_final;



