SELECT a.borrowingsID, a.dateDue, b.memberID, c.status, a.totalFine
FROM borrow_details a, borrowings b, members c
WHERE a.borrowingsID = b.borrowingsID 
AND b.memberID = c.memberID
AND a.dateReturned IS NULL;

DECLARE 
    v_dateDue borrow_details.dateDue%TYPE;   
    v_borrowingsID borrowings.borrowingsid%TYPE;
    v_memberID members.memberID%TYPE;
    v_status members.status%TYPE;
    
    -- use to calculate
    v_daysLate borrow_details.daysLate%TYPE;
    v_totalFine borrow_details.totalFine%TYPE;
    
    CURSOR CsrBorrowDetails is
         SELECT a.borrowingsID, a.dateDue, b.memberID, c.status
         FROM borrow_details a, borrowings b, members c
         WHERE a.borrowingsID = b.borrowingsID 
         AND b.memberID = c.memberID
         AND a.dateReturned IS NULL;

BEGIN
    OPEN CsrBorrowDetails;
    
    LOOP
        FETCH CsrBorrowDetails INTO v_borrowingsID, v_dateDue, v_memberID, v_status;
        EXIT WHEN CsrBorrowDetails%NOTFOUND;

        v_daysLate := ROUND(SYSDATE - v_dateDue) ;
        v_totalFine := v_daysLate * 5;
        
        UPDATE borrow_details
        SET daysLate = v_daysLate, totalFine = v_totalFine
        WHERE borrowingsID = v_borrowingsID;
        
        UPDATE members
        SET status = 'Not Eligible'
        WHERE memberID = v_memberID;

        Update Borrow_details
        SET totalfine = 0
        WHERE totalfine IS NULL
        
        DBMS_OUTPUT.PUT_LINE('Borrowings ID : ' || v_borrowingsID);
        DBMS_OUTPUT.PUT_LINE('Date Due : '||  v_dateDue);
        DBMS_OUTPUT.PUT_LINE('Days Late : ' || v_daysLate);
        DBMS_OUTPUT.PUT_LINE('Total Fine (RM 5 PER DAY) : ' || v_totalFine);
        DBMS_OUTPUT.PUT_LINE('Member ID : ' || v_memberID);
        DBMS_OUTPUT.PUT_LINE('Status : ' || v_status);
        DBMS_OUTPUT.PUT_LINE('');
        
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Record Updated : ' || CsrBorrowDetails%ROWCOUNT);
    
    CLOSE CsrBorrowDetails;
END;
/