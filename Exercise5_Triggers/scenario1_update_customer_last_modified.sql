-- ============================================================
-- Exercise 5 - Scenario 1: UpdateCustomerLastModified
-- Automatically sets the LastModified column to the current
-- date whenever any customer record is updated.
-- ============================================================

CREATE OR REPLACE TRIGGER UpdateCustomerLastModified
    BEFORE UPDATE ON Customers
    FOR EACH ROW
BEGIN
    :NEW.LastModified := SYSDATE;
END UpdateCustomerLastModified;
/

-- Test: update a customer and verify LastModified changes
UPDATE Customers SET Balance = Balance + 100 WHERE CustomerID = 1;
COMMIT;

SELECT CustomerID, Name, Balance, LastModified
FROM   Customers
WHERE  CustomerID = 1;
