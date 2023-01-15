
 create database dw_twitter;

# Create schemas

 * CREATE SCHEMA IF NOT EXISTS dw_twt;
 * CREATE SCHEMA IF NOT EXISTS dw;


use dw_twitter;

/*
 drop table fact_follow;
 drop table fact_tweet;
 drop table dim_author ;
 drop table dim_date ;
 drop table dim_language ;
 drop table dim_place ;
 drop table dim_search ;
 drop table dim_tag;
 drop table dim_text_msg ;
 drop table dim_user ;
 drop table log_error ;
 drop table log_load ;
*/

# Create tables
CREATE TABLE IF NOT EXISTS dim_user
(
    user_key INT NOT NULL AUTO_INCREMENT,
    user_email VARCHAR(300) NOT NULL,
    user_create_date DATETIME NOT NULL,
    PRIMARY KEY(user_key)
);

CREATE TABLE IF NOT EXISTS dim_search
(
    search_key INT NOT NULL AUTO_INCREMENT,
    search_id VARCHAR(50),
    search_text VARCHAR(2000) NOT NULL,
    search_lang_desc VARCHAR(30) NOT NULL,
    search_lang_cod VARCHAR(5) NOT NULL,
    search_create_date DATETIME NOT NULL,
    PRIMARY KEY(search_key)
);

CREATE TABLE IF NOT EXISTS dim_place
(
    place_key INT NOT NULL AUTO_INCREMENT,
    place_id VARCHAR(50),
    place_type VARCHAR(30),
    place_country VARCHAR(50),
    place_country_cod VARCHAR(3),
    place_city VARCHAR(50),
    place_full_name VARCHAR(50),
    place_create_date DATETIME,
    PRIMARY KEY(place_key)
);

CREATE TABLE IF NOT EXISTS dim_language
(
    language_key INT NOT NULL AUTO_INCREMENT,
    language_cod VARCHAR(5),
    language_description VARCHAR(30),
    language_create_date DATETIME,
    PRIMARY KEY(language_key)
);

CREATE TABLE IF NOT EXISTS fact_tweet
(
    tweet_key INT NOT NULL AUTO_INCREMENT,
    author_key INT NOT NULL,
    date_key INT NOT NULL,
    user_key INT NOT NULL,
    search_key INT NOT NULL,
    place_key INT,
    language_key INT NOT NULL,
    tag_key INT NOT NULL,
    text_msg_key INT NOT NULL,
    tweet_retweet INT NOT NULL,
    tweet_reply INT NOT NULL,
    tweet_like INT NOT NULL,
    tweet_quote INT NOT NULL,
    tweet_polarity DECIMAL(18, 16) NOT NULL,
    tweet_subjectivity DECIMAL(18, 16) NOT NULL,
    PRIMARY KEY(tweet_key)
);

CREATE TABLE IF NOT EXISTS dim_author
(
    author_key INT NOT NULL AUTO_INCREMENT,
    author_id VARCHAR(50),
    author_name VARCHAR(50) NOT NULL,
    author_created_twitter DATETIME,
    author_verified BINARY(1),
    author_profile_image_url VARCHAR(512),
    author_create_date DATETIME,
    PRIMARY KEY(author_key)
);

CREATE TABLE IF NOT EXISTS dim_tag
(
    tag_key INT NOT NULL AUTO_INCREMENT,
    tag_word VARCHAR(50) NOT NULL,
    tag_language VARCHAR(5),
    tag_create_date DATETIME NOT NULL,
    PRIMARY KEY(tag_key)
);

CREATE TABLE IF NOT EXISTS dim_text_msg
(
    text_msg_key INT NOT NULL AUTO_INCREMENT,
    text_tweet_id VARCHAR(50),
    text_msg_tweet VARCHAR(2000) NOT NULL,
    text_cleaner_msg VARCHAR(2000) NOT NULL,
    text_translated VARCHAR(2000) NOT NULL,
    text_create_date DATETIME NOT NULL,
    PRIMARY KEY(text_msg_key)
);

CREATE TABLE IF NOT EXISTS fact_follow
(
    follow_key INT NOT NULL AUTO_INCREMENT,
	author_key INT NOT NULL,
    date_key INT NOT NULL,
    author_followers INT NOT NULL,
    author_following INT NOT NULL,
    PRIMARY KEY(follow_key)
);

CREATE TABLE IF NOT EXISTS log_error
(
    err_key INT NOT NULL AUTO_INCREMENT,
    err_msg VARCHAR(2000),
    err_number VARCHAR(10),
    err_date DATETIME,
    err_table VARCHAR(50),
    PRIMARY KEY(err_key)
);

CREATE TABLE IF NOT EXISTS log_load
(
    load_key INT NOT NULL AUTO_INCREMENT,
    load_msg VARCHAR(2000),
    load_stage_qty INT,
    load_dw_qty INT,
    load_date DATETIME,
    load_table VARCHAR(50),
    PRIMARY KEY(load_key)
);

CREATE TABLE IF NOT EXISTS dim_date
(
    date_key INT NOT NULL AUTO_INCREMENT,
    DateFull DATE,
    Day SMALLINT NOT NULL,
    DaySuffix VARCHAR(2) NOT NULL,
    Weekday SMALLINT NOT NULL,
    WeekDayName VARCHAR(10) NOT NULL,
    WeekDayName_Short VARCHAR(3) NOT NULL,
    WeekDayName_FirstLetter VARCHAR(1),
    DOWInMonth SMALLINT,
    DayOfYear SMALLINT,
    WeekOfMonth SMALLINT,
    WeekOfYear SMALLINT,
    Month SMALLINT,
    MonthName VARCHAR(10),
    MonthName_Short VARCHAR(3),
    MonthName_FirstLetter VARCHAR(1),
    Quarter SMALLINT,
    QuarterName VARCHAR(6),
    Year INT,
    MMYYYY VARCHAR(6),
    MonthYear VARCHAR(7),
    IsWeekend BINARY(1),
    IsHoliday BINARY(1),
    HolidayName VARCHAR(50),
    SpecialDays VARCHAR(50),
    CurrentYear SMALLINT,
    CurrentQuater SMALLINT,
    CurrentMonth SMALLINT,
    CurrentWeek SMALLINT,
    CurrentDay SMALLINT,
    PRIMARY KEY(date_key)
);


