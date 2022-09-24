SELECT d.bookID, c.stockquantity, borrowCount
FROM books c
RIGHT JOIN (SELECT bookID, COUNT(bookID) borrowCount
FROM borrow_details b
WHERE dateReturned IS NULL 
GROUP BY bookID) d
ON c.bookID = d.bookID;

DECLARE 
    v_bookID borrow_details.bookid%TYPE;
    v_borrowQuantity borrowings.borrowquantity%TYPE;
    v_stockQuantity books.stockquantity%TYPE;
    
    -- use to calculate
    v_totalStock books.stockquantity%TYPE;

    CURSOR CsrBorrowings IS
        SELECT d.bookID, c.stockquantity, borrowCount
        FROM books c
        RIGHT JOIN (SELECT bookID, COUNT(bookID) borrowCount
        FROM borrow_details b
        WHERE dateReturned IS NULL 
        GROUP BY bookID) d
        ON c.bookID = d.bookID;
        
BEGIN
    OPEN CsrBorrowings;
    
    LOOP 
        FETCH CsrBorrowings INTO v_bookID, v_stockquantity, v_borrowQuantity;
        EXIT WHEN CsrBorrowings%NOTFOUND;
        
        v_totalStock := v_stockQuantity - v_borrowQuantity;
        
        UPDATE books
        SET stockQuantity = v_totalStock
        WHERE bookID = v_bookID;
        
        DBMS_OUTPUT.PUT_LINE('Books ID : ' || v_bookID);
        DBMS_OUTPUT.PUT_LINE('Total Borrows Quantity : ' || v_borrowQuantity);
        DBMS_OUTPUT.PUT_LINE('Total Stock Quantity : ' || v_totalStock);
        
        DBMS_OUTPUT.PUT_LINE('');
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Record Updtaes : ' ||CsrBorrowings%ROWCOUNT);

END;
/