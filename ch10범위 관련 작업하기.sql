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

10.2 같은 그룹 또는 파티션의 행 간 차이 찾기
  with next_sal_tab (deptno,ename,sal,hiredate,next_sal)
  as
  (select deptno, ename, sal, hiredate,
        lead(sal)over(partition by deptno
                          order by hiredate) as next_sal
   from emp )

     select deptno, ename, sal, hiredate
  ,    coalesce(cast(sal-next_sal as char), 'N/A') as diff
    from next_sal_tab
--------------------------------------------------------------------
select deptno,ename,sal,hiredate,
       lead(sal)over(partition by deptno order by hiredate) as next_sal
  from emp
--------------------------------------------------------------------
select deptno,ename,sal,hiredate, sal-next_sal diff
  from (
select deptno,ename,sal,hiredate,
       lead(sal)over(partition by deptno order by hiredate) next_sal
  from emp
       )
select deptno,ename,sal,hiredate,
       nvl(to_char(sal-next_sal),'N/A') diff
  from (
select deptno,ename,sal,hiredate,
       lead(sal)over(partition by deptno order by hiredate) next_sal
  from emp
       )
--------------------------------------------------------------------
select deptno,ename,sal,hiredate,
       lpad(nvl(to_char(sal-next_sal),'N/A'),10) diff
  from (
select deptno,ename,sal,hiredate,
       lead(sal)over(partition by deptno
                         order by hiredate) next_sal
  from emp
 where deptno=10 and empno > 10
       )
--------------------------------------------------------------------
insert into emp (empno,ename,deptno,sal,hiredate)
values (1,'ant',10,1000,to_date('17-NOV-2006'))

insert into emp (empno,ename,deptno,sal,hiredate)
values (2,'joe',10,1500,to_date('17-NOV-2006'))

insert into emp (empno,ename,deptno,sal,hiredate)
values (3,'jim',10,1600,to_date('17-NOV-2006'))

insert into emp (empno,ename,deptno,sal,hiredate)
values (4,'jon',10,1700,to_date('17-NOV-2006'))

select deptno,ename,sal,hiredate,
       lpad(nvl(to_char(sal-next_sal),'N/A'),10) diff
  from (
select deptno,ename,sal,hiredate,
       lead(sal)over(partition by deptno
                         order by hiredate) next_sal
  from emp
 where deptno=10
       )
 --------------------------------------------------------------------
select deptno,ename,sal,hiredate,
       lpad(nvl(to_char(sal-next_sal),'N/A'),10) diff
  from (
select deptno,ename,sal,hiredate,
       lead(sal,cnt-rn+1)over(partition by deptno
                         order by hiredate) next_sal
  from (
select deptno,ename,sal,hiredate,
       count(*)over(partition by deptno,hiredate) cnt,
       row_number()over(partition by deptno,hiredate order by sal) rn
  from emp
 where deptno=10
       )
       )
 select deptno,ename,sal,hiredate,
       count(*)over(partition by deptno,hiredate) cnt,
       row_number()over(partition by deptno,hiredate order by sal) rn
  from emp
 where deptno=10
--------------------------------------------------------------------
select deptno,ename,sal,hiredate,
       lead(sal)over(partition by deptno
                         order by hiredate) incorrect,
       cnt-rn+1 distance,
       lead(sal,cnt-rn+1)over(partition by deptno
                         order by hiredate) correct
  from (
select deptno,ename,sal,hiredate,
       count(*)over(partition by deptno,hiredate) cnt,
       row_number()over(partition by deptno,hiredate
                            order by sal) rn
  from emp
 where deptno=10
       )

10.3 연속 값 범위의 시작과 끝 찾기
select *
  from V
--------------------------------------------------------------------
 select proj_grp, min(proj_start), max(proj_end)
    from (
  select proj_id,proj_start,proj_end,
         sum(flag)over(order by proj_id) proj_grp
    from (
  select proj_id,proj_start,proj_end,
         case when
              lag(proj_end)over(order by proj_id) = proj_start
              then 0 else 1
        end flag
   from V
        ) alias1
        ) alias2
  group by proj_grp

select proj_id,proj_start,proj_end,
      lag(proj_end)over(order by proj_id) prior_proj_end
  from V
--------------------------------------------------------------------
select proj_id,proj_start,proj_end,
       sum(flag)over(order by proj_id) proj_grp
  from (
select proj_id,proj_start,proj_end,
       case when
            lag(proj_end)over(order by proj_id) = proj_start
            then 0 else 1
       end flag
  from V
       )
