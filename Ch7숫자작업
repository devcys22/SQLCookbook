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
