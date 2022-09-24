DECLARE    
    v_bookID order_details.bookID%TYPE;
    v_orderQty order_details.orderQty%TYPE;

    CURSOR CsrOrderDetails IS
        SELECT bookID, SUM(orderQty)
        FROM order_details 
        GROUP BY bookID;
    
BEGIN
    OPEN CsrOrderDetails;
    
    LOOP
        FETCH CsrOrderDetails INTO v_bookID, v_orderQty;
        EXIT WHEN CsrOrderDetails%NOTFOUND;
        
        UPDATE books
        SET stockQuantity = v_orderQty
        WHERE bookid = v_bookID;
        
        DBMS_OUTPUT.PUT_LINE('Book ID : ' || v_bookID);
        DBMS_OUTPUT.PUT_LINE('Stock Quantity : ' || v_orderQty);
        DBMS_OUTPUT.PUT_LINE('');
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Record Update : '|| CsrOrderDetails%ROWCOUNT);
    
    CLOSE CsrOrderDetails;
END;
/