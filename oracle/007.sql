--1. �����μ��� 90�� ��ձ޿�
DESC DEPARTMENTS;
--1.1 �μ��� ���������� �����μ�
SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE PARENT_ID = 90;
SELECT  DEPARTMENT_ID, ROUND(AVG(SALARY), 2) AVG_SAL
FROM EMPLOYEES 
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID 
                        FROM DEPARTMENTS
                        WHERE PARENT_ID = 90)
GROUP BY DEPARTMENT_ID;
--1.2 �������� �ϱ�
SELECT A.DEPARTMENT_ID, ROUND(AVG(B.SALARY), 2) AVG_SAL
FROM DEPARTMENTS A JOIN EMPLOYEES B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
WHERE A.PARENT_ID = 90
GROUP BY A.DEPARTMENT_ID;
--1.3 ���� �μ��� ��ȹ���� ��� ����� �޿��� �ڽ��� �μ��� ��ձ޿��� �����ϴ� ����
UPDATE EMPLOYEES A
SET SALARY = (SELECT AVG_SAL
              FROM (SELECT  A.DEPARTMENT_ID, ROUND(AVG(B.SALARY), 2) AVG_SAL
                    FROM DEPARTMENTS A JOIN EMPLOYEES B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
                    WHERE A.PARENT_ID = 90
                    GROUP BY A.DEPARTMENT_ID) B
              WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID)
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID 
                        FROM DEPARTMENTS
                        WHERE PARENT_ID = 90);
ROLLBACK;
--1.4 90�� �����μ� ���� ����� ��ձ޿����� ���� �޿��� �޴� �����
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS WHERE PARENT_ID = 90;
--��� �޿�
SELECT ROUND(AVG(B.SALARY), 2) FROM DEPARTMENTS A JOIN EMPLOYEES B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
       WHERE A.PARENT_ID = 90;
--���1       
SELECT A.DEPARTMENT_ID, A.PARENT_ID, B.SALARY
FROM DEPARTMENTS A JOIN EMPLOYEES B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
WHERE A.PARENT_ID = 90
      AND B.SALARY > (SELECT ROUND(AVG(B.SALARY), 2) 
                      FROM DEPARTMENTS A JOIN EMPLOYEES B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
                      WHERE A.PARENT_ID = 90);
--���2 SQL ����Ŭ JOIN
SELECT A.EMPLOYEE_ID, A.EMP_NAME, B.DEPARTMENT_ID, B.DEPARTMENT_NAME, A.SALARY
FROM EMPLOYEES A, DEPARTMENTS B, (SELECT AVG(B.SALARY) "AVG_SALARY"
                                  FROM DEPARTMENTS A, EMPLOYEES B WHERE A.PARENT_ID = 90 AND A.DEPARTMENT_ID = B.DEPARTMENT_ID) C
WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.SALARY > C.AVG_sALARY
AND B.PARENT_ID = 90;

--1.5 90�� ���Ϻμ��� �μ��� �߿��� �μ��� ����̻��� �޿��� �޴� �μ��� ��ȸ
/*SELECT *
FROM DEPARTMENTS 
WHERE PARENT_ID = 90;
--90�� ���Ϻμ� �μ��� ��ձ޿�
SELECT A.DEPARTMENT_ID, AVG(B.SALARY)
FROM DEPARTMENTS A JOIN EMPLOYEES B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
WHERE A.PARENT_ID = 90 
GROUP BY A.DEPARTMENT_ID;*/
--���� ���� ��� �޿� -> 90�� ���Ϻμ� -> ���
SELECT A.EMPLOYEE_ID, A.EMP_NAME, A.DEPARTMENT_ID, A.SALARY
FROM EMPLOYEES A JOIN (SELECT DEPARTMENT_ID, AVG(SALARY) "AVG_SAL"
                       FROM EMPLOYEES
                       GROUP BY DEPARTMENT_ID) B
                 ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.SALARY >= B.AVG_SAL)  --�������� �ΰ�..��������� �μ��� ��ձ޿� �Ѵ� �����
WHERE A.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID  --WHERE ~~���� �ϳ��� "=" �������Ͻ� IN����
                          FROM DEPARTMENTS
                          WHERE PARENT_ID = 90)   --90�� ���Ϻμ��� �����
ORDER BY A.DEPARTMENT_ID, A.SALARY DESC;

