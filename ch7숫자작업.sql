7.1 평균 계산하기
 select avg(sal) as avg_sal
   from emp
--------------------------------------------------------------------
 select deptno, avg(sal) as avg_sal
   from emp
  group by deptno
--------------------------------------------------------------------
select avg(sal)    select distinct 30/2
  from t2            from t2
--------------------------------------------------------------------
select avg(coalesce(sal,0))    select distinct 30/3
  from t2                        from t2
--------------------------------------------------------------------
select avg(sal)
  from emp
 group by deptno

7.2 열에서 최솟값, 최댓값 찾기
select min(sal) as min_sal, max(sal) as max_sal
   from emp
--------------------------------------------------------------------
 select deptno, min(sal) as min_sal, max(sal) as max_sal
    from emp
   group by deptno
--------------------------------------------------------------------
select deptno, comm
  from emp
 where deptno in (10,30)
 order by 1
--------------------------------------------------------------------
select min(comm), max(comm)
  from emp;
--------------------------------------------------------------------
select deptno, min(comm), max(comm)
  from emp
 group by deptno;
--------------------------------------------------------------------
select min(comm), max(comm)
  from emp
 group by deptno

7.3 열의 값 집계하기
 select sum(sal)
  from emp
--------------------------------------------------------------------
 select deptno, sum(sal) as total_for_dept
   from emp
  group by deptno
--------------------------------------------------------------------
select deptno, comm
  from emp
 where deptno in (10,30)
 order by 1
--------------------------------------------------------------------
select sum(comm)
  from emp
--------------------------------------------------------------------
select deptno, sum(comm)
  from emp
 where deptno in (10,30)
 group by deptno

7.4 테이블에서 행의 수 계산하기
 select count(*)
  from emp
--------------------------------------------------------------------
 select deptno, count(*)
   from emp
  group by deptno
--------------------------------------------------------------------
select deptno, comm
  from emp
--------------------------------------------------------------------
select count(*), count(deptno), count(comm), count('hello')
  from emp
--------------------------------------------------------------------
select deptno, count(*), count(comm), count('hello')
  from emp
 group by deptno
--------------------------------------------------------------------
select count(*)
  from emp
 group by deptno
 
7.5 열의 값 세어보기
select count(comm)
  from emp
  
7.6 누계 생성하기
 select ename, sal,
        sum(sal) over (order by sal,empno) as running_total
   from emp
   order by 2
--------------------------------------------------------------------
select empno, sal,
       sum(sal)over(order by sal,empno) as running_total1,
       sum(sal)over(order by sal) as running_total2
  from emp
 order by 2

7.7 누적곱 생성하기
 select empno,ename,sal,
        exp(sum(ln(sal))over(order by sal,empno)) as running_prod
   from emp
  where deptno = 10

7.8 일련의 값 평활화하기
select date1, sales,lag(sales,1) over(order by date1) as salesLagOne,
lag(sales,2) over(order by date1) as salesLagTwo,
(sales
+ (lag(sales,1) over(order by date1))
+ lag(sales,2) over(order by date1))/3 as MovingAverage
from sales

select date1, sales,lag(sales,1) over(order by date1),
lag(sales,2) over(order by date1),
((3*sales)
+ (2*(lag(sales,1) over(order by date1)))
+ (lag(sales,2) over(order by date1)))/6 as SalesMA
from sales

7.9 최빈값 계산하기
select sal
  from emp
 where deptno = 20
 order by sal
--------------------------------------------------------------------
<DB2, MySQL, PostgreSQL, SQL Server>
  select sal
    from (
  select sal,
         dense_rank()over( order by cnt desc) as rnk
    from (
  select sal, count(*) as cnt
    from emp
   where deptno = 20
  group by sal
        ) x
        ) y
  where rnk = 1

7.10 중앙값 계산하기
select sal
  from emp
 where deptno = 20
 order by sal


<MySQL>
with rank_tab (sal, rank_sal) as
(
select sal, cume_dist() over (order by sal)
            from emp
            where deptno=20
),

inter as
(
        select sal, rank_sal from rank_tab
        where rank_sal>=0.5
union
        select sal, rank_sal from rank_tab
        where rank_sal<=0.5
)

        select avg(sal) as MedianSal
               from inter
               
7.11 총계에서의 백분율 알아내기
<MySQL와 PostgreSQL>
 select (sum(
          case when deptno = 10 then sal end)/sum(sal)
         )*100 as pct
   from emp
   
 <MySQL와 PostgreSQL>
select sum(case when deptno = 10 then sal end) as d10,
       sum(sal)
from emp
--------------------------------------------------------------------
select (cast(
         sum(case when deptno = 10 then sal end)
            as decimal)/sum(sal)
        )*100 as pct
  from emp

7.12 Null 허용 열 집계하기
 select avg(coalesce(comm,0)) as avg_comm
   from emp
  where deptno=30
--------------------------------------------------------------------
select avg(comm)
  from emp
 where deptno=30
--------------------------------------------------------------------
select ename, comm
  from emp
 where deptno=30
order by comm desc

7.13 최댓값과 최솟값을 배제한 평균 계산하기
<MySQL과 PostgreSQL>
 select avg(sal)
   from emp
  where sal not in (
     (select min(sal) from emp),
     (select max(sal) from emp)
  )

<DB2, Oracle, SQL Server>
 select avg(sal)
   from (
 select sal, min(sal)over() min_sal, max(sal)over() max_sal
   from emp
        ) x
  where sal not in (min_sal,max_sal)
--------------------------------------------------------------------
<MySQL과 PostgreSQL>
select (sum(sal)-min(sal)-max(sal))/(count(*)-2)
  from emp
<DB2, Oracle, SQL Server>
select sal, min(sal)over() min_sal, max(sal)over() max_sal
  from emp

7.15. 누계에서 값 변경하기
create view V (id,amt,trx)
as
select 1, 100, 'PR' from t1 union all
select 2, 100, 'PR' from t1 union all
select 3, 50,  'PY' from t1 union all
select 4, 100, 'PR' from t1 union all
select 5, 200, 'PY' from t1 union all
select 6, 50,  'PY' from t1
--------------------------------------------------------------------
  select * from V
--------------------------------------------------------------------
  select case when trx = 'PY'
              then 'PAYMENT'
              else 'PURCHASE'
          end trx_type,
          amt,
          sum(
           case when trx = 'PY'
              then -amt else amt
           end
        ) over (order by id,amt) as balance
 from V
--------------------------------------------------------------------
select case when trx = 'PY'
            then 'PAYMENT'
            else 'PURCHASE'
       end trx_type,
       case when trx = 'PY'
            then -amt else amt
       end as amt
  from V
