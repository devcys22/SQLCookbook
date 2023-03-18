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
