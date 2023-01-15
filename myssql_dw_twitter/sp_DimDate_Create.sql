DELIMITER $$

use dw_twitter $$

DROP PROCEDURE IF EXISTS sp_DimDate_Create $$

CREATE PROCEDURE sp_DimDate_Create(IN StartYear INT, IN EndYear INT) 
BEGIN

DECLARE CountTable INT default 0;
DECLARE StartDate DATE;
DECLARE EndDate DATE;

SELECT CountTable = count(date_key) FROM dim_date;

set StartDate = CONVERT(CONCAT(CONVERT(StartYear, CHAR),"-01-01"), DATE);
set EndDate   = CONVERT(CONCAT(CONVERT(EndYear, CHAR),"-12-31"), DATE);

    WHILE StartDate <= EndDate do
      	  
    	INSERT INTO dim_date (
          DateFull,
          Day,
          DaySuffix,
          Weekday,
          WeekDayName,
          WeekDayName_Short,
          WeekDayName_FirstLetter,
          DOWInMonth,
          DayOfYear,
          WeekOfMonth,
          WeekOfYear,
          Month,
          MonthName,
          MonthName_Short,
          MonthName_FirstLetter,
          Quarter,
          QuarterName,
          Year,
          MMYYYY,
          MonthYear,
          IsWeekend,
          IsHoliday
          /*FirstDateofYear,
          LastDateofYear,
          FirstDateofQuater,
          LastDateofQuater,
          FirstDateofMonth,
          LastDateofMonth,
          FirstDateofWeek,
          LastDateofWeek */
		)
        SELECT -- DateKey = YEAR(StartDate) * 10000 + MONTH(StartDate) * 100 + DAY(StartDate),
          StartDate,
          DAY(StartDate),
           CASE 
		       WHEN DAY(StartDate) = 1
			     OR DAY(StartDate) = 21
			     OR DAY(StartDate) = 31
			     THEN 'st'
			   WHEN DAY(StartDate) = 2
			     OR DAY(StartDate) = 22
			     THEN 'nd'
			   WHEN DAY(StartDate) = 3
			     OR DAY(StartDate) = 23
			     THEN 'rd'
			     ELSE 'th'
			   END,
          WEEKDAY(StartDate),
          DAYNAME(StartDate),
          UPPER(LEFT(DAYNAME(StartDate), 3)),
          LEFT(DAYNAME(StartDate), 1),
          DAYOFMONTH(StartDate),
          DAYOFYEAR(StartDate),
          WEEK(StartDate, 3) - WEEK(StartDate - INTERVAL DAY(StartDate)-1 DAY, 3) + 1,
          WEEK(StartDate,3),
          MONTH(StartDate),
          MONTHNAME(StartDate),
          UPPER(LEFT(MONTHNAME(StartDate), 3)),
          LEFT(MONTHNAME(StartDate), 1),
          QUARTER(StartDate),
          CASE 
			WHEN QUARTER(StartDate) = 1
				THEN 'First'
			WHEN QUARTER(StartDate) = 2
				THEN 'Second'
			WHEN QUARTER(StartDate) = 3
				THEN 'Third'
			WHEN QUARTER(StartDate) = 4
				THEN 'Fourth'
			END,
		  YEAR(StartDate),
          CONCAT(RIGHT('0' + MONTH(StartDate), 2), YEAR(StartDate)),
          CONCAT(YEAR(StartDate), UPPER(LEFT(MONTHNAME(StartDate), 3))),
          CASE 
	          WHEN DAYNAME(StartDate) = 'Sunday' OR DAYNAME(StartDate) = 'Saturday'
              THEN 1
              ELSE 0
          END,
          0
          /*FirstDateofYear = CAST(CAST(YEAR(StartDate) AS VARCHAR(4)) + '-01-01' AS DATE),
          LastDateofYear = CAST(CAST(YEAR(StartDate) AS VARCHAR(4)) + '-12-31' AS DATE),
          FirstDateofQuater = DATEADD(qq, DATEDIFF(qq, 0, StartDate), 0),
          LastDateofQuater = DATEADD(dd, - 1, DATEADD(qq, DATEDIFF(qq, 0, StartDate) + 1, 0)),
          FirstDateofMonth = CAST(CAST(YEAR(StartDate) AS VARCHAR(4)) + '-' + CAST(MONTH(StartDate) AS VARCHAR(2)) + '-01' AS DATE),
          LastDateofMonth = EOMONTH(StartDate),
          FirstDateofWeek = DATEADD(dd, - (DATEPART(dw, StartDate) - 1), StartDate),
          LastDateofWeek = DATEADD(dd, 7 - (DATEPART(dw, StartDate)), StartDate) */
          ; 
          /*end insert select */
 
       SET StartDate = DATE_ADD(StartDate, interval 1 day);

    end while;

    /* Update Holiday information */
    UPDATE dim_date
    SET IsHoliday = 1,
       HolidayName = 'Christmas'
    WHERE Month = 12 AND DAY = 25;

    UPDATE dim_date
    SET SpecialDays = 'Valentines Day'
    WHERE Month = 2 AND DAY = 14;

	UPDATE dim_date
    SET SpecialDays = 'Brazil''s Valentines Day'
    WHERE Month = 6 AND DAY = 12;

	UPDATE dim_date
		SET IsHoliday = 1,
        HolidayName = 'Good Friday'
	WHERE Month = 4 AND DAY  = 18;

	UPDATE dim_date
		SET IsHoliday = 1,
        HolidayName = 'Easter Monday'
	WHERE Month = 4 AND DAY  = 21;

   UPDATE dim_date
		SET IsHoliday = 1,
        HolidayName = 'Early May Bank Holiday'
	WHERE Month = 5 AND DAY  = 5;

	UPDATE dim_date
		SET IsHoliday = 1,
        HolidayName = 'Spring Bank Holiday'
	WHERE Month = 5 AND DAY  = 26;

    UPDATE dim_date
		SET IsHoliday = 1,
        HolidayName = 'Summer Bank Holiday'
	WHERE Month = 8 AND DAY  = 25;
 	
    UPDATE dim_date
		SET SpecialDays = 'Boxing Day'
	WHERE Month = 12 AND DAY  = 26	;

	UPDATE dim_date
		SET IsHoliday = 1,
        HolidayName  = 'New Year''s Day'
	WHERE Month = 1 AND DAY = 1;

END $$

DELIMITER ;

