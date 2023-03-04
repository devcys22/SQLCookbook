2.3 부분 문자열로 정렬하기
<DB2, MySQL, Oracle, PostgreSQL>
select ename, job
  from emp
 order by substr(job,length(job)-1)

2.5 정렬할 때 Null 처리하기
<DB2, MySQL, PostgreSQL, SQL Server>
/* NULL이 아닌 COMM을 우선 오름차순 정렬하고, 모든 NULL은 마지막에 나타냄 */
  select ename,sal,comm
    from (
  select ename,sal,comm,
         case when comm is null then 0 else 1 end as is_null
    from emp
         ) x
    order by is_null desc,comm
--------------------------------------------------------------------
/* NULL이 아닌 COMM을 우선 내림차순 정렬하고, 모든 NULL은 마지막에 나타냄 */
  select ename,sal,comm
    from (
  select ename,sal,comm,
         case when comm is null then 0 else 1 end as is_null
    from emp
         ) x
   order by is_null desc,comm desc

/* NULL을 처음에 나타낸 후, NULL이 아닌 COMM은 오름차순 정렬 */

 select ename,sal,comm
   from (
 select ename,sal,comm,
        case when comm is null then 0 else 1 end as is_null
   from emp
        ) x
  order by is_null,comm
--------------------------------------------------------------------
/* NULL을 처음에 나타낸 후, NULL이 아닌 COMM은 내림차순 정렬 */
  select ename,sal,comm
    from (
  select ename,sal,comm,
         case when comm is null then 0 else 1 end as is_null
    from emp
         ) x
   order by is_null,comm desc

2.6 데이터 종속 키 기준으로 정렬하기

 select ename,sal,job,comm
   from emp
  order by case when job = 'SALESMAN' then comm else sal end

select ename,sal,job,comm,
       case when job = 'SALESMAN' then comm else sal end as ordered
  from emp
 order by 5

