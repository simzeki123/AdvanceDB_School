CREATE OR REPLACE TRIGGER cap_pay
AFTER UPDATE OR INSERT ON Borrow_details
FOR EACH ROW

DECLARE
    v_totalfine     borrow_details.totalfine%TYPE;
    v_priceEach order_details.priceEach%TYPE;
    v_totalfinemember members.totalfineMember%TYPE;

BEGIN
    select priceEach , members.totalfineMember
    INTO v_priceEach
    FROM order_details
    WHERE BookID = :NEW.bookID
    and ROWNUM <= 1;

    v_totalfine := :New.totalfine;
    

    IF v_totalfine >= v_priceEach THEN

    v_totalfine := v_priceEach;
    UPDATE members
    SET totalfine = v_totalfine;
    DBMS_OUTPUT.PUT_LINE('Total fine was capped at ' || v_totalfine || ' because it has exceeded book price borrowed.');
    END IF;
END;
/