show databases;
use employee;
show tables;

-- 1. 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회하세요.
select *
from EMPLOYEE;

select *
from EMPLOYEE
where dept_code = (select dept_code
                   from EMPLOYEE
                   where EMP_NAME = '노옹철');

-- 2. 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회하세요.
select EMP_ID,
       EMP_NAME,
       JOB_CODE,
       SALARY
from EMPLOYEE
where SALARY > (select AVG(SALARY) from EMPLOYEE);

-- 3. 노옹철 사원의 급여보다 많이 받는 직원의 사번, 이름, 부서코드, 직급코드, 급여를 조회하세요.
select EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       JOB_CODE,
       SALARY,
       HIRE_DATE
from EMPLOYEE
where SALARY > (select SALARY from EMPLOYEE where EMP_NAME = '노옹철');


-- 4. 가장 적은 급여를 받는 직원의 사번, 이름, 부서코드, 직급코드, 급여, 입사일을 조회하세요.
-- *** 서브쿼리는 SELECT, FROM, WHERE, HAVING, ORDER BY절에도 사용할 수 있다.

select EMP_ID,
       EMP_NAME,
       DEPT_CODE,
       JOB_CODE,
       SALARY,
       HIRE_DATE
from EMPLOYEE
where EMP_ID = (select EMP_ID from EMPLOYEE order by SALARY limit 1);


-- 5. 부서별 최고 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여 조회하세요.
SELECT E1.EMP_NAME,
       E1.JOB_CODE,
       E1.DEPT_CODE,
       E1.SALARY
FROM EMPLOYEE E1
WHERE E1.SALARY = (SELECT MAX(SALARY)
                   FROM EMPLOYEE E2
                   WHERE E1.DEPT_CODE = E2.DEPT_CODE
                   GROUP BY DEPT_CODE);

-- *** 여기서부터 난이도 극상

-- 6. 관리자에 해당하는 직원에 대한 정보와 관리자가 아닌 직원의 정보를 추출하여 조회하세요.
-- 사번, 이름, 부서명, 직급, '관리자' AS 구분 / '직원' AS 구분
-- HINT!! is not null, union(혹은 then, else), distinct

-- 관리자
SELECT EMP_ID,
       EMP_NAME,
       D.DEPT_TITLE,
       J.JOB_NAME,
       '관리자' as '구분'
FROM EMPLOYEE E
         JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
         JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.MANAGER_ID is null
union
SELECT EMP_ID,
       EMP_NAME,
       D.DEPT_TITLE,
       J.JOB_NAME,
       '직원' as '구분'
FROM EMPLOYEE E
         JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
         JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.MANAGER_ID is not null;

-- 7. 자기 직급의 평균 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회하세요.
-- 단, 급여와 급여 평균은 만원단위로 계산하세요.
-- HINT!! round(컬럼명, -5)
SELECT EMP_ID,
       EMP_NAME,
       E.JOB_CODE,
       SALARY
FROM EMPLOYEE E
         JOIN JOB J ON J.JOB_CODE = E.JOB_CODE
WHERE SALARY >= (SELECT ROUND(AVG(SALARY), -5)
                 FROM EMPLOYEE E2
                 WHERE E2.JOB_CODE = E.JOB_CODE);


-- 8. 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 직원의 이름, 직급코드, 부서코드, 입사일을 조회하세요.
SELECT EMP_NAME,
       JOB_CODE,
       DEPT_CODE,
       HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE,
                                      JOB_CODE
                               FROM EMPLOYEE E
                               WHERE SUBSTR(E.EMP_NO, -7, 1) = 2
                                 AND ENT_YN = 'Y')
  AND ENT_YN != 'Y';

-- 9. 급여 평균 3위 안에 드는 부서의 부서 코드와 부서명, 평균급여를 조회하세요.
-- HINT!! limit
SELECT E.DEPT_CODE,
       D.DEPT_TITLE,
       AVG(E.SALARY)
FROM EMPLOYEE E
         JOIN DEPARTMENT D
              ON D.DEPT_ID = E.DEPT_CODE
         JOIN (SELECT DEPT_CODE
               FROM EMPLOYEE
               GROUP BY DEPT_CODE
               ORDER BY avg(SALARY) desc
               limit 3) AS Q ON E.DEPT_CODE = Q.DEPT_CODE
GROUP BY E.DEPT_CODE;

-- 10. 부서별 급여 합계가 전체 급여의 총 합의 20%보다 많은 부서의 부서명과, 부서별 급여 합계를 조회하세요.
/*SELECT D.DEPT_TITLE,
       SUM(E.SALARY)
FROM EMPLOYEE E
JOIN DEPARTMENT D
ON D.DEPT_ID = E.DEPT_CODE
WHERE SUM(E.SALARY) > SELECT SUM(SALARY) * 1.2 FROM EMPLOYEE // where에서는 sum, avg, min, max 같은 함수를 사용해서 비교할 수 없음
GROUP BY E.DEPT_CODE;*/


SELECT D.DEPT_TITLE,
       SUM(E.SALARY) AS TOTAL_SALARY
FROM EMPLOYEE E
         JOIN DEPARTMENT D ON D.DEPT_ID = E.DEPT_CODE
GROUP BY D.DEPT_TITLE
HAVING SUM(E.SALARY) > (SELECT SUM(SALARY) * 0.2 FROM EMPLOYEE);
