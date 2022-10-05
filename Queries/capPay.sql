CREATE OR REPLACE TRIGGER cap_pay
FOR UPDATE OR INSERT ON Borrow_details
COMPOUND TRIGGER
TYPE r_borrowDetails_type IS RECORD(
    
    borrowingsID Borrow_details.borrowingsID%TYPE,
    bookID       Borrow_details.bookID%TYPE,
    totalfine    Borrow_details.totalfine%TYPE
);

TYPE t_borrowDetails_type IS TABLE OF r_borrowDetails_type
    INDEX BY PLS_INTEGER;

t_borrowDetails t_borrowDetails_type;

AFTER EACH ROW IS
BEGIN
    t_borrowDetails (t_borrowDetails.COUNT + 1).borrowingsID := :NEW.borrowingsID;
    t_borrowDetails (t_borrowDetails.COUNT).bookID := :NEW.bookID;
    t_borrowDetails (t_borrowDetails.COUNT).totalfine := :NEW.totalfine;
    END AFTER EACH ROW;

AFTER STATEMENT IS
    v_priceEach order_details.priceEach%TYPE;
    v_totalfine Borrow_details.totalfine%TYPE;
BEGIN
    FOR INDX IN 1 .. t_borrowDetails.COUNT
    LOOP
        select order_details.priceEach into v_priceEach
        FROM order_details
        WHERE order_details.bookID = t_borrowDetails (indx).bookID
        and ROWNUM <= 1;

        IF t_borrowDetails (indx).totalfine > v_priceEach THEN
        v_totalfine := v_priceEach;
        UPDATE Borrow_details
        SET totalfine = v_totalfine  
        WHERE borrowingsID = t_borrowDetails (indx).borrowingsID
        AND
        bookID = t_borrowDetails (indx).bookID;
        DBMS_OUTPUT.PUT_LINE('Total fine was capped at ' || v_totalfine || ' because it has exceeded book price borrowed.');
        END IF;
    END LOOP;
END AFTER STATEMENT;
END;
/