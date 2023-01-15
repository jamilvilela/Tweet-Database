CREATE DATABASE DW_Twitter
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DW_Twitter', FILENAME = N'C:\data\MSSQL\DW_Twitter\DW_Twitter.mdf' )
 LOG ON 
( NAME = N'DW_Twitter_log', FILENAME = N'C:\data\MSSQL\DW_Twitter\DW_Twitter.ldf'  )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

USE DW_Twitter
GO

-- Create schemas
 CREATE SCHEMA dw_twt
 go

 CREATE SCHEMA dw
 go


-- Create tables

  CREATE TABLE dw_twt.dim_user
  (
    user_key INT NOT NULL IDENTITY,
    user_email VARCHAR(300) NOT NULL,
    user_create_date DATETIME NOT NULL,
    CONSTRAINT pk_dim_user PRIMARY KEY(user_key) 
  )

  CREATE TABLE dw_twt.dim_search
  (
    search_key INT NOT NULL IDENTITY,
    search_id VARCHAR(50),
    search_text VARCHAR(2000) NOT NULL,
    search_lang_desc VARCHAR(30) NOT NULL,
    search_lang_cod VARCHAR(5) NOT NULL,
    search_create_date DATETIME NOT NULL,
    CONSTRAINT pk_dim_search PRIMARY KEY(search_key)
  )

  CREATE TABLE dw_twt.dim_place
  (
    place_key INT NOT NULL IDENTITY,
    place_id VARCHAR(50),
    place_type VARCHAR(30),
    place_country VARCHAR(50),
    place_country_cod VARCHAR(3),
    place_city VARCHAR(50),
    place_full_name VARCHAR(50),
    place_create_date DATE,
    CONSTRAINT pk_dim_place PRIMARY KEY(place_key)
  )

  CREATE TABLE dw_twt.dim_language
  (
    language_key INT NOT NULL IDENTITY,
    language_cod VARCHAR(5),
    language_description VARCHAR(30),
    language_create_date DATE,
    CONSTRAINT pk_dim_language PRIMARY KEY(language_key)
  )

  CREATE TABLE dw_twt.fact_tweet
  (
    tweet_key INT NOT NULL,
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
    CONSTRAINT pk_fact_tweet PRIMARY KEY(tweet_key)
  )

  CREATE TABLE dw_twt.dim_author
  (
    author_key INT NOT NULL IDENTITY,
    author_id VARCHAR(50),
    author_name VARCHAR(50) NOT NULL,
    author_created_twitter DATE,
    author_verified BINARY(1),
    author_profile_image_url VARCHAR(512),
    author_create_date DATE,
    CONSTRAINT pk_dim_author PRIMARY KEY(author_key)
  )

  CREATE TABLE dw_twt.dim_tag
  (
    tag_key INT NOT NULL IDENTITY,
    tag_word VARCHAR(50) NOT NULL,
    tag_language VARCHAR(5),
    tag_create_date DATETIME NOT NULL,
    CONSTRAINT pk_dim_tag PRIMARY KEY(tag_key)
  )

  CREATE TABLE dw_twt.dim_text_msg
  (
    text_msg_key INT NOT NULL IDENTITY,
    text_tweet_id VARCHAR(50),
    text_msg_tweet VARCHAR(2000) NOT NULL,
    text_cleaner_msg VARCHAR(2000) NOT NULL,
    text_translated VARCHAR(2000) NOT NULL,
    text_create_date DATETIME NOT NULL,
    CONSTRAINT pk_dim_text_msg PRIMARY KEY(text_msg_key)
  )

  CREATE TABLE dw_twt.fact_follow
  (
    author_key INT NOT NULL,
    date_key INT NOT NULL,
    author_followers INT NOT NULL,
    author_following INT NOT NULL,
    CONSTRAINT pk_fact_follow PRIMARY KEY(author_key)
  )

  CREATE TABLE dw.log_error
  (
    err_key INT NOT NULL IDENTITY,
    err_msg VARCHAR(2000),
    err_number VARCHAR(10),
    err_date DATE,
    err_table VARCHAR(50),
    CONSTRAINT pk_dim_log_error PRIMARY KEY(err_key)
  )

  CREATE TABLE dw.log_load
  (
    load_key INT NOT NULL IDENTITY,
    load_msg VARCHAR(2000),
    load_stage_qty INT,
    load_dw_qty INT,
    load_date DATE,
    load_table VARCHAR(50),
    CONSTRAINT pk_dim_log_load PRIMARY KEY(load_key)
  )

  CREATE TABLE dw.dim_date
  (
    date_key INT NOT NULL IDENTITY,
	DateFull DATETIME NOT NULL,
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
    CONSTRAINT pk_dim_date PRIMARY KEY(date_key)
  )


