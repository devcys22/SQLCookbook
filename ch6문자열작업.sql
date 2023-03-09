Chapter 6. 문자열 작업

6.1 문자열 짚어보기
 select substr(e.ename,iter.pos,1) as C
   from (select ename from emp where ename = 'KING') e,
        (select id as pos from t10) iter
  where iter.pos <= length(e.ename)
--------------------------------------------------------------------
select ename, iter.pos
  from (select ename from emp where ename = 'KING') e,
       (select id as pos from t10) iter
--------------------------------------------------------------------
select ename, iter.pos
  from (select ename from emp where ename = 'KING') e,
       (select id as pos from t10) iter
 where iter.pos <= length(e.ename)
--------------------------------------------------------------------
select substr(e.ename,iter.pos) a,
       substr(e.ename,length(e.ename)-iter.pos+1) b
  from (select ename from emp where ename = 'KING') e,
       (select id pos from t10) iter
 where iter.pos <= length(e.ename)

6.2 문자열에 따옴표 포함하기
 select 'g''day mate' qmarks from t1 union all
 select 'beavers'' teeth'    from t1 union all
 select ''''                 from t1
--------------------------------------------------------------------
select 'apples core', 'apple''s core',
        case when '' is null then 0 else 1 end
  from t1

select '''' as quote from t1;

6.3. 문자열에서 특정 문자의 발생 횟수 계산하기

 select (length('10,CLARK,MANAGER')-
        length(replace('10,CLARK,MANAGER',',','')))/length(',')
        as cnt
   from t1
--------------------------------------------------------------------
select
       (length('HELLO HELLO')-
       length(replace('HELLO HELLO','LL','')))/length('LL')
       as correct_cnt,
       (length('HELLO HELLO')-
       length(replace('HELLO HELLO','LL',''))) as incorrect_cnt
  from t1

6.4. 문자열에서 원하지 않는 문자 제거하기
<DB2, Oracle, PostgreSQL, SQL Server>
 select ename,
        replace(translate(ename,'aaaaa','AEIOU'),'a','') as stripped1,
        sal,
        replace(cast(sal as char(4)),'0','') as stripped2
   from emp

<MySQL>
 select ename,
        replace(
        replace(
        replace(
        replace(
        replace(ename,'A',''),'E',''),'I',''),'O',''),'U','')
        as stripped1,
        sal,
        replace(sal,0,'') stripped2
   from emp
6.6 문자열의 영숫자 여부 확인하기
drop view V;
create view V as
select ename as data
  from emp
 where deptno=10
 union all
select ename||', $'|| cast(sal as char(4)) ||'.00' as data
  from emp
 where deptno=20
 union all
select ename|| cast(deptno as char(4)) as data
  from emp
 where deptno=30

--------------------------------------------------------------------
<DB2>
 select data
   from V
  where translate(lower(data),
                  repeat('a',36),
                  '0123456789abcdefghijklmnopqrstuvwxyz') =
                  repeat('a',length(data))

<MySQL>
create view V as
select ename as data
  from emp
 where deptno=10
 union all
select concat(ename,', $',sal,'.00') as data
  from emp
 where deptno=20
 union all
select concat(ename,deptno) as data
  from emp
 where deptno=30
--------------------------------------------------------------------
 select data
   from V
  where data regexp '[^0-9a-zA-Z]' = 0

<Oracle과 PostgreSQL>
 select data
   from V
  where translate(lower(data),
                  '0123456789abcdefghijklmnopqrstuvwxyz',
                  rpad('a',36,'a')) = rpad('a',length(data),'a')

<SQL Server>
 select data
   from V
  where translate(lower(data),
                  '0123456789abcdefghijklmnopqrstuvwxyz',
                  replicate('a',36)) = replicate('a',len(data))
--------------------------------------------------------------------
<DB2, Oracle, PostgreSQL, SQL Server>
select data, translate(lower(data),
                  '0123456789abcdefghijklmnopqrstuvwxyz',
                   rpad('a',36,'a'))
  from V
--------------------------------------------------------------------
select data, translate(lower(data),
                  '0123456789abcdefghijklmnopqrstuvwxyz',
                   rpad('a',36,'a')) translated,
        rpad('a',length(data),'a') fixed
  from V

6.7. 이름에서 이니셜 추출하기
<DB2>
 select replace(
        replace(
        translate(replace('Stewie Griffin', '.', ''),
                  repeat('#',26),
                  'abcdefghijklmnopqrstuvwxyz'),
                   '#','' ), ' ','.' )
                  ||'.'
   from t1

<MySQL>
 select case
           when cnt = 2 then
             trim(trailing '.' from
                  concat_ws('.',
                   substr(substring_index(name,' ',1),1,1),
                   substr(name,
                          length(substring_index(name,' ',1))+2,1),
                   substr(substring_index(name,' ',-1),1,1),
                   '.'))
          else
            trim(trailing '.' from
                 concat_ws('.',
                  substr(substring_index(name,' ',1),1,1),
                  substr(substring_index(name,' ',-1),1,1)
                  ))
          end as initials
   from (
 select name,length(name)-length(replace(name,' ','')) as cnt
   from (
 select replace('Stewie Griffin','.','') as name from t1
        )y
        )x
        
