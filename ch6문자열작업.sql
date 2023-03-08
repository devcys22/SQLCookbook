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