-- Create FKs
ALTER TABLE dw_twt.fact_tweet
    ADD CONSTRAINT FK_tweet_user
    FOREIGN KEY (user_key)
    REFERENCES dw_twt.dim_user(user_key)
;
    
ALTER TABLE dw_twt.fact_tweet
    ADD CONSTRAINT FK_tweet_language
    FOREIGN KEY (language_key)
    REFERENCES dw_twt.dim_language(language_key)
;
    
ALTER TABLE dw_twt.fact_tweet
    ADD CONSTRAINT FK_tweet_search
    FOREIGN KEY (search_key)
    REFERENCES dw_twt.dim_search(search_key)
;
    
ALTER TABLE dw_twt.fact_tweet
    ADD CONSTRAINT FK_tweet_place
    FOREIGN KEY (place_key)
    REFERENCES dw_twt.dim_place(place_key)
;
    
ALTER TABLE dw_twt.fact_tweet
    ADD CONSTRAINT FK_tweet_author
    FOREIGN KEY (author_key)
    REFERENCES dw_twt.dim_author(author_key)
;
    
ALTER TABLE dw_twt.fact_tweet
    ADD CONSTRAINT FK_tweet_tag
    FOREIGN KEY (tag_key)
    REFERENCES dw_twt.dim_tag(tag_key)
;
    
ALTER TABLE dw_twt.fact_tweet
    ADD CONSTRAINT FK_tweet_text_msg
    FOREIGN KEY (text_msg_key)
    REFERENCES dw_twt.dim_text_msg(text_msg_key)
;
    
ALTER TABLE dw_twt.fact_follow
    ADD CONSTRAINT FK_follow_author
    FOREIGN KEY (author_key)
    REFERENCES dw_twt.dim_author(author_key)
    ON DELETE CASCADE
    ON UPDATE CASCADE
;
    
ALTER TABLE dw_twt.fact_follow
    ADD CONSTRAINT FK_follow_date
    FOREIGN KEY (date_key)
    REFERENCES dw.dim_date(date_key)
;
    
ALTER TABLE dw_twt.fact_tweet
    ADD CONSTRAINT FK_tweet_date
    FOREIGN KEY (date_key)
    REFERENCES dw.dim_date(date_key)
;
    

-- Create Indexes
CREATE INDEX indx_user_email ON dw_twt.dim_user (user_email);
CREATE INDEX indx_search_id ON dw_twt.dim_search (search_id);
CREATE INDEX indx_search_lang ON dw_twt.dim_search (search_lang_cod);
CREATE INDEX indx_place_id ON dw_twt.dim_place (place_id);
CREATE INDEX indx_place_country ON dw_twt.dim_place (place_country_cod);
CREATE INDEX indx_language_cod ON dw_twt.dim_language (language_cod);
CREATE INDEX indx_tweet_date ON dw_twt.fact_tweet (date_key);
CREATE INDEX indx_tweet_searh ON dw_twt.fact_tweet (search_key);
CREATE INDEX indx_tweet_user ON dw_twt.fact_tweet (user_key);
CREATE INDEX indx_tweet_place ON dw_twt.fact_tweet (place_key);
CREATE INDEX indx_author_id ON dw_twt.dim_author (author_id);
CREATE INDEX indx_tag_word ON dw_twt.dim_tag (tag_word);
CREATE INDEX indx_text_tweet_id ON dw_twt.dim_text_msg (text_tweet_id);
CREATE INDEX indx_date_day ON dw.dim_date (Day, Month, Year);
CREATE INDEX indx_date_month ON dw.dim_date (Month, Year);
