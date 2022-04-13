use airplane_crashes;
show columns
from
  Crashes;
--- general info
select
  *
from
  Crashes;
--- view for analysis
  drop view if exists vw_crashes;
create view vw_crashes as
select
  *,
  year(date_processed) as `year`,
  floor(year(date_processed) / 10) * 10 as decade
from
  Crashes;
--- number of crashes over years
select
  year,
  count(*) as total_crashes
from
  vw_crashes
group by
  year
order by
  year asc;
--- number of crashes by decades
select
  decade,
  count(*) as total_crashes
from
  vw_crashes
group by
  decade
order by
  decade asc;
--- countries where accidents occur more often
select
  country,
  count(*) as `total number of crashes
from vw_crashes
group by country
order by ` total number of crashes ` desc;

--- total and yearly mortality rate
select year, sum(fatal_total)/sum(aboard_total)
from vw_crashes
where aboard_total is not NULL and fatal_total is not null
group by year with rollup
order by year;

--- 10 most fatal event
select date_processed, fatal_total + COALESCE(ground, 0) as deaths, summary
from vw_crashes
order by deaths desc
limit 10;

--- most fatal events in each year
with helper as (
    select year, 
           fatal_total + COALESCE(ground, 0) as deaths, 
           summary, 
           ROW_NUMBER() over 
                (partition by year order by fatal_total + COALESCE(ground, 0) desc) as rn
    from vw_crashes
)
select year, deaths, summary
from helper
where rn = 1;

--- total and yearly percentage of military planes crashes
alter table Crashes add fulltext(operator, summary);

with army_helper as (
    select year, 
    case when match(operator, summary) against ('army force navy military infantry marines') > 0
        then 1
        else 0 end as military
    from vw_crashes
)
select year, AVG(military)
from army_helper
group by year with rollup
order by year;