# Create FKs
ALTER TABLE fact_tweet
    ADD CONSTRAINT FK_tweet_user
    FOREIGN KEY (user_key)
    REFERENCES dim_user(user_key)
;
    
ALTER TABLE fact_tweet
    ADD CONSTRAINT FK_tweet_language
    FOREIGN KEY (language_key)
    REFERENCES dim_language(language_key)
;
    
ALTER TABLE fact_tweet
    ADD CONSTRAINT FK_tweet_search
    FOREIGN KEY (search_key)
    REFERENCES dim_search(search_key)
;
    
ALTER TABLE fact_tweet
    ADD CONSTRAINT FK_tweet_place
    FOREIGN KEY (place_key)
    REFERENCES dim_place(place_key)
;
    
ALTER TABLE fact_tweet
    ADD CONSTRAINT FK_tweet_author
    FOREIGN KEY (author_key)
    REFERENCES dim_author(author_key)
;
    
ALTER TABLE fact_tweet
    ADD CONSTRAINT FK_tweet_tag
    FOREIGN KEY (tag_key)
    REFERENCES dim_tag(tag_key)
;
    
ALTER TABLE fact_tweet
    ADD CONSTRAINT FK_tweet_text_msg
    FOREIGN KEY (text_msg_key)
    REFERENCES dim_text_msg(text_msg_key)
;
    
ALTER TABLE fact_follow
    ADD CONSTRAINT FK_follow_author
    FOREIGN KEY (author_key)
    REFERENCES dim_author(author_key)
    ON DELETE CASCADE
    ON UPDATE CASCADE
;
    
ALTER TABLE fact_follow
    ADD CONSTRAINT FK_follow_date
    FOREIGN KEY (date_key)
    REFERENCES dim_date(date_key)
;
    
ALTER TABLE fact_tweet
    ADD CONSTRAINT FK_tweet_date
    FOREIGN KEY (date_key)
    REFERENCES dim_date(date_key)
;
    

# Create Indexes
CREATE INDEX indx_user_email ON dim_user (user_email);
CREATE INDEX indx_search_id ON dim_search (search_id);
CREATE INDEX indx_search_lang ON dim_search (search_lang_cod);
CREATE INDEX indx_place_id ON dim_place (place_id);
CREATE INDEX indx_place_country ON dim_place (place_country_cod);
CREATE INDEX indx_language_cod ON dim_language (language_cod);
CREATE INDEX indx_tweet_date ON fact_tweet (date_key);
CREATE INDEX indx_tweet_searh ON fact_tweet (search_key);
CREATE INDEX indx_tweet_user ON fact_tweet (user_key);
CREATE INDEX indx_tweet_place ON fact_tweet (place_key);
CREATE INDEX indx_author_id ON dim_author (author_id);
CREATE INDEX indx_tag_word ON dim_tag (tag_word);
CREATE INDEX indx_text_tweet_id ON dim_text_msg (text_tweet_id);
CREATE INDEX indx_date_day ON dim_date (Day, Month, Year);
CREATE INDEX indx_date_month ON dim_date (Month, Year);


#Create users
create user 'etl_nifi'@'172.17.0.1' identified by 'password';
GRANT Delete ON *.* TO 'etl_nifi'@'172.17.0.1';
GRANT Insert ON *.* TO 'etl_nifi'@'172.17.0.1';
GRANT Select ON *.* TO 'etl_nifi'@'172.17.0.1';
GRANT Update ON *.* TO 'etl_nifi'@'172.17.0.1';
GRANT Execute ON *.* TO 'etl_nifi'@'172.17.0.1';
GRANT Insert ON dw_twitter.* TO 'etl_nifi'@'172.17.0.1';
GRANT Select ON dw_twitter.* TO 'etl_nifi'@'172.17.0.1';
GRANT Trigger ON dw_twitter.* TO 'etl_nifi'@'172.17.0.1';
GRANT Update ON dw_twitter.* TO 'etl_nifi'@'172.17.0.1';
GRANT Create temporary tables ON dw_twitter.* TO 'etl_nifi'@'172.17.0.1';
GRANT Execute ON dw_twitter.* TO 'etl_nifi'@'172.17.0.1';
GRANT Lock tables ON dw_twitter.* TO 'etl_nifi'@'172.17.0.1';
GRANT Delete ON dw_twitter.* TO 'etl_nifi'@'172.17.0.1';
GRANT Delete ON mysql.func TO 'etl_nifi'@'172.17.0.1';
GRANT Insert ON mysql.func TO 'etl_nifi'@'172.17.0.1';
GRANT Select ON mysql.func TO 'etl_nifi'@'172.17.0.1';
GRANT Trigger ON mysql.func TO 'etl_nifi'@'172.17.0.1';
GRANT Update ON mysql.func TO 'etl_nifi'@'172.17.0.1';


commit;

show grants for 'jamil'@'localhost'
GRANT SELECT, INSERT, SHOW DATABASES, SHOW VIEW, ON *.* TO 'etl_nifi'@'172.17.0.2';
GRANT SELECT, INSERT, UPDATE, DELETE ON 'mysql'.'func' TO 'etl_nifi'@'172.17.0.2';



