-- ============================================================
-- Exercise 2 - Scenario 3: AddNewCustomer
-- Insert a new customer. Handles duplicate CustomerID by logging
-- an error and preventing the insertion.
-- ============================================================

CREATE OR REPLACE PROCEDURE AddNewCustomer (
    p_customer_id IN Customers.CustomerID%TYPE,
    p_name        IN Customers.Name%TYPE,
    p_dob         IN Customers.DOB%TYPE,
    p_balance     IN Customers.Balance%TYPE
) AS
    e_duplicate_customer EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_duplicate_customer, -00001); -- ORA-00001: unique constraint violated
BEGIN
    INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
    VALUES (p_customer_id, p_name, p_dob, p_balance, SYSDATE);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Customer added successfully: ' || p_name
                         || ' (ID: ' || p_customer_id || ')');

EXCEPTION
    WHEN e_duplicate_customer THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Customer with ID ' || p_customer_id
                             || ' already exists. Insertion prevented.');

    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END AddNewCustomer;
/

-- Test
BEGIN
    AddNewCustomer(10, 'New User', TO_DATE('2000-01-01','YYYY-MM-DD'), 500); -- Valid
    AddNewCustomer(1,  'Dup User', TO_DATE('2000-01-01','YYYY-MM-DD'), 500); -- Should fail: ID 1 exists
END;
/
