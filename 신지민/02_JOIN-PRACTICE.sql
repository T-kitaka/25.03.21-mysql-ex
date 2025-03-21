-- JOIN을 이용하여 여러 테이블을 조회 시에는 모든 컬럼에 테이블 별칭을 사용하는 것이 좋다.

-- 1. 직급이 대리이면서 아시아 지역에 근무하는 직원의 사번, 이름, 직급명, 부서명, 지역명, 급여를 조회하세요
select e.emp_id, e.emp_name, j.job_name, d.dept_title, l.local_name, e.salary
from employee e
join department d on e.dept_code = d.dept_id
join job j on e.job_code = j.job_code
join location l on d.location_id = l.local_code
where j.job_name = '대리' and l.local_name in ('ASIA1', 'ASIA2', 'ASIA3');

-- 2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원의 이름, 주민등록번호, 부서명, 직급명을 조회하세요.
select e.emp_name, d.dept_title, j.job_name
from employee e
join department d on e.dept_code = d.dept_id
join job j on e.job_code = j.job_code
where e.emp_no like '7______2%' and e.emp_name like '전%';

-- 3. 이름에 '형'자가 들어가는 직원의 사번, 이름, 직급명을 조회하세요.
select e.emp_id, e.emp_name, j.job_name
from employee e
join job j on e.job_code = j.job_code
where e.emp_name like '%형%';


-- 4. 해외영업팀에 근무하는 직원의 이름, 직급명, 부서코드, 부서명을 조회하세요.
select e.emp_name, j.job_name, e.dept_code, d.dept_title 
from employee e
join department d on e.dept_code = d.dept_id
join job j on e.job_code = j.job_code
where d.dept_title like '해외영업_부';

-- 5. 보너스포인트를 받는 직원의 이름, 보너스, 부서명, 지역명을 조회하세요.
select e.emp_name, e.bonus, d.dept_title, l.local_name
from employee e
left join department d on e.dept_code = d.dept_id
left join location l on d.location_id = l.local_code
where e.bonus is not null;


-- 6. 부서코드가 D2인 직원의 이름, 직급명, 부서명, 지역명을 조회하세오.
select e.emp_name, j.job_name, d.dept_title, l.local_name
from employee e
join department d on e.dept_code = d.dept_id
join job j on e.job_code = j.job_code
join location l on d.location_id = l.local_code
where e.dept_code = 'D2';

-- 7. 한국(KO)과 일본(JP)에 근무하는 직원의 이름, 부서명, 지역명, 국가명을 조회하세요.
select e.emp_name, d.dept_title, l.local_name, n.national_name
from employee e
join department d on e.dept_code = d.dept_id
join location l on d.location_id = l.local_code
join nation n on l.national_code = n.national_code
where n.national_name = '한국' or n.national_name = '일본';