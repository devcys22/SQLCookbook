10.1 연속 값의 범위 찾기
select *
  from V
--------------------------------------------------------------------
 select proj_id, proj_start, proj_end
   from (
 select proj_id, proj_start, proj_end,
        lead(proj_start)over(order by proj_id) next_proj_start
   from V
        ) alias
 where next_proj_start = proj_end
--------------------------------------------------------------------
<DB2, MySQL, PostgreSQL, SQL Server, Oracle>
select *
  from (
select proj_id, proj_start, proj_end,
       lead(proj_start)over(order by proj_id) next_proj_start
  from v
       )
 where proj_id in ( 1, 4 )
--------------------------------------------------------------------
select *
  from V
 where proj_id <= 5
--------------------------------------------------------------------
select proj_id, proj_start, proj_end
  from (
select proj_id, proj_start, proj_end, 
       lead(proj_start)over(order by proj_id) next_start
  from V
where proj_id <= 5
      )
where proj_end = next_start
--------------------------------------------------------------------
select proj_id, proj_start, proj_end
  from (
select proj_id, proj_start, proj_end, 
       lead(proj_start)over(order by proj_id) next_start,
       lag(proj_end)over(order by proj_id) last_end
  from V
where proj_id <= 5
      )
where proj_end = next_start
   or proj_start = last_end
