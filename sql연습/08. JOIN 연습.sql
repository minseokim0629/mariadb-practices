--
-- inner join
--

-- 예제1) 현재 근무하고 있는 직원의 이름과 직책을 모두 출력하세요.
select a.first_name, b.title
  from employees a, titles b
 where a.emp_no = b.emp_no  -- join 조건(n-1)
   and b.to_date = '9999-01-01'; -- row 선택조건
 
select a.first_name, b.title, b.to_date
  from employees a
  join titles b
    on a.emp_no = b.emp_no
 where b.to_date = '9999-01-01';
 
 -- 예제2) 현재 근무하고 있는 직원의 이름과 직책을 모두 출력하되, 여성 엔지니어(Engineer)만 출력하세요.
 select a.first_name, a.gender, b.title
   from employees a, titles b
  where a.emp_No = b.emp_no -- join 조건(n-1)
    and b.to_date = '9999-01-01' -- row 선택조건1
    and a.gender = 'f' -- row 선택조건2
	and b.title = 'Engineer'; -- row 선택조건3
    
--
-- ANSI / ISO SQL1999 JOIN 표준 문법
--

-- 1) natural join
-- 조인 대상이 되는 두 테이블에 이름이 같은 공통 컬럼이 있는 경우 사용할 수 있다.
-- 조인 조건을 명시하지 않고 암묵적으로 조인이 된다.
-- 이름이 같은 컬럼을 자동으로 조인으로 걸어준다. 위험할 수 있다.
select a.first_name, b.title
  from employees a natural join titles b 
 where b.to_date = '9999-01-01';
   
-- 2) join ~ using
-- natural join의 문제점
select count(*)
  from salaries a join titles b using(emp_no)
 where a.to_date = '9999-01-01'
   and b.to_date = '9999-01-01';
   
-- 3) join ~ on
select count(*)
  from salaries a 
  join titles b 
    on a.emp_no = b.emp_no
 where a.to_date = '9999-01-01'
   and b.to_date = '9999-01-01';

-- 실습문제1
-- 현재 직책별 평균연봉을 큰 순서대로 출력하세요.
  select b.title, avg(a.salary) as avg_salary
    from salaries a
    join titles b
      on a.emp_no = b.emp_no
   where a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
group by b.title
order by avg_salary desc;

-- 실습문제2
-- 현재 직책별 평균연봉과 직원수를 구하되 직원수가 100명 이상인 직책만 출력
-- projection : 직책, 평균연봉, 직원수
  select b.title, avg(a.salary) as avg_salary, count(*)
    from salaries a
    join titles b
      on a.emp_no = b.emp_no
   where a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
group by b.title
  having count(*) >= 100
order by count(*) asc;

-- 실습문제3
-- 현재 부서별로 직책이 Engineer인 직원들에 대한 평균연봉을 구하세요.
-- projection : 부서이름 평균연봉
  select d.dept_name, avg(a.salary) as avg_salary
    from salaries a
    join titles b
      on a.emp_no = b.emp_no
    join dept_emp c
      on b.emp_no = c.emp_no
	join departments d
      on c.dept_no = d.dept_no
   where a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
	 and c.to_date = '9999-01-01'
	 and b.title = 'Engineer'
group by d.dept_name
order by avg(a.salary) desc;

select * from dept_manager a join departments b on a.dept_no = b.dept_no join titles c on a.emp_no = c.emp_no where c.to_date = '9999-01-01';
select * from dept_emp;
select * from departments;
