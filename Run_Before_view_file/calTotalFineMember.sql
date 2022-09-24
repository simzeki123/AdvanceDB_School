SELECT
    borrowings.memberID,
    sum(borrow_details.totalFine)
FROM
    borrow_details
    INNER JOIN borrowings ON borrowings.borrowingsID = borrow_details.borrowingsID
GROUP BY borrowings.memberID;

DECLARE 
    v_memberID borrowings.memberID%TYPE;
    totalAccumulatedFine borrow_details.totalFine%TYPE;
    
    -- use to calculate
    
    CURSOR CsrTotalFine is
            SELECT
        borrowings.memberID,
        sum(borrow_details.totalFine)
    FROM
        borrow_details
        INNER JOIN borrowings ON borrowings.borrowingsID = borrow_details.borrowingsID
    GROUP BY borrowings.memberID;

BEGIN
    OPEN CsrTotalFine;
    
    LOOP
        FETCH CsrTotalFine INTO v_memberID, totalAccumulatedFine;
        EXIT WHEN CsrTotalFine%NOTFOUND;

        -- v_totalFineMember := (v_totalFineMember+v_totalFine);
        -- DBMS_OUTPUT.PUT_LINE(memberID);
        -- DBMS_OUTPUT.PUT_LINE(totalAccumulatedFine);

        UPDATE members
        SET totalFineMember = totalAccumulatedFine
        WHERE memberID = v_memberID;
          
        -- UPDATE members
        -- SET status = 'Not Eligible'
        -- WHERE memberID = v_memberID;
        
        --DBMS_OUTPUT.PUT_LINE('Borrowings ID : ' || v_borrowingsID);
       -- DBMS_OUTPUT.PUT_LINE('Total Fine : ' || v_totalFineMember);
       -- DBMS_OUTPUT.PUT_LINE('Member ID : ' || v_memberID);
       -- DBMS_OUTPUT.PUT_LINE('Status : ' || v_status);
       -- DBMS_OUTPUT.PUT_LINE('');
        
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Record Updated : ' || CsrTotalFine%ROWCOUNT);
    
    CLOSE CsrTotalFine;
    
END;
/