set serveroutput on;
set linesize 140;
set pagesize 50;

SELECT TO_CHAR(TO_DATE(EXTRACT(MONTH FROM dateReturned), 'MM'), 'MONTH') AS "Month Name",
COUNT(borrowingsID) AS Borrowed
FROM borrow_detailS, DUAL
WHERE dateReturned IS NOT NULL
GROUP BY EXTRACT(MONTH FROM dateReturned)
ORDER BY COUNT(borrowingsID) DESC;

CREATE OR REPLACE PROCEDURE monthly_borrow AS

    v_totalBorrowings    number(5);
    v_Mont               varchar(20);

    CURSOR CRS_report_Month IS
        SELECT TO_CHAR(TO_DATE(EXTRACT(MONTH FROM dateReturned), 'MM'), 'MONTH') AS "Month Name",
        COUNT(borrowingsID) AS Borrowed
        FROM borrow_detailS, DUAL
        WHERE dateReturned IS NOT NULL
        GROUP BY EXTRACT(MONTH FROM dateReturned)
        ORDER BY COUNT(borrowingsID) DESC;

BEGIN
    dbms_output.put_line(rpad('=', 40, '='));
    dbms_output.put_line(rpad('||', 5) ||rpad('Total Borrowing From Each Month', 33) || ('||'));
    dbms_output.put_line(rpad('||', 5) || rpad('MONTH', 15) || rpad('Total Borrowing', 18) || ('||'));
    dbms_output.put_line(rpad('=', 40, '='));

    open CRS_report_Month;
    LOOP
        FETCH CRS_report_Month INTO v_Mont, v_totalBorrowings;
        EXIT WHEN CRS_report_Month%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(rpad('||', 5) || rpad( v_Mont, 20) || rpad(v_totalBorrowings, 13) || ('||'));
    END LOOP;

        dbms_output.put_line(rpad('=', 40, '='));
    
        DBMS_OUTPUT.PUT_LINE(rpad('REPORT COMPLETED', 15) || lpad('Generated ON ', 15) || SYSDATE);

END;
/

exec monthly_borrow;