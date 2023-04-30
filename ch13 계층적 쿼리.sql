select empno,mgr
  from emp
order by 2

13.1 상위-하위 관계 표현하기
<DB2, Oracle, PostgreSQL>
 select a.ename || ' works for ' || b.ename as emps_and_mgrs
   from emp a, emp b
  where a.mgr = b.empno

< MySQL>
 select concat(a.ename, ' works for ',b.ename) as emps_and_mgrs
   from emp a, emp b
  where a.mgr = b.empno

13.2. 자식-부모-조부모 관계 표현하기
select ename,empno,mgr
  from emp
 where ename in ('KING','CLARK','MILLER')
--------------------------------------------------------------------
<DB2, SQL Server>
    with  x (tree,mgr,depth)
      as  (
  select  cast(ename as varchar(100)),
          mgr, 0
    from  emp
   where  ename = 'MILLER'
   union  all
  select  cast(x.tree+'-->'+e.ename as varchar(100)),
          e.mgr, x.depth+1
   from  emp e, x
  where x.mgr = e.empno
 )
 select tree leaf___branch___root
   from x
  where depth = 2
<PostgreSQL, MySQL>
    with recursive x (tree,mgr,depth)
      as  (
  select  cast(ename as varchar(100)),
          mgr, 0
    from  emp
   where  ename = 'MILLER'
   union  all
  select  cast(concat(x.tree,'-->',emp.ename) as char(100)),
          e.mgr, x.depth+1
   from  emp e, x
  where x.mgr = e.empno
 )
 select tree leaf___branch___root
   from x
  where depth = 2

<Oracle>
  select ltrim(
           sys_connect_by_path(ename,'-->'),
         '-->') leaf___branch___root
    from emp
   where level = 3
   start with ename = 'MILLER'
 connect by prior mgr = empno


<DB2, SQL Server, PostgreSQL, MySQL>
with x (tree,mgr,depth)
    as (
select cast(ename as varchar(100)),
       mgr, 0
  from emp
 where ename = 'MILLER'
 union all
select cast(x.tree+'-->'+e.ename as varchar(100)),
       e.mgr, x.depth+1
  from emp e, x
 where x.mgr = e.empno
)
select tree leaf___branch___root
  from x
--------------------------------------------------------------------
  with x (tree,mgr,depth)
    as (
select  cast(ename as varchar(100)),
        mgr, 0
  from emp
 where ename = 'MILLER'
 union all
select cast(x.tree+'-->'+e.ename as varchar(100)),
       e.mgr, x.depth+1
  from emp e, x
 where x.mgr = e.empno
)
select depth, tree
  from x

<Oracle>
select ename
   from emp
  start with ename = 'MILLER'
connect by prior mgr = empno

 select sys_connect_by_path(ename,'-->') tree
   from emp
  start with ename = 'MILLER'
connect by prior mgr = empno
