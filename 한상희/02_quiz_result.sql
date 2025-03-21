-- JOIN을 이용하여 여러 테이블을 조회 시에는 모든 컬럼에 테이블 별칭을 사용하는 것이 좋다.

-- 1. 직급이 대리이면서 아시아 지역에 근무하는 직원의 사번, 이름, 직급명, 부서명, 지역명, 급여를 조회하세요
SELECT e.EMP_ID     "사번",
       e.EMP_NAME   "이름",
       j.JOB_NAME   "직명",
       d.DEPT_TITLE "부서명",
       l.LOCAL_NAME "지역명",
       e.SALARY     "급여"
FROM EMPLOYEE e,
     JOB j,
     DEPARTMENT d,
     LOCATION l
WHERE j.JOB_CODE = e.JOB_CODE
  AND d.DEPT_ID = e.DEPT_CODE
  AND d.LOCATION_ID = l.LOCAL_CODE;

-- 2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원의 이름, 주민등록번호, 부서명, 직급명을 조회하세요.
SELECT E.EMP_NAME   "이름",
       E.EMP_NO     "주민등록번호",
       D.DEPT_TITLE "부서명",
       J.JOB_NAME   "직급명"
FROM EMPLOYEE E,
     DEPARTMENT D,
     JOB J
WHERE E.DEPT_CODE = D.DEPT_ID
  AND E.JOB_CODE = J.JOB_CODE
  AND SUBSTR(E.EMP_NO, -7, 1) = 2
  AND E.EMP_NO LIKE '7%';

-- 3. 이름에 '형'자가 들어가는 직원의 사번, 이름, 직급명을 조회하세요.
SELECT E.EMP_ID   "사번",
       E.EMP_NAME "이름",
       J.JOB_NAME "직급명"
FROM EMPLOYEE E,
     JOB J
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.EMP_NAME LIKE '%형%';

-- 4. 해외영업팀에 근무하는 직원의 이름, 직급명, 부서코드, 부서명을 조회하세요.
SELECT E.EMP_NAME,
       J.JOB_NAME,
       E.DEPT_CODE,
       D.DEPT_TITLE
FROM EMPLOYEE E,
     JOB J,
     DEPARTMENT D
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.DEPT_CODE = D.DEPT_ID;

-- 5. 보너스포인트를 받는 직원의 이름, 보너스, 부서명, 지역명을 조회하세요.
SELECT E.EMP_NAME,
       E.BONUS,
       D.DEPT_TITLE,
       L.LOCAL_NAME
FROM EMPLOYEE E,
     DEPARTMENT D,
     LOCATION L
WHERE E.BONUS IS NOT NULL
  AND D.DEPT_ID = E.DEPT_CODE
  AND D.LOCATION_ID = L.LOCAL_CODE;

-- 6. 부서코드가 D2인 직원의 이름, 직급명, 부서명, 지역명을 조회하세오.
SELECT E.EMP_NAME,
       J.JOB_NAME,
       D.DEPT_TITLE,
       L.LOCAL_NAME
FROM EMPLOYEE E,
     JOB J,
     DEPARTMENT D,
     LOCATION L
WHERE E.DEPT_CODE = 'D2'
  AND L.LOCAL_CODE = D.LOCATION_ID
  AND D.DEPT_ID = E.DEPT_CODE
  AND E.JOB_CODE = J.JOB_CODE;

-- 7. 한국(KO)과 일본(JP)에 근무하는 직원의 이름, 부서명, 지역명, 국가명을 조회하세요.
SELECT E.EMP_NAME,
       D.DEPT_TITLE,
       L.LOCAL_NAME,
       N.NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D
     ON D.DEPT_ID = E.DEPT_CODE
JOIN LOCATION L
     ON L.LOCAL_CODE = D.LOCATION_ID
JOIN NATION N
     ON N.NATIONAL_CODE = L.NATIONAL_CODE
WHERE N.NATIONAL_NAME in ('한국', '일본')

