/*CHALLENGE 2 
alter table datasettwo rename column `<ticker>` to ticker;
alter table datasettwo rename column `<date>` to date;
alter table datasettwo rename column `<open>` to open;
alter table datasettwo rename column `<high>` to high;
alter table datasettwo rename column `<low>` to low;
alter table datasettwo rename column `<close>` to close;
alter table datasettwo rename column `<vol>` to vol;

select * from datasettwo;
*/
DELIMITER //
CREATE procedure vwap(
	start_date varchar(12)
)
BEGIN

-- set @start_date_time='201010111015';
set @start_date_time=start_date;

select `date`,
date_add(str_to_date(`date`,"%Y%m%d%H%i"),interval 5 hour)
from datasettwo;

set @end_date=date_add(str_to_date(@start_date_time,"%Y%m%d%H%i"),interval 5 hour);

select sum(`close`*vol)/sum(vol) from datasettwo where str_to_date(`date`,"%Y%m%d%H%i") between str_to_date(@start_date_time,"%Y%m%d%H%i")
and @end_date; 

END //
DELIMITER ;

-- Running the below command on a different file
-- call vwap('201010111015');

-- ALTERNATE SOLUTION --
/*
DELIMITER //
CREATE PROCEDURE vwap (
	mystartdate char(12)
)
BEGIN
-- User enters YYYYMMDDHHmm
-- set @startdatetime='202010110900';
set @startdatetime=mystartdate;
set @startdt=str_to_date(@startdatetime,"%Y%m%d%H%i");
set @enddatetime=DATE_ADD(@startdt, INTERVAL 5 HOUR);
-- SELECT @enddatetime;

SELECT sum(`<vol>`*`<close>`)/sum(`<vol>`) AS VWAP
FROM sd2
WHERE str_to_date(`<date>`,"%Y%m%d%H%i") BETWEEN
@startdt and @enddatetime;

END //
DELIMITER ;
*/