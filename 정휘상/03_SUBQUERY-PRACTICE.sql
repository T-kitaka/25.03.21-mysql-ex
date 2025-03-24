-- 1. 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회하세요.
select emp_name
from employee
where dept_code = (select dept_code
                   from employee
                   where EMP_NAME = '노옹철');

-- 2. 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회하세요.
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM employee
WHERE SALARY > (SELECT AVG(SALARY)
                FROM employee);
-- 3. 노옹철 사원의 급여보다 많이 받는 직원의 사번, 이름, 부서코드, 직급코드, 급여를 조회하세요.
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM employee
WHERE SALARY > (SELECT SALARY
                FROM employee
                WHERE EMP_NAME = '노옹철');
-- 4. 가장 적은 급여를 받는 직원의 사번, 이름, 부서코드, 직급코드, 급여, 입사일을 조회하세요.
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY, HIRE_DATE
FROM employee
ORDER BY SALARY
LIMIT 1;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY, HIRE_DATE
FROM employee
WHERE SALARY = (SELECT MIN(SALARY) FROM employee);

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY, HIRE_DATE
FROM employee
WHERE EMP_ID = (SELECT EMP_ID
                FROM employee
                ORDER BY SALARY
                LIMIT 1);
-- *** 서브쿼리는 SELECT, FROM, WHERE, HAVING, ORDER BY절에도 사용할 수 있다.

-- 5. 부서별 최고 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여 조회하세요.
SELECT EMP_NAME, JOB_CODE, e.DEPT_CODE, SALARY
FROM employee e
         JOIN (SELECT MAX(SALARY) AS MAX_SALARY, DEPT_CODE
               FROM employee
               GROUP BY DEPT_CODE) yee
              ON SALARY = MAX_SALARY AND IFNULL(e.DEPT_CODE, 'NO_DEPT_CODE') = IFNULL(yee.DEPT_CODE, 'NO_DEPT_CODE');
-- *** 여기서부터 난이도 극상

-- 6. 관리자에 해당하는 직원에 대한 정보와 관리자가 아닌 직원의 정보를 추출하여 조회하세요.
-- 사번, 이름, 부서명, 직급, '관리자' AS 구분 / '직원' AS 구분
-- HINT!! is not null, union(혹은 then, else), distinct
SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_TITLE 부서명, JOB_NAME 직급, 구분
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, J.JOB_NAME, '관리자' AS 구분
      FROM employee E
               JOIN JOB J
                    ON E.JOB_CODE = J.JOB_CODE
               LEFT JOIN department D
                         ON D.DEPT_ID = E.DEPT_CODE
      WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID FROM employee)
      UNION ALL
      SELECT EMP_ID, EMP_NAME, DEPT_TITLE, J.JOB_NAME, '직원' AS 구분
      FROM employee E
               JOIN JOB J
                    ON E.JOB_CODE = J.JOB_CODE
               LEFT JOIN department D
                         ON D.DEPT_ID = E.DEPT_CODE
      WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID FROM employee WHERE NOT ISNULL(MANAGER_ID))) A
ORDER BY 구분, 사번;

-- 7. 자기 직급의 평균 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회하세요.
-- 단, 급여와 급여 평균은 만원단위로 계산하세요.
-- HINT!! round(컬럼명, -5)

-- GG
SELECT ROUND(AVG(SALARY), -5) AS AVG_SALARY, JOB_CODE
FROM employee
WHERE ENT_YN = 'n'
GROUP BY JOB_CODE;

SELECT EMP_ID, EMP_NAME, E.JOB_CODE, AVG_SALARY AS SALARY
FROM employee E
         JOIN (SELECT ROUND(AVG(SALARY), -5) AS AVG_SALARY, JOB_CODE FROM employee GROUP BY JOB_CODE) S
              ON E.JOB_CODE = S.JOB_CODE
WHERE ROUND(SALARY, -5) = AVG_SALARY;
-- 8. 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 직원의 이름, 직급코드, 부서코드, 입사일을 조회하세요.
SELECT EMP_NAME, E.JOB_CODE, E.DEPT_CODE, HIRE_DATE
FROM employee E
         JOIN (SELECT EMP_ID, DEPT_CODE, JOB_CODE
               FROM employee
               WHERE ENT_YN = 'y'
                 AND EMP_NO LIKE '______-2%') YEE
              ON E.DEPT_CODE = YEE.DEPT_CODE AND
                 E.JOB_CODE = YEE.JOB_CODE AND
                 E.EMP_ID <> YEE.EMP_ID;

-- 9. 급여 평균 3위 안에 드는 부서의 부서 코드와 부서명, 평균급여를 조회하세요.
-- HINT!! limit
SELECT DEPT_CODE, D.DEPT_TITLE, AVG(SALARY) AS `평균급여`
FROM employee E
         JOIN department D
              ON D.DEPT_ID = E.DEPT_CODE
GROUP BY DEPT_CODE
ORDER BY AVG(SALARY) DESC
LIMIT 3;

-- 10. 부서별 급여 합계가 전체 급여의 총 합의 20%보다 많은 부서의 부서명과, 부서별 급여 합계를 조회하세요.
SELECT DEPT_TITLE, SUM_SALARY
FROM department D
         JOIN (SELECT SUM(SALARY) AS SUM_SALARY, DEPT_CODE FROM employee GROUP BY DEPT_CODE) E
              ON D.DEPT_ID = E.DEPT_CODE AND E.SUM_SALARY > (SELECT SUM(SALARY) * 0.2 FROM employee);
