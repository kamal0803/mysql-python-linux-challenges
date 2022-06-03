/*CHALLENGE 1 */

use sqlchallenges;
select * from datasetone;
alter table datasetone rename column `<ticker>` to ticker;
alter table datasetone rename column `<date>` to date;
alter table datasetone rename column `<open>` to open;
alter table datasetone rename column `<high>` to high;
alter table datasetone rename column `<low>` to low;
alter table datasetone rename column `<close>` to close;
alter table datasetone rename column `<vol>` to vol;
desc datasetone;
alter table datasetone add gain double;
update datasetone set gain=close-open;
alter table datasetone add percentage double;
update datasetone set percentage=(gain/open)*100;
select *  from datasetone order by percentage desc ;
select 'The gain of stock with ticker' as '',ticker as Ticker, 'has gain' as '',gain as Gain, 
'and the gain percentage is' as '',percentage as `Percentage Gain`  
from datasetone order by percentage desc limit 5;
