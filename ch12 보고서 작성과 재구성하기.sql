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

12.3 결과셋 역피벗하기
select dept.deptno,
      case dept.deptno 
      	   when 10 then emp_cnts.deptno_10
           when 20 then emp_cnts.deptno_20
           when 30 then emp_cnts.deptno_30
      end as counts_by_dept
  from emp_cnts cross join
       (select deptno fro dept where deptno <= 30) dept

12.4 결과셋을 한 열을 역피벗하기
with four_rows(id)
 as
(
 select 1
    union all
 select id+1
   from four_rows
  where id < 4
 )
 ,
 x.tab(ename, job_sal,rn)
   as
 (
  select e.ename, e.job, e.sal,
    row_number()over(partition by e.empno
    order by e.empno)
    from emp e 
    join four_rows on 1=1
  )
  
 select
   case rn
   when 1 then ename
   when 2 then job
   when 3 then case(sal as char(4))
  end emps
 from x_tab
 )
)

12.5 결과셋에서 반복값 숨기기
   select
           case when
              lag(deptno)over(order by deptno) = deptno then null
              else deptno end DEPTNO
       , ename
    from emp
Oracle 
 select to_number(
           decode(lag(deptno)over(order by deptno),
                 deptno,null,deptno)
        ) deptno, ename
   from emp
--------------------------------------------------------------------
select lag(deptno)over(order by deptno) lag_deptno,
       deptno,
       ename
  from emp
--------------------------------------------------------------------
select to_number(
           CASE WHEN (lag(deptno)over(order by deptno)
= deptno THEN null else deptno END deptno,
                 deptno,null,deptno)
        ) deptno, ename
  from emp
