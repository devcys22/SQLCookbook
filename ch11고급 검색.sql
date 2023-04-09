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
