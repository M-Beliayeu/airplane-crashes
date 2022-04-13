show databases;
use airplane_crashes;
show tables;
show columns
from
  Crashes;
select
  *
from
  Crashes;
--- --------------------------
  --- process time
  --- --------------------------
  --- fixme: pad time with 0
  ---
select
  regexp_replace(coalesce(time, "0000"), "[^0-9]", "") as time
from
  Crashes;
alter table
  Crashes
add
  time_processed varchar(4);
update
  Crashes
set
  time_processed = regexp_replace(coalesce(time, "0000"), "[^0-9]", "");
---for debug purposes
select
  time,
  time_processed
from
  Crashes
where
  time_processed is NULL;
--- --------------------------
  --- process date
  --- --------------------------
select
  date
from
  Crashes;
select
  STR_TO_DATE(date, "%M %d, %Y")
from
  Crashes;
alter table
  Crashes
add
  date_processed datetime;
update
  Crashes
set
  date_processed = STR_TO_DATE(date, "%M %d, %Y");
---debug
select
  date,
  date_processed
from
  Crashes
where
  date_processed is NULL;
---fixme: combine date and time
  --- --------------------------
  --- process location
  --- --------------------------
select
  location
from
  Crashes;
---Tienen, Belgium ---> Belgium
select
  SUBSTRING_INDEX(location, ',', -1) as country
from
  Crashes;
alter table
  Crashes
add
  country varchar(45);
update
  Crashes
set
  country = TRIM(SUBSTRING_INDEX(location, ',', -1));
---replace usa states with 'usa'
update
  Crashes
set
  country = 'USA'
where
  country in (
    'Alaska',
    'Alabama',
    'Arkansas',
    'Arizona',
    'California',
    'Colorado',
    'Connecticut',
    'District of Columbia',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Iowa',
    'Idaho',
    'Illinois',
    'Indiana',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Massachusetts',
    'Maryland',
    'Maine',
    'Michigan',
    'Minnesota',
    'Missouri',
    'Mississippi',
    'Montana',
    'North Carolina',
    'North Dakota',
    'Nebraska',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'Nevada',
    'New York',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Virginia',
    'Vermont',
    'Washington',
    'Wisconsin',
    'West Virginia',
    'Wyoming',
    'AK',
    'AL',
    'AR',
    'AZ',
    'CA',
    'CO',
    'CT',
    'DC',
    'DE',
    'FL',
    'GA',
    'HI',
    'IA',
    'ID',
    'IL',
    'IN',
    'KS',
    'KY',
    'LA',
    'MA',
    'MD',
    'ME',
    'MI',
    'MN',
    'MO',
    'MS',
    'MT',
    'NC',
    'ND',
    'NE',
    'NH',
    'NJ',
    'NM',
    'NV',
    'NY',
    'OH',
    'OK',
    'OR',
    'PA',
    'RI',
    'SC',
    'SD',
    'TN',
    'TX',
    'UT',
    'VA',
    'VT',
    'WA',
    'WI',
    'WV',
    'WY'
  );
---'Off Spain' ---> 'Spain'
update
  Crashes
set
  country = SUBSTRING(country, LOCATE(' ', country) + 1)
where
  SUBSTRING_INDEX(location, ' ', 1) = 'Off';
select
  country
from
  crashes;
---fixme: some country names have to be fixed further, e.g. 'Over the Gulf of Finland'
  --- debug
select
  location
from
  Crashes
where
  country is NULL;
--- --------------------------
  --- process route
  --- --------------------------
select
  route
from
  Crashes;
drop table if exists Routes;
create table Routes(
    cid int,
    location varchar(45),
    ordinal int,
    primary key (cid, ordinal),
    constraint fk_Routes_Craches foreign key (cid) references airplane_crashes.Crashes (cid) on delete cascade on update cascade
  );
--- see process_routes.ipynb
select
  *
from
  Routes;
--- --------------------------
  --- process aboard/fatalities
  --- --------------------------
select
  aboard,
  fatalities
from
  Crashes;
---common pattern: "%i (passengers:%i crew:%i)
alter table
  Crashes
add
  column aboard_total int,
add
  column aboard_pass int,
add
  column aboard_crew int,
add
  column fatal_total int,
add
  column fatal_pass int,
add
  column fatal_crew int;
select
  REGEXP_SUBSTR(aboard, '[0-9]+|\\?', 1, 1),
  REGEXP_SUBSTR(aboard, '[0-9]+|\\?', 1, 2),
  REGEXP_SUBSTR(aboard, '[0-9]+|\\?', 1, 3),
  aboard
from
  Crashes;
---fixme: rewrite
update
  Crashes
set
  aboard_total = case
    REGEXP_SUBSTR(aboard, '[0-9]+|\\?', 1, 1)
    when '?' then NULL
    else REGEXP_SUBSTR(aboard, '[0-9]+|\\?', 1, 1)
  end,
  aboard_pass = case
    REGEXP_SUBSTR(aboard, '[0-9]+|\\?', 1, 2)
    when '?' then NULL
    else REGEXP_SUBSTR(aboard, '[0-9]+|\\?', 1, 2)
  end,
  aboard_crew = case
    REGEXP_SUBSTR(aboard, '[0-9]+|\\?', 1, 3)
    when '?' then NULL
    else REGEXP_SUBSTR(aboard, '[0-9]+|\\?', 1, 3)
  end,
  fatal_total = case
    REGEXP_SUBSTR(fatalities, '[0-9]+|\\?', 1, 1)
    when '?' then NULL
    else REGEXP_SUBSTR(fatalities, '[0-9]+|\\?', 1, 1)
  end,
  fatal_pass = case
    REGEXP_SUBSTR(fatalities, '[0-9]+|\\?', 1, 2)
    when '?' then NULL
    else REGEXP_SUBSTR(fatalities, '[0-9]+|\\?', 1, 2)
  end,
  fatal_crew = case
    REGEXP_SUBSTR(fatalities, '[0-9]+|\\?', 1, 3)
    when '?' then NULL
    else REGEXP_SUBSTR(fatalities, '[0-9]+|\\?', 1, 3)
  end;
---check
select
  aboard,
  aboard_total,
  aboard_pass,
  aboard_crew,
  fatalities,
  fatal_total,
  fatal_pass,
  fatal_crew
from
  Crashes;