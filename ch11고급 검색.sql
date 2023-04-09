11.1 결과셋을 페이지를 매기기
select sal
  from (
select row_number() over (order by sal) as rn,
       sal
  from emp
       ) x
 where rn between 1 and 5
--------------------------------------------------------------------
select sal
  from (
select row_number() over (order by sal) as rn,
       sal
  from emp
       ) x
 where rn between 6 and 10

select row_number() over (order by sal) as rn,
       sal
  from emp
--------------------------------------------------------------------
select sal
  from (
select sal, rownum rn
  from (
select sal
  from emp
 order by sal
       )
       )
 where rn between 6 and 10

11.2 테이블에서 n개 행 건너뛰기
  select ename
    from (
  select row_number() over (order by ename) rn,
         ename
    from emp
         ) x
   where mod(rn,2) = 1
--------------------------------------------------------------------
select row_number() over (order by ename) rn, ename
  from emp

11.3 외부 조인을 사용할 때 OR 로직 통합하기
select e.ename, d.deptno, d.dname, d.loc
  from dept d, emp e
 where d.deptno = e.deptno
   and (e.deptno = 10 or e.deptno = 20)
 order by 2
