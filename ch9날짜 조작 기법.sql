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

9.6 월의 특정 요일의 첫 번째 및 마지막 발생일 알아내기
<Oracle>
select next_day(trunc(sysdate,'mm')-1,'MONDAY') first_monday,
       next_day(last_day(trunc(sysdate,'mm'))-7,'MONDAY') last_monday
  from dual

<MySQL>
 select first_monday,
         case month(adddate(first_monday,28))
              when mth then adddate(first_monday,28)
                       else adddate(first_monday,21)
         end last_monday
   from (
  select case sign(dayofweek(dy)-2)
              when 0 then dy
              when -1 then adddate(dy,abs(dayofweek(dy)-2))
             when 1 then adddate(dy,(7-(dayofweek(dy)-2)))
        end first_monday,
        mth
   from (
 select adddate(adddate(current_date,-day(current_date)),1) dy,
        month(current_date) mth
   from t1
        ) x
        ) y
		
9.7 달력 만들기
<Oracle>
  with x
     as (
  select *
    from (
  select to_char(trunc(sysdate,'mm')+level-1,'iw') wk,
         to_char(trunc(sysdate,'mm')+level-1,'dd') dm,
         to_number(to_char(trunc(sysdate,'mm')+level-1,'d')) dw,
         to_char(trunc(sysdate,'mm')+level-1,'mm') curr_mth,
         to_char(sysdate,'mm') mth
   from dual
  connect by level <= 31
        )
  where curr_mth = mth
 )
 select max(case dw when 2 then dm end) Mo,
        max(case dw when 3 then dm end) Tu,
        max(case dw when 4 then dm end) We,
        max(case dw when 5 then dm end) Th,
        max(case dw when 6 then dm end) Fr,
        max(case dw when 7 then dm end) Sa,
        max(case dw when 1 then dm end) Su
   from x
  group by wk
  order by wk

<MySQL>
with recursive  x(dy,dm,mth,dw,wk)
      as (
  select dy,
         day(dy) dm,
         datepart(m,dy) mth,
         datepart(dw,dy) dw,
         case when datepart(dw,dy) = 1
              then datepart(ww,dy)-1
              else datepart(ww,dy)
        end wk
   from (
 select date_add(day,-day(getdate())+1,getdate()) dy
   from t1
        ) x
  union all
  select dateadd(d,1,dy), day(date_add(d,1,dy)), mth,
         datepart(dw,dateadd(d,1,dy)),
         case when datepart(dw,date_add(d,1,dy)) = 1
              then datepart(wk,date_add(d,1,dy))-1
              else datepart(wk,date_add(d,1,dy))
         end
    from x
   where datepart(m,date_add(d,1,dy)) = mth
 )
 select max(case dw when 2 then dm end) as Mo,
        max(case dw when 3 then dm end) as Tu,
        max(case dw when 4 then dm end) as We,
        max(case dw when 5 then dm end) as Th,
        max(case dw when 6 then dm end) as Fr,
        max(case dw when 7 then dm end) as Sa,
        max(case dw when 1 then dm end) as Su
   from x
  group by wk
  order by wk;

9.8 해당 연도의 분기 시작일 및 종료일 나열하기
<Oracle>
 select rownum qtr,
        add_months(trunc(sysdate,'y'),(rownum-1)*3) q_start,
        add_months(trunc(sysdate,'y'),rownum*3)-1 q_end
   from emp
  where rownum <= 4

<MySQL>
	      with recursive x (dy,cnt)
     as (
	         select
         adddate(current_date,(-dayofyear(current_date))+1) dy
           ,id
	     from t1
	   union all
	         select adddate(dy, interval 3 month ), cnt+1
	         from x
         where cnt+1 <= 4
        )

       select quarter(adddate(dy,-1)) QTR
    ,  date_add(dy, interval -3 month) Q_start
    ,  adddate(dy,-1)  Q_end
     from x
     order by 1;

9.9 지정 분기의 시작일 및 종료일 알아내기
select 20051 as yrq from t1 union all
select 20052 as yrq from t1 union all
select 20053 as yrq from t1 union all
select 20054 as yrq from t1
		
<Oracle>
 select add_months(q_end,-2) q_start,
         last_day(q_end) q_end
    from (
  select to_date(substr(yrq,1,4)||mod(yrq,10)*3,'yyyymm') q_end
    from (
  select 20051 yrq from dual union all
  select 20052 yrq from dual union all
  select 20053 yrq from dual union all
  select 20054 yrq from dual
        ) x
        ) y
		
