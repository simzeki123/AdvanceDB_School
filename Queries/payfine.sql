SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE payFine(in_MemberID in borrowings.memberID%TYPE,in_BookID in borrow_details.BOOKID%TYPE) IS

    v_todaydate DATE;
    v_totalFineMember members.totalFineMember%TYPE;
    v_totalfine borrow_details.totalfine%TYPE;
    v_bookID borrow_details.bookID%TYPE;
    v_priceEach order_details.priceEach%TYPE;
    v_memberID borrowings.memberID%TYPE;
    v_borrowingsID borrow_details.borrowingsID%TYPE;

    CURSOR CsrPayFine is
        SELECT 
        borrowings.memberID,
        borrow_details.bookID,
        priceEach,
        totalfine,
        borrow_details.borrowingsID
    FROM
        borrow_details
        INNER JOIN borrowings ON borrowings.borrowingsID = borrow_details.borrowingsID
        JOIN order_details
        ON borrow_details.bookID = order_details.bookID
        WHERE borrow_details.BOOKID = in_BookID
        AND
        borrow_details.dateReturned IS NULL
        ORDER BY memberID;

    CURSOR CsrtotalmemberFine IS
        SELECT members.totalfinemember
        FROM members
        WHERE members.memberID = in_MemberID;

BEGIN
    OPEN CsrPayFine;
    
        FETCH CsrPayFine INTO v_memberID, v_bookID, v_priceEach, v_totalfine, v_borrowingsID;
        CLOSE CsrPayFine;
    
    OPEN CsrtotalmemberFine;

        FETCH CsrtotalmemberFine INTO v_totalFineMember;
        CLOSE CsrtotalmemberFine;

        if v_totalfine > v_priceEach THEN
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Your Fine For this Book is :$' || v_totalfine);
            v_totalFineMember := (v_totalFineMember-v_totalfine);

            DBMS_OUTPUT.PUT_LINE('Your remaining fines :$' || v_totalFineMember);
            v_totalfine := 0;

            UPDATE members
            SET totalFineMember = v_totalFineMember
            WHERE memberID = v_memberID;

            UPDATE borrow_details
            SET 
            totalFine = v_totalfine,
            dateReturned = SYSDATE
            WHERE borrowingsID = v_borrowingsID;



        ELSIF v_totalfine IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('You have made your payment.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Your Fine For this Book is :$' || v_priceEach);
            v_totalFineMember := (v_totalFineMember-v_priceEach);

            DBMS_OUTPUT.PUT_LINE('Your remaining fines is :$' || v_totalFineMember);
            v_totalfine := 0;

            UPDATE members
            SET totalFineMember = v_totalFineMember
            WHERE memberID = v_memberID;

            UPDATE borrow_details
            SET 
            totalFine = v_totalfine,
            dateReturned = SYSDATE
            WHERE borrowingsID = v_borrowingsID;
        END IF;
END;
/