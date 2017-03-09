register '/usr/hdp/2.4.0.0-169/pig/lib/elephant-bird-core-4.13.jar';
register '/usr/hdp/2.4.0.0-169/pig/lib/elephant-bird-pig-4.13.jar';
register '/usr/hdp/2.4.0.0-169/pig/lib/elephant-bird-hadoop-compat-4.13.jar';
register '/usr/hdp/2.4.0.0-169/pig/lib/json-simple-1.1.1.jar';

loadJson  = LOAD '/tmp/input/exrate/exrate.dat' using com.twitter.elephantbird.pig.load.JsonLoader('-nestedLoad') AS (json:map[]);
rates = FOREACH loadJson GENERATE flatten(json#'rates') as (m:map[]);
raws = FOREACH rates GENERATE FLATTEN(m#'id') AS (id:chararray), FLATTEN(m#'Rate') AS (rate:chararray) , FLATTEN(m#'Date') AS (date:chararray) ;
DUMP raws;
store raws into 'stg.exchange_rates' using org.apache.hive.hcatalog.pig.HCatStorer();