<MySQL>
 select date_add(
          adddate(q_end,-day(q_end)+1),
                 interval -2 month) q_start,
         q_end
    from (
  select last_day(
      str_to_date(
           concat(
           substr(yrq,1,4),mod(yrq,10)*3),'%Y%m')) q_end
   from (
 select 20051 as yrq from t1 union all
 select 20052 as yrq from t1 union all
 select 20053 as yrq from t1 union all
 select 20054 as yrq from t1
        ) x
        ) y
	
<Oracle>
select substr(yrq,1,4) yr, mod(yrq,10)*3 mth
  from (
select 20051 yrq from t1 union all
select 20052 yrq from t1 union all
select 20053 yrq from t1 union all
select 20054 yrq from t1
       ) x
----------------------------------------------------------------
select to_date(substr(yrq,1,4)||mod(yrq,10)*3,'yyyymm') q_end
  from (
select 20051 yrq from t1 union all
select 20052 yrq from t1 union all
select 20053 yrq from t1 union all
select 20054 yrq from t1
       ) x

<MySQL>
select substr(cast(yrq as varchar),1,4) yr, mod(yrq,10)*3 mth
  from (
select 20051 yrq from t1 union all
select 20052 yrq from t1 union all
select 20053 yrq from t1 union all
select 20054 yrq from t1
       ) x
--------------------------------------------------------------------
select last_day(
    str_to_date(
         concat(
         substr(yrq,1,4),mod(yrq,10)*3),'%Y%m')) q_end
  from (
select 20051 as yrq from t1 union all
select 20052 as yrq from t1 union all
select 20053 as yrq from t1 union all
select 20054 as yrq from t1
       ) x

9.10 누락된 날짜 채우기
select distinct
       extract(year from hiredate) as year
  from emp
		
<Oracle>
   with x
      as (
  select add_months(start_date,level-1) start_date
    from (
  select min(trunc(hiredate,'y')) start_date,
         add_months(max(trunc(hiredate,'y')),12) end_date
    from emp
         )
   connect by level <= months_between(end_date,start_date)
 )
 select x.start_date MTH, count(e.hiredate) num_hired
   from x left join emp e
     on (x.start_date = trunc(e.hiredate,'mm'))
  group by x.start_date
  order by 1
		
<MySQL>
with recursive x (start_date,end_date)
     as
    (
      select
          adddate(min(hiredate),
          -dayofyear(min(hiredate))+1)  start_date
          ,adddate(max(hiredate),
          -dayofyear(max(hiredate))+1)  end_date
          from emp
       union all
          select date_add(start_date,interval 1 month)
          , end_date
          from x
          where date_add(start_date, interval 1 month) < end_date
      )

select x.start_date mth, count(e.hiredate) num_hired
 from x left join emp e
   on (extract(year_month from start_date)
          =
       extract(year_month from e.hiredate))
group by x.start_date
order by 1;

9.11 특정 시간 단위 검색하기

<DB2와 MySQL>
 select ename
   from emp
 where monthname(hiredate) in ('February','December')
    or dayname(hiredate) = 'Tuesday'

<Oracle과 PostgreSQL>
 select ename
   from emp
 where rtrim(to_char(hiredate,'month')) in ('february','december')
    or rtrim(to_char(hiredate,'day')) = 'tuesday'

9.12 날짜의 특정 부분으로 레코드 비교하기

<Oracle과 PostgreSQL>
 select a.ename ||
        ' was hired on the same month and weekday as '||
        b.ename as msg
   from emp a, emp b
 where to_char(a.hiredate,'DMON') =
       to_char(b.hiredate,'DMON')
   and a.empno < b.empno
 order by a.ename

<MySQL>
 select concat(a.ename,
        ' was hired on the same month and weekday as ',
        b.ename) msg
   from emp a, emp b
  where date_format(a.hiredate,'%w%M') =
        date_format(b.hiredate,'%w%M')
    and a.empno < b.empno
 order by a.ename
		
9.13 중복 날짜 범위 식별하기

<DB2, PostgreSQL, Oracle>
 select a.empno,a.ename,
        'project '||b.proj_id||
        ' overlaps project '||a.proj_id as msg
   from emp_project a,
        emp_project b
  where a.empno = b.empno
    and b.proj_start >= a.proj_start
    and b.proj_start <= a.proj_end
    and a.proj_id != b.proj_id

<MySQL>
 select a.empno,a.ename,
        concat('project ',b.proj_id,
         ' overlaps project ',a.proj_id) as msg
   from emp_project a,
        emp_project b
  where a.empno = b.empno
    and b.proj_start >= a.proj_start
    and b.proj_start <= a.proj_end
    and a.proj_id != b.proj_id

