Chapter 9. 날짜 조작기법

9.1 연도의 윤년 여부 결정하기

<Oracle>
 select to_char(
          last_day(add_months(trunc(sysdate,'y'),1)),
         'DD')
   from t1


<MySQL>
 select day(
        last_day(
        date_add(
        date_add(
        date_add(current_date,
                 interval -dayofyear(current_date) day),
                 interval 1 day),
                 interval 1 month))) dy
   from t1
  
<Oracle>
select trunc(sysdate,'y')
from t1
--------------------------------------------------------------------
select add_months(trunc(sysdate,'y'),1) dy
  from t1
--------------------------------------------------------------------
select last_day(add_months(trunc(sysdate,'y'),1)) dy
  from t1
  
<MySQL>
select date_add(
       date_add(current_date,
                interval -dayofyear(current_date) day),
                interval 1 day) dy
  from t1
--------------------------------------------------------------------
select date_add(
       date_add(
       date_add(current_date,
                interval -dayofyear(current_date) day),
                interval 1 day),
                interval 1 month) dy
  from t1
--------------------------------------------------------------------
select last_day(
       date_add(
       date_add(
       date_add(current_date,
                interval -dayofyear(current_date) day),
                interval 1 day),
                interval 1 month)) dy
  from t1

9.2 연도의 날짜 수 알아내기

<Oracle>
 select add_months(trunc(sysdate,'y'),12) - trunc(sysdate,'y')
   from dual

<MySQL>
 select datediff((curr_year + interval 1 year),curr_year)
   from (
 select adddate(current_date,-dayofyear(current_date)+1) curr_year
   from t1
        ) x
   
9.3 날짜에서 시간 단위 추출하기
<DB2>
 select    hour( current_timestamp ) hr,
         minute( current_timestamp ) min,
         second( current_timestamp ) sec,
            day( current_timestamp ) dy,
          month( current_timestamp ) mth,
            year( current_timestamp ) yr
   from t1
--------------------------------------------------------------------
select
        extract(hour from current_timestamp)
      , extract(minute from current_timestamp
      , extract(second from current_timestamp)
      , extract(day from current_timestamp)
      , extract(month from current_timestamp)
      , extract(year from current_timestamp)

<Oracle>
  select to_number(to_char(sysdate,'hh24')) hour,
         to_number(to_char(sysdate,'mi')) min,
         to_number(to_char(sysdate,'ss')) sec,
         to_number(to_char(sysdate,'dd')) day,
         to_number(to_char(sysdate,'mm')) mth,
         to_number(to_char(sysdate,'yyyy')) year
   from dual

<PostgreSQL>
 select to_number(to_char(current_timestamp,'hh24'),'99') as hr,
        to_number(to_char(current_timestamp,'mi'),'99') as min,
        to_number(to_char(current_timestamp,'ss'),'99') as sec,
        to_number(to_char(current_timestamp,'dd'),'99') as day,
        to_number(to_char(current_timestamp,'mm'),'99') as mth,
        to_number(to_char(current_timestamp,'yyyy'),'9999') as yr
   from t1

<MySQL>
 select date_format(current_timestamp,'%k') hr,
        date_format(current_timestamp,'%i') min,
        date_format(current_timestamp,'%s') sec,
        date_format(current_timestamp,'%d') dy,
        date_format(current_timestamp,'%m') mon,
        date_format(current_timestamp,'%Y') yr
   from t1

<SQL Server>
 select datepart( hour, getdate()) hr,
        datepart( minute,getdate()) min,
        datepart( second,getdate()) sec,
        datepart( day, getdate()) dy,
        datepart( month, getdate()) mon,
        datepart( year, getdate()) yr
   from t1
                
9.4 월의 첫 번째 요일과 마지막 요일 알아내기

<Oracle>
select trunc(sysdate,'mm') firstday,
       last_day(sysdate) lastday
from dual
                

<MySQL>
 select date_add(current_date,
                 interval -day(current_date)+1 day) firstday,
        last_day(current_date) lastday
   from t1
               
9.5 연도의 특정 요일의 모든 날짜 알아내기
                
<Oracle>
   with x
     as (
 select trunc(sysdate,'y')+level-1 dy
   from t1
   connect by level <=
      add_months(trunc(sysdate,'y'),12)-trunc(sysdate,'y')
 )
 select *
   from x
  where to_char( dy, 'dy') = 'fri'
                
<MySQL>
	  with recursive cal (dy,yr)
   as
     (
     select dy, extract(year from dy) as yr
   from
     (select adddate
             (adddate(current_date, interval - dayofyear(current_date)
   day), interval 1 day) as dy) as tmp1
   union all
     select date_add(dy, interval 1 day), yr
  from cal
  where extract(year from date_add(dy, interval 1 day)) = yr
  )
     select dy from cal
     where dayofweek(dy) = 6
