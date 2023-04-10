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
 --------------------------------------------------------------------
select e.ename, d.deptno, d.dname, d.loc
  from dept d left join emp e
    on (d.deptno = e.deptno)
 where e.deptno = 10
    or e.deptno = 20
 order by 2
--------------------------------------------------------------------
  select e.ename, d.deptno, d.dname, d.loc
    from dept d left join emp e
      on (d.deptno = e.deptno
         and (e.deptno=10 or e.deptno=20))
   order by 2
--------------------------------------------------------------------
  select e.ename, d.deptno, d.dname, d.loc
    from dept d
    left join
         (select ename, deptno
            from emp
           where deptno in ( 10, 20 )
         ) e on ( e.deptno = d.deptno )
  order by 2

11.4 역수 행 확인하기
select *
  from V
--------------------------------------------------------------------
select distinct v1.*
  from V v1, V v2
 where v1.test1 = v2.test2
   and v1.test2 = v2.test1
   and v1.test1 <= v1.test2
--------------------------------------------------------------------
select v1.*
  from V v1, V v2
 where v1.test1 = v2.test2
   and v1.test2 = v2.test1

11.5 상위 n개 레코드 선택하기
  select ename,sal
   from (
  select ename, sal,
         dense_rank() over (order by sal desc) dr
    from emp
         ) x
   where dr <= 5
--------------------------------------------------------------------
select ename, sal,
       dense_rank() over (order by sal desc) dr
  from emp
  
