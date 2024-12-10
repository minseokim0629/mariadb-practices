--
-- 문자열 함수
--

-- upper
select upper('seoul'), ucase('SeouL') from dual;
select upper(first_name) from employees;

-- lower 
select lower('SEOUL'), lcase('SeouL') from dual;
select lower(first_name) from employees;

-- substring(문자열, index, length)
select substring('hello world', 3, 2) from dual;

-- 예제: employees 테이블에서 1989년에 입사한 직원의 이름, 입사일을 출력
select first_name,
	   hire_date
  from employees
 where substring(hire_date, 1, 4) = '1989';
 
-- lpad, rpad
-- 빈걸로 넣어놓고 정렬
select lpad('1234', 10, '-'), rpad('1234', 10, '-') from dual;

-- trim, ltrim, rtrim
select concat('---', ltrim('   hello   '), '---'), 
	   concat('---', rtrim('   hello   '), '---'),
       concat('---', trim(leading 'x' from 'xxxxhelloxxxx'), '---'),
       concat('---', trim(trailing 'x' from 'xxxxhelloxxxx'), '---'),
       concat('---', trim(both 'x' from 'xxxxhelloxxxx'), '---')
  from dual;

select length('Hello World') from dual;