Chapter 8. 날짜 산술
<DB2>
 select hiredate -5 day   as hd_minus_5D,
        hiredate +5 day   as hd_plus_5D,
        hiredate -5 month as hd_minus_5M,
        hiredate +5 month as hd_plus_5M,
        hiredate -5 year  as hd_minus_5Y,
        hiredate +5 year  as hd_plus_5Y
   from emp
  where deptno = 10

<Oracle>
 select hiredate-5                 as hd_minus_5D,
        hiredate+5                 as hd_plus_5D,
        add_months(hiredate,-5)    as hd_minus_5M,
        add_months(hiredate,5)     as hd_plus_5M,
        add_months(hiredate,-5*12) as hd_minus_5Y,
        add_months(hiredate,5*12)  as hd_plus_5Y
   from emp
  where deptno = 10

<PostgreSQL>
 select hiredate - interval '5 day'   as hd_minus_5D,
        hiredate + interval '5 day'   as hd_plus_5D,
        hiredate - interval '5 month' as hd_minus_5M,
        hiredate + interval '5 month' as hd_plus_5M,
        hiredate - interval '5 year'  as hd_minus_5Y,
        hiredate + interval '5 year'  as hd_plus_5Y
   from emp
  where deptno=10

<MySQL>
 select hiredate - interval 5 day   as hd_minus_5D,
        hiredate + interval 5 day   as hd_plus_5D,
        hiredate - interval 5 month as hd_minus_5M,
        hiredate + interval 5 month as hd_plus_5M,
        hiredate - interval 5 year  as hd_minus_5Y,
        hiredate + interval 5 year  as hd_plus_5Y
   from emp
  where deptno=10
--------------------------------------------------------------------
 select date_add(hiredate,interval -5 day)   as hd_minus_5D,
        date_add(hiredate,interval  5 day)   as hd_plus_5D,
        date_add(hiredate,interval -5 month) as hd_minus_5M,
        date_add(hiredate,interval  5 month) as hd_plus_5M,
        date_add(hiredate,interval -5 year)  as hd_minus_5Y,
        date_add(hiredate,interval  5 year)  as hd_plus_5DY
   from emp
  where deptno=10

<SQL Server>
 select dateadd(day,-5,hiredate)   as hd_minus_5D,
        dateadd(day,5,hiredate)    as hd_plus_5D,
        dateadd(month,-5,hiredate) as hd_minus_5M,
        dateadd(month,5,hiredate)  as hd_plus_5M,
        dateadd(year,-5,hiredate)  as hd_minus_5Y,
        dateadd(year,5,hiredate)   as hd_plus_5Y
   from emp
  where deptno = 10

8.2 두 날짜 사이의 일수 알아내기
<DB2>
  select days(ward_hd) - days(allen_hd)
    from (
  select hiredate as ward_hd
    from emp
   where ename = 'WARD'
         ) x,
         (
  select hiredate as allen_hd
    from emp
  where ename = 'ALLEN'
        ) y

<Oracle과 PostgreSQL>
 select ward_hd - allen_hd
    from (
  select hiredate as ward_hd
    from emp
   where ename = 'WARD'
         ) x,
         (
  select hiredate as allen_hd
    from emp
  where ename = 'ALLEN'
        ) y

<MySQL와 SQL Server>
 select datediff(day,allen_hd,ward_hd)
    from (
  select hiredate as ward_hd
    from emp
   where ename = 'WARD'
         ) x,
         (
  select hiredate as allen_hd
    from emp
  where ename = 'ALLEN'
        ) y
--------------------------------------------------------------------
select ward_hd, allen_hd
    from (
select hiredate as ward_hd
  from emp
 where ename = 'WARD'
       ) y,
       (
select hiredate as allen_hd
  from emp
 where ename = 'ALLEN'
       ) x

8.3 두 날짜 사이의 영업일수 알아내기
<DB2>
 select sum(case when dayname(jones_hd+t500.id day -1 day)
                    in ( 'Saturday','Sunday' )
                  then 0 else 1
             end) as days
    from (
  select max(case when ename = 'BLAKE'
                  then hiredate
             end) as blake_hd,
         max(case when ename = 'JONES'
                 then hiredate
            end) as jones_hd
   from emp
  where ename in ( 'BLAKE','JONES' )
        ) x,
        t500
  where t500.id <= blake_hd-jones_hd+1

<MySQL>
 select sum(case when date_format(
                          date_add(jones_hd,
                                   interval t500.id-1 DAY),'%a')
                    in ( 'Sat','Sun' )
                  then 0 else 1
             end) as days
    from (
  select max(case when ename = 'BLAKE'
                  then hiredate
            end) as blake_hd,
        max(case when ename = 'JONES'
                 then hiredate
             end) as jones_hd
   from emp
  where ename in ( 'BLAKE','JONES' )
        ) x,
        t500
  where t500.id <= datediff(blake_hd,jones_hd)+1

<Oracle>
 select sum(case when to_char(jones_hd+t500.id-1,'DY')
                    in ( 'SAT','SUN' )
                  then 0 else 1
             end) as days
    from (
  select max(case when ename = 'BLAKE'
                  then hiredate
             end) as blake_hd,
         max(case when ename = 'JONES'
                 then hiredate
            end) as jones_hd
   from emp
  where ename in ( 'BLAKE','JONES' )
        ) x,
        t500
  where t500.id <= blake_hd-jones_hd+1

<PostgreSQL>
 select sum(case when trim(to_char(jones_hd+t500.id-1,'DAY'))
                    in ( 'SATURDAY','SUNDAY' )
                  then 0 else 1
             end) as days
    from (
  select max(case when ename = 'BLAKE'
                  then hiredate
             end) as blake_hd,
         max(case when ename = 'JONES'
                 then hiredate
            end) as jones_hd
   from emp
  where ename in ( 'BLAKE','JONES' )
        ) x,
        t500
  where t500.id <= blake_hd-jones_hd+1

<SQL Server>
 select sum(case when datename(dw,jones_hd+t500.id-1)
                    in ( 'SATURDAY','SUNDAY' )
                   then 0 else 1
             end) as days
    from (
  selectmax(case when ename = 'BLAKE'
                  then hiredate
             end) as blake_hd,
         max(case when ename = 'JONES'
                 then hiredate
            end) as jones_hd
   from emp
  where ename in ( 'BLAKE','JONES' )
        ) x,
        t500
  where t500.id <= datediff(day,jones_hd-blake_hd)+1
--------------------------------------------------------------------
select case when ename = 'BLAKE'
            then hiredate
       end as blake_hd,
       case when ename = 'JONES'
            then hiredate
       end as jones_hd
  from emp
 where ename in ( 'BLAKE','JONES' )
--------------------------------------------------------------------
select max(case when ename = 'BLAKE'
            then hiredate
       end) as blake_hd,
       max(case when ename = 'JONES'
            then hiredate
       end) as jones_hd
  from emp
 where ename in ( 'BLAKE','JONES' )
--------------------------------------------------------------------
select x.*, t500.*, jones_hd+t500.id-1
  from (
select max(case when ename = 'BLAKE'
                then hiredate
           end) as blake_hd,
       max(case when ename = 'JONES'
                then hiredate
           end) as jones_hd
  from emp
 where ename in ( 'BLAKE','JONES' )
       ) x,
       t500
 where t500.id <= blake_hd-jones_hd+1
