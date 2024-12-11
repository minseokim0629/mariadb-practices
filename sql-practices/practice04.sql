-- 서브쿼리(SUBQUERY) SQL 문제입니다.

-- 단 조회결과는 급여의 내림차순으로 정렬되어 나타나야 합니다. 

-- 문제1.
-- 현재 전체 사원의 평균 급여보다 많은 급여를 받는 사원은 몇 명이나 있습니까?
select count(*)
  from employees a
  join salaries b
    on a.emp_no = b.emp_no
 where b.to_date = '9999-01-01'
   and b.salary > ( select avg(salary) as avg_salary
					  from salaries
					 where to_date = '9999-01-01');
                                          
-- 문제2. (풀었던 문제)
-- 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서 급여을 조회하세요. 단 조회결과는 급여의 내림차순으로 정렬합니다.
select a.emp_no, concat(a.first_name, ' ', a.last_name) as name, d.dept_name, b.salary
  from employees a
  join salaries b
    on a.emp_no = b.emp_no
  join dept_emp c
    on a.emp_no = c.emp_no
  join departments d
    on c.dept_no = d.dept_no
  where b.to_date = '9999-01-01'
    and c.to_date = '9999-01-01'
    and (c.dept_no, b.salary) in (  select b.dept_no, max(c.salary) as max_salary
								      from employees a
                                      join dept_emp b
                                        on a.emp_no = b.emp_no
								      join salaries c
                                        on a.emp_no = c.emp_no
								     where b.to_date = '9999-01-01'
                                       and c.to_date = '9999-01-01'
								  group by b.dept_no )
order by b.salary desc;

-- 문제3.
-- 현재, 사원 자신들의 부서의 평균급여보다 급여가 많은 사원들의 사번, 이름 그리고 급여를 조회하세요 
 select count(*), a.emp_no, concat(a.first_name, ' ', a.last_name) as name, b.salary
   from employees a
   join salaries b
     on a.emp_no = b.emp_no
   join dept_emp c
     on a.emp_no = c.emp_no
   join departments d
     on c.dept_no = d.dept_no
  where b.to_date = '9999-01-01'
    and c.to_date = '9999-01-01'
    and b.salary > (  select avg(b.salary)
						from employees a
						join salaries b
                          on a.emp_no = b.emp_no
						join dept_emp c2
						  on a.emp_no = c2.emp_no
					   where b.to_date = '9999-01-01'
						 and c2.to_date = '9999-01-01'
						 and c2.dept_no = c.dept_no
					group by c2.dept_no
				   )
order by b.salary desc;

-- 문제4. (employee를 두번?..)
-- 현재, 사원들의 사번, 이름, 그리고 매니저 이름과 부서 이름을 출력해 보세요.
select a.emp_no, concat(a.first_name, ' ', a.last_name) as emp_name, d.name, c.dept_name
  from employees a
  join dept_emp b
    on a.emp_no = b.emp_no
  join departments c
    on b.dept_no = c.dept_no
  join ( select b.dept_no, concat(a.first_name, ' ', a.last_name) as name 
		   from employees a
		   join dept_manager b
             on a.emp_no = b.emp_no
		  where b.to_date = '9999-01-01'
		) d
	on b.dept_no = d.dept_no
 where b.to_date = '9999-01-01';
 
-- 문제5.
-- 현재, 평균급여가 가장 높은 부서의 사원들의 사번, 이름, 직책 그리고 급여를 조회하고 급여 순으로 출력하세요.
select a.emp_no, concat(a.first_name, ' ', a.last_name) as name, b.title, c.salary, d.dept_no
  from employees a
  join titles b
    on a.emp_no = b.emp_no
  join salaries c
    on a.emp_no = c.emp_no
  join dept_emp d
    on a.emp_no = d.emp_no
 where b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01'
   and d.to_date = '9999-01-01'
   and d.dept_no = ( select e.dept_no
					   from (  select a.dept_no, avg(salary) as avg_salary
						         from dept_emp a
						         join salaries b
                                   on a.emp_no = b.emp_no
						        where a.to_date = '9999-01-01'
					         group by a.dept_no
						     ) e
					order by avg_salary desc
                       limit 1
				   )
order by c.salary desc;

-- 문제6.
-- 현재, 평균 급여가 가장 높은 부서의 이름 그리고 평균급여를 출력하세요.
select d.dept_name, avg(b.salary) as avg_salary
  from employees a
  join salaries b
    on a.emp_no = b.emp_no
  join dept_emp c
	on a.emp_no = c.emp_no
  join departments d
    on c.dept_no = d.dept_no
 where b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01'
group by c.dept_no
  having avg_salary = ( select max(e.avg_salary)
							 from (   select b.dept_no, avg(c.salary) as avg_salary
									    from employees a
									    join dept_emp b
                                          on a.emp_no = b.emp_no
									    join salaries c
									      on a.emp_no = c.emp_no
									   where b.to_date = '9999-01-01'
                                         and c.to_date = '9999-01-01'
								    group by b.dept_no
								  ) e
						  );
-- 문제7.
-- 현재, 평균 급여가 가장 높은 직책의 타이틀 그리고 평균급여를 출력하세요.
  select c.title, avg(b.salary)
    from employees a
    join salaries b
      on a.emp_no = b.emp_no
    join titles c
      on a.emp_no = c.emp_no
   where b.to_date = '9999-01-01'
     and c.to_date = '9999-01-01'
group by c.title
  having avg(b.salary) = ( select max(d.avg_salary)
							 from (   select c.title, avg(b.salary) as avg_salary
										from employees a
									    join salaries b
                                          on a.emp_no = b.emp_no
									    join titles c
                                          on b.emp_no = c.emp_no
									   where b.to_date = '9999-01-01'
                                         and c.to_date = '9999-01-01'
									group by c.title
								  ) d
					      );