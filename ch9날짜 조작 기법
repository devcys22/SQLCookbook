Chapter 9. 날짜 조작기법

9.1 연도의 윤년 여부 결정하기

<Oracle>
 select to_char(
          last_day(add_months(trunc(sysdate,'y'),1)),
         'DD')
   from t1


<MySQL>
 select day(
        last_day(
        date_add(
        date_add(
        date_add(current_date,
                 interval -dayofyear(current_date) day),
                 interval 1 day),
                 interval 1 month))) dy
   from t1
  
<Oracle>
select trunc(sysdate,'y')
from t1
--------------------------------------------------------------------
select add_months(trunc(sysdate,'y'),1) dy
  from t1
--------------------------------------------------------------------
select last_day(add_months(trunc(sysdate,'y'),1)) dy
  from t1
  
<MySQL>
select date_add(
       date_add(current_date,
                interval -dayofyear(current_date) day),
                interval 1 day) dy
  from t1
--------------------------------------------------------------------
select date_add(
       date_add(
       date_add(current_date,
                interval -dayofyear(current_date) day),
                interval 1 day),
                interval 1 month) dy
  from t1
--------------------------------------------------------------------
select last_day(
       date_add(
       date_add(
       date_add(current_date,
                interval -dayofyear(current_date) day),
                interval 1 day),
                interval 1 month)) dy
  from t1

9.2 연도의 날짜 수 알아내기

<Oracle>
 select add_months(trunc(sysdate,'y'),12) - trunc(sysdate,'y')
   from dual

<MySQL>
 select datediff((curr_year + interval 1 year),curr_year)
   from (
 select adddate(current_date,-dayofyear(current_date)+1) curr_year
   from t1
        ) x
   

