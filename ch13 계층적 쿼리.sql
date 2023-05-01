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

13.3 테이블의 계층 뷰 생성하기

<MySQL>
   with recursive x (ename,empno)
       as (
   select cast(ename as varchar(100)),empno
     from emp
   where mgr is null
    union all
   select cast(concat(x.ename,' - ',e.ename) as varchar(100)),
          e.empno
     from emp e, x
   where e.mgr = x.empno
  )
  select ename as emp_tree
    from x
   order by 1

<Oracle>
  select ltrim(
           sys_connect_by_path(ename,' - '),
         ' - ') emp_tree
   from emp
    start with mgr is null
  connect by prior empno=mgr
    order by 1

<DB2, MySQL, PostgreSQL, SQL Server>
with x (ename,empno)
    as (
select cast(ename as varchar(100)),empno
  from emp
 where mgr is null
 union all
select cast(e.ename as varchar(100)),e.empno
  from emp e, x
 where e.mgr = x.empno
 )
 select ename emp_tree
   from x

<Oracle>
select ename emp_tree
  from emp
 start with mgr is null
connect by prior empno = mgr
--------------------------------------------------------------------
select lpad('.',2*level,'.')||ename emp_tree
   from emp
  start with mgr is null
connect by prior empno = mgr

13.4 지정한 상위 행에 대한 모든 하위 행 찾기
<DB2, PostgreSQL, SQL Server>
   with x (ename,empno)
      as (
  select ename,empno
    from emp
   where ename = 'JONES'
   union all
  select e.ename, e.empno
    from emp e, x
   where x.empno = e.mgr
 )
 select ename
   from x

<Oracle>
 select ename
   from emp
  start with ename = 'JONES'
 connect by prior empno = mgr

13.5 리프, 분기, 루트 노드 행 확인하기
<DB2, PostgreSQL, MySQL, SQL Server>
  select e.ename,
         (select sign(count(*)) from emp d
           where 0 =
             (select count(*) from emp f
               where f.mgr = e.empno)) as is_leaf,
         (select sign(count(*)) from emp d
           where d.mgr = e.empno
            and e.mgr is not null) as is_branch,
         (select sign(count(*)) from emp d
          where d.empno = e.empno
            and d.mgr is null) as is_root
   from emp e
 order by 4 desc,3 desc

<Oracle>
   select ename,
          connect_by_isleaf is_leaf,
          (select count(*) from emp e
            where e.mgr = emp.empno
              and emp.mgr is not null
              and rownum = 1) is_branch,
          decode(ename,connect_by_root(ename),1,0) is_root
     from emp
    start with mgr is null
 connect by prior empno = mgr
 order by 4 desc, 3 desc
