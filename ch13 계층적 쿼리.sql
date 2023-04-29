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

