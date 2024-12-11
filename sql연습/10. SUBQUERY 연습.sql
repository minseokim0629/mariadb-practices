--
-- Subquery
--

-- 1) select 절의 서브쿼리
select (select 1+1 from dual) from dual;
-- insert into t1 values (null, (select max(no) + 1 from t1));

-- 2) from 절의 서브쿼리
select now() as n, sysdate() as s, 3 + 1 as r from dual;
select a.n, a.r
  from (select now() as n, sysdate() as s, 3 + 1 as r from dual) a;
  
-- 3) where 절의 서브쿼리
-- 예제) 현재 Fai Bale이 근무하는 부서에서 근무하는 직원의 사번, 이름을 출력해보세요.

-- join으로 풀기
select *
  from employees a
  join dept_emp b
    on a.emp_no = b.emp_no
 where b.to_date = '9999-01-01'
   and concat(a.first_name, ' ', a.last_name) = 'Fai Bale';
-- d004
select a.emp_no, a.first_name
  from employees a
  join dept_emp b
    on a.emp_no = b.emp_no
 where b.to_date = '9999-01-01'
   and b.dept_no = 'd004';
   
-- subquery로 풀기
SELECT a.emp_no, a.first_name
  FROM employees a
  JOIN dept_emp b 
	ON a.emp_no = b.emp_no
 WHERE b.to_date = '9999-01-01'
   AND b.dept_no = (SELECT *
					  FROM employees a
                      JOIN dept_emp b 
                        ON a.emp_no = b.emp_no
					 WHERE b.to_date = '9999-01-01'
					   AND CONCAT(a.first_name, ' ', a.last_name) = 'Fai Bale');

-- 3-1) 단일행 연산자: =, >, <, >=, <=, <>, !=
-- 실습문제1
-- 현재 전체 사원의 평균 연봉보다 적은 급여를 받는 사원의 이름과 급여를 출력하세요.
select a.first_name, b.salary
  from employees a
  join salaries b
    on a.emp_no = b.emp_no
 where b.to_date = '9999-01-01' -- 72012.2359
   and b.salary < (select avg(salary)
					 from salaries
					where to_date = '9999-01-01')
order by b.salary desc;

-- 현재 직책별 평균 급여 중에 가장 적은 평균급여 직책이름과 그 평균급여를 출력하세요.
-- 1) 직책별 평균 급여
-- 2) 직책별 가장 적은 평균 급여
-- 3) sol1 : where절 subquery(=)
  select a.title, avg(b.salary)
    from titles a
    join salaries b
      on a.emp_no = b.emp_no
   where a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
group by a.title
  having avg(b.salary) = (select min(c.avg_salary)
							from (  select a.title, avg(b.salary) as avg_salary
									  from titles a
									  join salaries b
										on a.emp_no = b.emp_no
									 where a.to_date = '9999-01-01'
									   and b.to_date = '9999-01-01'
								  group by a.title
								 ) c
						);
-- 4) sol2: top-k
select a.title, avg(b.salary)
    from titles a
    join salaries b
      on a.emp_no = b.emp_no
   where a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
group by a.title
order by avg(b.salary) asc
   limit 1; -- 0, 1

-- 내가 푼거
select c.title, min(c.avg_salary) as avg_salary
  from (  select a.title, avg(b.salary) as avg_salary
		    from titles a
		    join salaries b
		      on a.emp_no = b.emp_no
		   where a.to_date = '9999-01-01'
             and b.to_date = '9999-01-01'
        group by a.title
	   ) c;
       
-- 3-2) 복수행 연산자: in, not in, 비교연산자any, 비교연산자All
-- 1. =any: in
-- 2. >any, >=any: 최소값
-- 3. <any, <=any: 최대값
-- 4. <>any, !=any: not in

-- all 사용법
-- 1. =all: (x)
-- 2. >all, >=all: 최대값
-- 3. <all, <=all : 최소값
-- 4. <>all, !=all

-- 실습문제3
-- 현재 급여가 50000 이상인 직원의 이름과 급여를 출력하세요.
-- 둘리 60000
-- 마이콜 55000

-- sol01
  select a.first_name, b.salary
    from employees a
    join salaries b
      on a.emp_no = b.emp_no
   where b.to_date = '9999-01-01'
     and b.salary >= 50000
order by b.salary asc;
 
   
-- sol02
  select a.first_name, b.salary
    from employees a
    join salaries b
      on a.emp_no = b.emp_no
   where b.to_date = '9999-01-01'
     and (a.emp_no, b.salary) in (select emp_no, salary
								    from salaries
								   where to_date = '9999-01-01'
                                     and salary >= 50000)
order by b.salary asc;

-- 실습문제4:
-- 현재 각 부서별 최고급여를 받고 있는 직원의 이름, 부서이름, 급여를 출력해 보세요.
-- 총무 둘리 20000
-- 개발 마이콜 50000
-- sol01 : where in
select d.dept_name, b.first_name, a.salary
  from salaries a
  join employees b
	on a.emp_no = b.emp_no
  join dept_emp c
	on b.emp_no = c.emp_no
  join departments d
    on c.dept_no = d.dept_no
 where a.to_date = '9999-01-01'
   and c.to_date = '9999-01-01'
   and (c.dept_no, a.salary) in ( select b.dept_no, max(a.salary) as max_salary
								    from salaries a
								    join dept_emp b
									  on a.emp_no = b.emp_no
								   where a.to_date = '9999-01-01'
								     and b.to_date = '9999-01-01'
								group by b.dept_no
                                )
order by a.salary desc;

-- sol02: from절 subquery & join
select d.dept_name, b.first_name, a.salary
  from salaries a
  join employees b
	on a.emp_no = b.emp_no
  join dept_emp c
	on b.emp_no = c.emp_no
  join departments d
    on c.dept_no = d.dept_no
  join (
		   select b.dept_no, max(a.salary) as max_salary
		     from salaries a
		     join dept_emp b
		       on a.emp_no = b.emp_no
		    where a.to_date = '9999-01-01'
	         and b.to_date = '9999-01-01'
		group by b.dept_no
	   ) e
	on c.dept_no = e.dept_no
 where a.to_date = '9999-01-01'
   and c.to_date = '9999-01-01'
   and a.salary = e.max_salary;