--1.6 ��ȹ�� ���Ϻμ��� �μ��� �� 2017�� 7�� 1�� ���� ��� �ټ� ���� �̻� �ٹ��� �μ��� ��ȸ
--��ȹ�� ���Ϻμ� ���ϱ�->��� ������� �ټӿ��� ���ϱ�->
/*
--1) ��ȹ�� ��ȸ
SELECT * FROM DEPARTMENTS;
--2) ��ȹ�� ���� �μ�
SELECT * FROM DEPARTMENTS WHERE PARENT_ID = 90;
--3)��� �ټ� ����
DESC EMPLOYEES;
--
SELECT EMP_NAME, HIRE_dATE, FLOOR(MONTHS_BETWEEN('2017-07-01' ,HIRE_DATE) / 12) "�ټӿ���"
FROM EMPLOYEES;*/
--1) ��ȹ�� ã��
SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = '��ȹ��';
--2) ���Ϻμ�ã��
SELECT DEPARTMENT_ID FROM DEPARTMENTS
WHERE PARENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = '��ȹ��');
/*--3) ���Ϻμ��� ���� �ִ� ����...��������� �ʿ������
SELECT * 
FROM EMPLOYEES A JOIN (SELECT DEPARTMENT_ID FROM DEPARTMENTS
                       WHERE PARENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = '��ȹ��')) B
                 ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID);*/
--4)��� �������� ����, �ټӿ��� ...�߰����̴ϱ� FLOOR�� �������������� ����
SELECT EMP_NAME, DEPARTMENT_ID, MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), HIRE_DATE) / 12 "WORD_YEAR"
FROM EMPLOYEES;
--5) ���úμ� ������ ���̰�
SELECT EMP_NAME, DEPARTMENT_ID, MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), HIRE_DATE) / 12 "WORK_YEAR"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENTS
                        WHERE PARENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = '��ȹ��'));
--6) ��ȹ�� ������ ��� �ټӿ���
SELECT AVG(MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), HIRE_DATE) / 12) "AVG_WORK_YEAR"
FROM EMPLOYEES 
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENTS
                        WHERE PARENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = '��ȹ��'));
--7) �̵��� �ټӿ����� ��� �ټӿ��� �̻� �ٹ��� ���� ��
SELECT EMP_NAME, DEPARTMENT_ID, 
       FLOOR(MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), HIRE_DATE) / 12) "WORK_YEAR", AVG_WORK_YEAR
FROM EMPLOYEES A JOIN (SELECT AVG(MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), HIRE_DATE) / 12) "AVG_WORK_YEAR"
                       FROM EMPLOYEES 
                       WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENTS
                                               WHERE PARENT_ID = 
                                               (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = '��ȹ��'))) B
                       ON (MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), A.HIRE_DATE) / 12) >= AVG_WORK_YEAR
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENTS
                        WHERE PARENT_ID = (SELECT DEPARTMENT_ID 
                                           FROM DEPARTMENTS 
                                           WHERE DEPARTMENT_NAME = '��ȹ��'));

--8) ���
SELECT EMP_NAME, DEPARTMENT_ID, 
       FLOOR(MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), HIRE_DATE) / 12) "WORK_YEAR"
FROM EMPLOYEES A JOIN (SELECT AVG(MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), HIRE_DATE) / 12) "AVG_WORK_YEAR"
                             FROM EMPLOYEES
                             WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                                                     FROM DEPARTMENTS
                                                     WHERE PARENT_ID = (SELECT DEPARTMENT_ID 
                                                                        FROM DEPARTMENTS 
                                                                        WHERE DEPARTMENT_NAME = '��ȹ��'))) B 
                        ON (MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), A.HIRE_DATE) / 12 >= AVG_WORK_YEAR)                                              
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE PARENT_ID = (SELECT DEPARTMENT_ID 
                                           FROM DEPARTMENTS 
                                           WHERE DEPARTMENT_NAME = '��ȹ��'))
ORDER BY DEPARTMENT_ID, WORK_YEAR DESC, EMP_NAME;
--9)JOIN���� �����̳��� ����ϰ�
SELECT A.EMP_NAME, A.DEPARTMENT_ID, 
       FLOOR(MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), HIRE_DATE) / 12) "WORK_YEAR"
FROM EMPLOYEES A JOIN (SELECT AVG(MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), HIRE_DATE) / 12) "AVG_WORK_YEAR"
                             FROM EMPLOYEES A JOIN (SELECT DEPARTMENT_ID
                                                     FROM DEPARTMENTS
                                                     WHERE PARENT_ID = (SELECT DEPARTMENT_ID 
                                                                        FROM DEPARTMENTS 
                                                                        WHERE DEPARTMENT_NAME = '��ȹ��')) B
                                               ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID))
                        ON (MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), A.HIRE_DATE) / 12 >= AVG_WORK_YEAR) 
                        JOIN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS 
                        WHERE PARENT_ID = (SELECT DEPARTMENT_ID 
                                           FROM DEPARTMENTS 
                                           WHERE DEPARTMENT_NAME = '��ȹ��')) C --INLINE VIEW
                        ON (A.DEPARTMENT_ID = C.DEPARTMENT_ID)
