add jar /home/data/json-serde-1.3.7-jar-with-dependencies.jar;
set hive.support.sql11.reserved.keywords=false;

CREATE TABLE tweets (
  id BIGINT,
  created_at STRING,
  source STRING,
  favorited BOOLEAN,
retweet_count INT,
  retweeted_status STRUCT<
    text:STRING,
    user:STRUCT<screen_name:STRING,name:STRING>,
    retweet_count:INT>,
  entities STRUCT<
    urls:ARRAY<STRUCT<expanded_url:STRING>>,
    user_mentions:ARRAY<STRUCT<screen_name:STRING,name:STRING>>,
    hashtags:ARRAY<STRUCT<text:STRING>>>,
  text STRING,
  user STRUCT<
    screen_name:STRING,
    name:STRING,
    friends_count:INT,
    followers_count:INT,
    statuses_count:INT,
    verified:BOOLEAN,
    utc_offset:INT,
    time_zone:STRING>,
  in_reply_to_screen_name STRING
) 
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE;

load data inpath '/xd/tweets_hdfs/*' overwrite into table tweets;