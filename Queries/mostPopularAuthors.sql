set serveroutput on;
set linesize 140;
set pagesize 50;

-- Top 5 Most popular author based on number of times books were borrowed
CREATE OR REPLACE PROCEDURE popular_author(year NUMBER) AS

    v_totalborrowing    number(5);
    v_authorName        authors.name%TYPE;
    v_authorId          authors.AuthorID%TYPE;

CURSOR CRS_report IS
    select * 
    FROM
    (
     SELECT DISTINCT book_authors.AuthorID,authors.name,count(borrow_details.borrowingsID) AS Number_Borrowed
    FROM book_authors
    INNER JOIN borrow_details
    ON book_authors.bookID = borrow_details.bookID
    INNER JOIN authors
    ON book_authors.AuthorID = authors.AuthorID
    GROUP BY authors.name , book_authors.AuthorID
    ORDER BY count(borrow_details.borrowingsID) DESC)
    WHERE ROWNUM <= 5;

BEGIN
	dbms_output.put_line(rpad('=', 65, '='));
    dbms_output.put_line(rpad('||', 18) ||rpad('Our TOP 5 Most Popular Author', 45) || ('||'));
	dbms_output.put_line(rpad('||', 5) || rpad('AUTHOR ID', 20) || rpad('AUTHOR NAME', 18) || rpad('Number of borrows', 20) || ('||'));
	dbms_output.put_line(rpad('=', 65, '='));

    open CRS_report;

   LOOP
        FETCH CRS_report INTO v_authorId, v_authorName, v_totalborrowing;
        EXIT WHEN CRS_report%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(rpad('||', 7) || rpad(v_authorId, 20) || rpad(v_authorName, 22)  || rpad(v_totalborrowing, 14) || ('||'));
    END LOOP;

        DBMS_OUTPUT.PUT_LINE('                                                  ');
        dbms_output.put_line(rpad('=', 65, '='));
    
        DBMS_OUTPUT.PUT_LINE(rpad('REPORT COMPLETED', 32) || lpad('Generated ON ', 23) || SYSDATE);

END;
/

exec popular_author(2001)