ORDER BY DEPARTMENT_ID, WORK_YEAR DESC, EMP_NAME;
--9-1) �ٸ� ���� ��������..
SELECT A.EMP_NAME, A.DEPARTMENT_ID, 
       FLOOR(MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), HIRE_DATE) / 12) "WORK_YEAR"
FROM EMPLOYEES A JOIN (SELECT AVG(MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), HIRE_DATE) / 12) "AVG_WORK_YEAR"
                             FROM EMPLOYEES A JOIN (SELECT A.DEPARTMENT_ID
                                                    FROM DEPARTMENTS A JOIN DEPARTMENTS B ON (A.PARENT_ID = B.DEPARTMENT_ID)
                                                    WHERE B.DEPARTMENT_NAME = '��ȹ��') B
                                               ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID))
                        ON (MONTHS_BETWEEN(TO_DATE('2017-07-01', 'YYYY-MM-DD'), A.HIRE_DATE) / 12 >= AVG_WORK_YEAR) 
                        JOIN (SELECT A.DEPARTMENT_ID
                              FROM DEPARTMENTS A JOIN DEPARTMENTS B ON (A.PARENT_ID = B.DEPARTMENT_ID)
                              WHERE B.DEPARTMENT_NAME = '��ȹ��') C --INLINE VIEW
                        ON (A.DEPARTMENT_ID = C.DEPARTMENT_ID)
ORDER BY DEPARTMENT_ID, WORK_YEAR DESC, EMP_NAME;

--2. ������ ����
--START WITH�� ���� ����� ������ ��..CONNECT BY���� MANAGER_ID�� ������ ���÷��̾��̵� PRIOR ����
--LEVEL�� �־� ���� �˾ƺ��� LPAD��
SELECT EMPLOYEE_ID, EMP_NAME, LEVEL
FROM EMPLOYEES
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;     --=MANAGER_ID = EMPLOYEE_ID
--LEVEL�� �־� ���� �˾ƺ��� LPAD��
SELECT EMPLOYEE_ID, LPAD(' ', 4 * (LEVEL - 1)) || EMP_NAME "ENAME", LEVEL
FROM EMPLOYEES
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;

--2.1 �μ����� ���
SELECT EMPLOYEE_ID, DEPARTMENT_ID, LPAD(' ', 2 * (LEVEL - 1)) || EMP_NAME "ENAME", LEVEL
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 100
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;
--WHERE ���� 100�� ����ϸ� �̻��ϰ� �߳�..���������� ��â.
--���
SELECT EMPLOYEE_ID, DEPARTMENT_ID, LPAD(' ', 2 * (LEVEL - 1)) || EMP_NAME "ENAME", LEVEL
FROM EMPLOYEES
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
AND DEPARTMENT_ID = 90;

--2.2 SIBLINGS BY ���� �������� ��Ʈ�� ������
SELECT EMPLOYEE_ID, DEPARTMENT_ID, LPAD(' ', 2 * (LEVEL - 1)) || EMP_NAME "ENAME", LEVEL
FROM EMPLOYEES
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
ORDER SIBLINGS BY DEPARTMENT_ID;

--2.3 CONNECT_BY_ISLEAF
SELECT EMPLOYEE_ID, DEPARTMENT_ID, LPAD(' ', 2 * (LEVEL - 1)) || EMP_NAME "ENAME", LEVEL,
       CONNECT_BY_ROOT DEPARTMENT_ID AS ROOT, CONNECT_BY_ISLEAF,
       SYS_CONNECT_BY_PATH(DEPARTMENT_ID, '/') PATH
FROM EMPLOYEES
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
ORDER SIBLINGS BY DEPARTMENT_ID;

--3. P.221~ ������ ���� ����
--2016�� 1��~12������ �� ������ 1000���� �����͸� �����ض� ���� õ��=12000
SELECT TO_DATE('2016-' || LPAD(CEIL(ROWNUM/1000), 2, '0'), 'YYYY-MM') COL1, FLOOR(DBMS_RANDOM.VALUE(5000, 6000)) COL2, 3 COL3
FROM DUAL
CONNECT BY LEVEL <= 12000;

