use sqlchallenges;

CREATE TEMPORARY TABLE opentimes
SELECT `Date` as Date1, 
       min(`Time`) as OpenTime
FROM datasetthree group by 1;

CREATE TEMPORARY TABLE closetimes
SELECT `Date` as Date1, 
       max(`Time`) as CloseTime
FROM datasetthree group by 1;

CREATE TEMPORARY TABLE openprice
SELECT p.`Date` as Date1, 
       p.`Open` as OpenPrice, 
       c.`OpenTime`
FROM datasetthree p
INNER JOIN opentimes c ON c.`OpenTime` = p.`Time`
GROUP BY p.`Date`;

CREATE TEMPORARY TABLE closeprice
SELECT p.`Date` as Date1, 
       p.`Close` as ClosePrice, 
       c.`CloseTime`
FROM datasetthree p
INNER JOIN closetimes c ON c.`CloseTime` = p.`Time`
GROUP BY p.`Date`;

-- Creation of temporary table to determine the 3 days on which prices increased or decreased the most
CREATE TEMPORARY TABLE prices
SELECT op.Date1, 
       abs(cp.ClosePrice - op.OpenPrice) as Difference
FROM openprice op
INNER JOIN closeprice cp ON cp.Date1 = op.Date1
order by 2 desc
limit 3;

--  days on which prices increased or decreased the most in descending order of date range
select * from prices order by date1;

-- Creation of temporary table to capture the maxHigh on the 3 dates determined above
CREATE TEMPORARY TABLE maxHigh
SELECT p.Date1, 
       p.Difference,
       max(`High`) as High1
FROM datasetthree ds
INNER JOIN prices p ON ds.`Date`= p.Date1
group by 1;

-- Creation of temporary table to capture the time at which maxHigh occurs on the 3 dates determined above
CREATE TEMPORARY TABLE maxHighResult
SELECT p.Date1, 
       p.Difference,
       ds.`Time`,
       max(`High`)
FROM datasetthree ds
INNER JOIN maxHigh p ON ds.`Date`= p.Date1 and ds.High=p.High1
group by 1;

-- To display result of max high results of time
select * from maxHighResult;
