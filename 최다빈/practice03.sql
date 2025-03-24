-- 1. 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회하세요.
select emp_name
from employee
where dept_code = (
			select dept_code
            from employee
            where emp_name = '노옹철'
            )
and emp_name != '노옹철'; 

-- 2. 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회하세요.
select
	  emp_id,
      emp_name,
      job_code,
      salary
  from employee
  where salary > (select avg(salary)
					from employee);
      

-- 3. 노옹철 사원의 급여보다 많이 받는 직원의 사번, 이름, 부서코드, 직급코드, 급여를 조회하세요.

select 
	  EMP_ID,
      EMP_NAME,
      JOB_CODE,
      DEPT_CODE,
      SALARY
  from employee
where salary > ( select salary
				from employee
                where EMP_NAME='노옹철');

-- 4. 가장 적은 급여를 받는 직원의 사번, 이름, 부서코드, 직급코드, 급여, 입사일을 조회하세요.
select
	  EMP_ID,
      EMP_NAME,
      JOB_CODE,
      SALARY,
      HIRE_DATE
  from employee
where salary in (select min(salary)
					from employee
				);
      

-- *** 서브쿼리는 SELECT, FROM, WHERE, HAVING, ORDER BY절에도 사용할 수 있다.

-- 5. 부서별 최고 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여 조회하세요.

select
	  EMP_NAME,
      DEPT_CODE,
      JOB_CODE,
      SALARY
  from employee
 where salary in( select max(salary)
					from employee
                    group by dept_code);



-- *** 여기서부터 난이도 극상

-- 6. 관리자에 해당하는 직원에 대한 정보와 관리자가 아닌 직원의 정보를 추출하여 조회하세요.
-- 사번, 이름, 부서명, 직급, '관리자' AS 구분 / '직원' AS 구분
-- HINT!! is not null, union(혹은 then, else), distinct

-- 관리자
SELECT
	  EMP_ID,
      EMP_NAME,
      DEPT_TITLE,
      JOB_NAME,
      CASE
        WHEN E.EMP_ID in (
          SELECT DISTINCT manager_id
          from employee
          where manager_id IS NOT NULL
          )
          THEN '관리자'
          ELSE '직원'
		END AS 구분
  from employee e
  join department d on e.dept_code = d.dept_id
  join job j on e.job_code = j.job_code
  order by 구분;
 




-- 7. 자기 직급의 평균 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회하세요.
-- 단, 급여와 급여 평균은 만원단위로 계산하세요.
-- HINT!! round(컬럼명, -5)

select
	  e.EMP_ID,
      e.EMP_NAME,
      e.JOB_CODE,
      ROUND(e.salary, -5) AS 급여
  from employee e
  where round(e.salary, -5) = (
			select round(avg(salary), -5) as avg_salary
            from employee
            where job_code = e.job_code
		)
        order by e.emp_id;

-- 8. 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 직원의 이름, 직급코드, 부서코드, 입사일을 조회하세요.
SELECT e1.emp_name, e1.job_code, e1.dept_code, e1.hire_date
FROM employee e1
WHERE (e1.job_code, e1.dept_code) IN (
    -- 퇴사한 직원의 부서와 직급을 찾는 서브쿼리
    SELECT e2.job_code, e2.dept_code
    FROM employee e2
    WHERE e2.ent_yn = 'Y'              -- 퇴사한 직원만
)
AND e1.ent_yn = 'N'                   -- 퇴사하지 않은 직원만
AND e1.emp_id NOT IN (                -- 자기 자신을 제외
    SELECT e3.emp_id
    FROM employee e3
    WHERE e3.ent_yn = 'Y'
);

-- 9. 급여 평균 3위 안에 드는 부서의 부서 코드와 부서명, 평균급여를 조회하세요.
-- HINT!! limit

select
	  e.DEPT_CODE,
      d.DEPT_TITLE,
      AVG(SALARY) as '평균급여'
from employee e
join department d on d.dept_id = e.dept_code
group by e.dept_code, d.dept_title
order by 평균급여 desc limit 3;
-- 10. 부서별 급여 합계가 전체 급여의 총 합의 20%보다 많은 부서의 부서명과, 부서별 급여 합계를 조회하세요.

select
	  d.dept_title,
      sum(e.salary)
  from employee e
  join department d on e.dept_code = d.dept_id
  group by e.dept_code
  having sum(e.salary) > (select sum(salary) * 0.2
  from employee);
