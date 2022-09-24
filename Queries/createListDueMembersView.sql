COLLUM NAME FORMATE A8;
SET PAGESIZE 30;
SET LINESIZE 200;

DROP VIEW list_due;

CREATE VIEW list_due AS
SELECT NAME,email,PHONENUMBER,STATUS, borrowings.borrowingsID AS BorrowingID
FROM MEMBERS
JOIN borrowings
ON  members.memberid = borrowings.memberid
JOIN borrow_details
ON  borrowings.borrowingsID = borrow_details.borrowingsID
WHERE status = 'Not Eligible' AND dateReturned IS NULL
ORDER BY name;