1.6 WHERE 절에서 별칭이 지정된 열 참조하기
select sal as salary, comm as commission
  from emp
 where salary < 5000

 select *
   from (
 select sal as salary, comm as commission
   from emp
        ) x
  where salary < 5000

1.7 열 값 이어붙이기

select ename, job
  from emp
 where deptno = 10

<DB2, Oracle, PostgreSQL>
 select ename||' WORKS AS A '||job as msg
   from emp
  where deptno=10

<MySQL>
 select concat(ename, ' WORKS AS A ',job) as msg
   from emp
  where deptno=10

<SQL Server>
 select ename + ' WORKS AS A ' + job as msg
   from emp
  where deptno=10

1.9 반환되는 행 수 제한하기
<DB2>
 select *
   from emp fetch first 5 rows only

<MySQL과 PostgreSQL>
 select *
   from emp limit 5

<Oracle>
 select *
   from emp
  where rownum <= 5

<SQL Server>
 select top 5 *
   from emp

1.12 Null을 실젯값으로 변환하기
 select coalesce(comm,0)
   from emp

select case
       when comm is not null then comm
       else 0
       end
  from emp

1.13 패턴 검색하기
select ename, job
  from emp
 where deptno in (10,20)

 select ename, job
   from emp
  where deptno in (10,20)
    and (ename like '%I%' or job like '%ER')