--4. WITH ��
--������ ������ ���� ������ ���� ���� ���ÿ� �� �ܾ��� ��ȸ�ϱ�
--1) �� ������ ������
SELECT MAX(PERIOD)
FROM KOR_LOAN_STATUS
GROUP BY SUBSTR(PERIOD, 1, 4);
--2) ������ ���� ���� ��
SELECT PERIOD, REGION, SUM(LOAN_JAN_AMT) TOTAL
FROM KOR_LOAN_STATUS
GROUP BY PERIOD, REGION;
--3)�ϴ��� �Ѹ���
SELECT A.MAX_PERIOD, MAX(TOTAL) MAX_LOAN_JAN_AMT
FROM (SELECT MAX(PERIOD) MAX_PERIOD
      FROM KOR_LOAN_STATUS
      GROUP BY SUBSTR(PERIOD, 1, 4)) A
      JOIN
      (SELECT PERIOD, REGION, SUM(LOAN_JAN_AMT) TOTAL
       FROM KOR_LOAN_STATUS
       GROUP BY PERIOD, REGION) B
       ON (A.MAX_PERIOD = B.PERIOD)
GROUP BY A.MAX_PERIOD;
--4)�հ�                   
WITH X AS (SELECT PERIOD, REGION, SUM(LOAN_JAN_AMT) TOTAL
          FROM KOR_LOAN_STATUS
          GROUP BY PERIOD, REGION),
     Y AS (SELECT A.MAX_PERIOD, MAX(TOTAL) MAX_LOAN_JAN_AMT
          FROM (SELECT MAX(PERIOD) MAX_PERIOD
                FROM KOR_LOAN_STATUS
                GROUP BY SUBSTR(PERIOD, 1, 4)) A
       JOIN X ON (A.MAX_PERIOD = X.PERIOD)
       GROUP BY A.MAX_PERIOD)
SELECT X.PERIOD, X.REGION, X.TOTAL 
FROM X JOIN Y ON (X.PERIOD = Y.MAX_PERIOD AND X.TOTAL = Y.MAX_LOAN_JAN_AMT);

--5. �м��Լ�..ROW_NUMBER, RANK, DENSE_RANK
--5.1 �μ����̵� ���� ���� ������..���� ROWNUM�� ����� ����
SELECT ROWNUM, EMPLOYEE_ID, EMP_NAME, SALARY
FROM EMPLOYEES
ORDER BY DEPARTMENT_ID, EMP_NAME, SALARY DESC;
--PATITION ����, ROWNUM ���
SELECT DEPARTMENT_ID, ROW_NUMBER() OVER (PARTITION BY DEPARTMENT_ID
                          ORDER BY DEPARTMENT_ID, EMP_NAME) "ROWNUM",
       EMP_NAME, SALARY
FROM EMPLOYEES;
--SALARY�� ����..ROW NUMBER ��� RANK�� �����ϴ�.(RANK�� �������� 2�� 2�� ������ 3��X 4��) DENSE_RANK�� 2�� 2�� ���� 3��
SELECT DEPARTMENT_ID, DENSE_RANK() OVER (PARTITION BY DEPARTMENT_ID
                          ORDER BY DEPARTMENT_ID, SALARY DESC) "RANK",
       EMP_NAME, SALARY
FROM EMPLOYEES;

--�� �μ����� 3����
SELECT *
FROM (SELECT DEPARTMENT_ID, DENSE_RANK() OVER (PARTITION BY DEPARTMENT_ID
                          ORDER BY DEPARTMENT_ID, SALARY DESC) "RANK",
       EMP_NAME, SALARY
FROM EMPLOYEES) A
WHERE RANK = 3;

--5. ���� ���̺� INSERT
CREATE TABLE EX7_3(
        EMP_ID NUMBER,
        EMP_NAME VARCHAR2(100));
CREATE TABLE EX7_4(
        EMP_ID NUMBER,
        EMP_NAME VARCHAR2(100));
--ALL�� �ҷ��� �ڿ� �ݵ�� SELECT * FROM DUAL;�� �����
INSERT ALL
    INTO EX7_3 VALUES(100, '�赿ȯ')
    INTO EX7_3 VALUES(100, '�κ���')
    INTO EX7_3 VALUES(100, '���ּ�')
SELECT * 
FROM DUAL;

SELECT * FROM EX7_3;
ROLLBACK;

--5.1 �μ��� ���� �ٸ� ���̺��� �������ϱ�
INSERT ALL
WHEN DEPARTMENT_ID = 30 THEN
    INTO EX7_3 VALUES(EMPLOYEE_ID, EMP_NAME)
WHEN DEPARTMENT_ID = 90 THEN
    INTO EX7_4 VALUES(EMPLOYEE_ID, EMP_NAME)
SELECT DEPARTMENT_ID, EMPLOYEE_ID, EMP_NAME
FROM EMPLOYEES;
SELECT * FROM EX7_4;
ROLLBACK;