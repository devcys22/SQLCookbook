12.1 결과셋을 하나의 행으로 피벗하기
 select sum(case when deptno=10 then 1 else 0 end) as deptno_10,
        sum(case when deptno=20 then 1 else 0 end) as deptno_20,
        sum(case when deptno=30 then 1 else 0 end) as deptno_30
   from emp
--------------------------------------------------------------------
select deptno,
       case when deptno=10 then 1 else 0 end as deptno_10,
       case when deptno=20 then 1 else 0 end as deptno_20,
       case when deptno=30 then 1 else 0 end as deptno_30
  from emp
 order by 1
--------------------------------------------------------------------
select deptno,
       sum(case when deptno=10 then 1 else 0 end) as deptno_10,
       sum(case when deptno=20 then 1 else 0 end) as deptno_20,
       sum(case when deptno=30 then 1 else 0 end) as deptno_30
  from emp
 group by deptno
--------------------------------------------------------------------
select sum(case when deptno=10 then 1 else 0 end) as deptno_10,
       sum(case when deptno=20 then 1 else 0 end) as deptno_20,
       sum(case when deptno=30 then 1 else 0 end) as deptno_30
  from emp
--------------------------------------------------------------------
select max(case when deptno=10 then empcount else null end) as deptno_10
       max(case when deptno=20 then empcount else null end) as deptno_20,
       max(case when deptno=10 then empcount else null end) as deptno_30
  from (
select deptno, count(*) as empcount
  from emp
 group by deptno
       ) x

12.2 결과셋을 여러 행으로 피벗하기
  select max(case when job='CLERK'
                   then ename else null end) as clerks,
          max(case when job='ANALYST'
                   then ename else null end) as analysts,
          max(case when job='MANAGER'
                   then ename else null end) as mgrs,
          max(case when job='PRESIDENT'
                   then ename else null end) as prez,
          max(case when job='SALESMAN'
                  then ename else null end) as sales
   from (
 select job,
        ename,
        row_number()over(partition by job order by ename) rn
   from emp
        ) x
  group by rn