select concat_ws('.',
                  substr(substring_index(name,' ',1),1,1),
                  substr(substring_index(name,' ',-1),1,1),
                 '.' ) a
from  (select  'Stewie Griffin' as name from t1) x;

<Oracle과 PostgreSQL>
 select replace(
        replace(
        translate(replace('Stewie Griffin', '.', ''),
                  'abcdefghijklmnopqrstuvwxyz',
                  rpad('#',26,'#') ), '#','' ),' ','.' ) ||'.'
   from t1




<SQL Server>
 select replace(
        replace(
        translate(replace('Stewie Griffin', '.', ''),
                  'abcdefghijklmnopqrstuvwxyz',
                  replicate('#',26) ), '#','' ),' ','.' ) + '.'
   from t1
--------------------------------------------------------------------
<DB2>
select translate(replace('Stewie Griffin', '.', ''),
                 repeat('#',26),
                 'abcdefghijklmnopqrstuvwxyz')
  from t1
--------------------------------------------------------------------
select replace(
       translate(replace('Stewie Griffin', '.', ''),
                  repeat('#',26),
                  'abcdefghijklmnopqrstuvwxyz'),'#','')
  from t1
--------------------------------------------------------------------
select replace(
       replace(
       translate(replace('Stewie Griffin', '.', ''),
                 repeat('#',26),
                'abcdefghijklmnopqrstuvwxyz'),'#',''),' ','.') || '.'
  from t1

<Oracle과 PostgreSQL>
select translate(replace('Stewie Griffin','.',''),
                 'abcdefghijklmnopqrstuvwxyz',
                 rpad('#',26,'#'))
  from t1
--------------------------------------------------------------------
select replace(
       translate(replace('Stewie Griffin','.',''),
                 'abcdefghijklmnopqrstuvwxyz',
                  rpad('#',26,'#')),'#','')
  from t1
--------------------------------------------------------------------
select replace(
       replace(
     translate(replace('Stewie Griffin','.',''),
               'abcdefghijklmnopqrstuvwxyz',
               rpad('#',26,'#') ),'#',''),' ','.') || '.'
  from t1


MySQL
select substr(substring_index(name, ' ',1),1,1) as a,
       substr(substring_index(name,' ',-1),1,1) as b
  from (select 'Stewie Griffin' as name from t1) x
--------------------------------------------------------------------
select concat_ws('.',
                 substr(substring_index(name, ' ',1),1,1),
                 substr(substring_index(name,' ',-1),1,1),
                 '.' ) a
  from (select 'Stewie Griffin' as name from t1) x

6.8 문자열 일부를 정렬하기
<DB2, Oracle, MySQL, PostgreSQL>
 select ename
   from emp
  order by substr(ename,length(ename)-1,2);

<SQL Server>
 select ename
   from emp
  order by substring(ename,len(ename)-1,2)

6.9 문자열의 숫자로 정렬하기
create view V as
select e.ename ||' '||
        cast(e.empno as char(4))||' '||
        d.dname as data
  from emp e, dept d
 where e.deptno=d.deptno
--------------------------------------------------------------------
<DB2>
 select data
   from V
  order by
         cast(
      replace(
    translate(data,repeat('#',length(data)),
      replace(
    translate(data,'##########','0123456789'),
             '#','')),'#','') as integer)

<Oracle>
 select data
   from V
  order by
         to_number(
           replace(
         translate(data,
           replace(
         translate(data,'0123456789','##########'),
                  '#'),rpad('#',20,'#')),'#'))

<PostgreSQL>
 select data
   from V
  order by
         cast(
      replace(
    translate(data,
      replace(
    translate(data,'0123456789','##########'),
             '#',''),rpad('#',20,'#')),'#','') as integer);

--------------------------------------------------------------------
select data,
       translate(data,'0123456789','##########') as tmp
  from V;
--------------------------------------------------------------------
select data,
replace(
translate(data,'0123456789','##########'),'#') as tmp
  from V
--------------------------------------------------------------------
select data, translate(data,
             replace(
             translate(data,'0123456789','##########'),
             '#'),
             rpad('#',length(data),'#')) as tmp
  from V
--------------------------------------------------------------------
select data, replace(
             translate(data,
             replace(
           translate(data,'0123456789','##########'),
                     '#'),
                     rpad('#',length(data),'#')),'#') as tmp
  from V
--------------------------------------------------------------------
select data, to_number(
              replace(
             translate(data,
             replace(
       translate(data,'0123456789','##########'),
                 '#'),
                 rpad('#',length(data),'#')),'#')) as tmp
  from V
--------------------------------------------------------------------
select data
  from V
 order by
        to_number(
          replace(
        translate( data,
          replace(
        translate( data,'0123456789','##########'),
                  '#'),rpad('#',length(data),'#')),'#'))

