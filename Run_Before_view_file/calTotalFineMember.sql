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

        UPDATE members
        SET totalFineMember = totalAccumulatedFine
        WHERE memberID = v_memberID;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Record Updated : ' || CsrTotalFine%ROWCOUNT);
    
    CLOSE CsrTotalFine;
    
END;
/