CREATE OR REPLACE PROCEDURE calculateTotalFine AS 
    v_dateDue borrow_details.dateDue%TYPE;   
    v_borrowingsID borrowings.borrowingsid%TYPE;
    v_memberID members.memberID%TYPE;
    v_status members.status%TYPE;
    v_bookID borrow_details.bookID%TYPE;
    -- use to calculate
    v_daysLate borrow_details.daysLate%TYPE;
    v_totalFine borrow_details.totalFine%TYPE;
    
    CURSOR CsrBorrowDetails is
         SELECT a.borrowingsID, a.dateDue, a.bookID, b.memberID, c.status
         FROM borrow_details a, borrowings b, members c
         WHERE a.borrowingsID = b.borrowingsID 
         AND b.memberID = c.memberID
         AND a.dateReturned IS NULL;

BEGIN
    OPEN CsrBorrowDetails;
    
    LOOP
        FETCH CsrBorrowDetails INTO v_borrowingsID, v_dateDue, v_bookID, v_memberID, v_status;
        EXIT WHEN CsrBorrowDetails%NOTFOUND;

        v_daysLate := ROUND(SYSDATE - v_dateDue) ;
        v_totalFine := v_daysLate * 5;
        
        UPDATE borrow_details
        SET daysLate = v_daysLate, totalFine = v_totalFine
        WHERE borrowingsID = v_borrowingsID
        AND bookID = v_bookID;
        
        UPDATE members
        SET status = 'Not Eligible'
        WHERE memberID = v_memberID;

        Update Borrow_details
        SET totalfine = 0
        WHERE totalfine IS NULL;
        
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Record Updated : ' || CsrBorrowDetails%ROWCOUNT);
    
    CLOSE CsrBorrowDetails;
END;
/