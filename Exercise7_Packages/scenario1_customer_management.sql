-- ============================================================
-- Exercise 7 - Scenario 1: CustomerManagement Package
-- Groups customer-related operations:
--   - AddNewCustomer  : insert a new customer
--   - UpdateCustomer  : update customer name and balance
--   - GetBalance      : return the current balance
-- ============================================================

-- ---------- Package Specification ----------
CREATE OR REPLACE PACKAGE CustomerManagement AS
    PROCEDURE AddNewCustomer (
        p_customer_id IN Customers.CustomerID%TYPE,
        p_name        IN Customers.Name%TYPE,
        p_dob         IN Customers.DOB%TYPE,
        p_balance     IN Customers.Balance%TYPE
    );

    PROCEDURE UpdateCustomer (
        p_customer_id IN Customers.CustomerID%TYPE,
        p_name        IN Customers.Name%TYPE,
        p_balance     IN Customers.Balance%TYPE
    );

    FUNCTION GetBalance (
        p_customer_id IN Customers.CustomerID%TYPE
    ) RETURN NUMBER;
END CustomerManagement;
/

-- ---------- Package Body ----------
CREATE OR REPLACE PACKAGE BODY CustomerManagement AS

    PROCEDURE AddNewCustomer (
        p_customer_id IN Customers.CustomerID%TYPE,
        p_name        IN Customers.Name%TYPE,
        p_dob         IN Customers.DOB%TYPE,
        p_balance     IN Customers.Balance%TYPE
    ) AS
    BEGIN
        INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
        VALUES (p_customer_id, p_name, p_dob, p_balance, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Customer added: ' || p_name);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: Customer ID ' || p_customer_id || ' already exists.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
    END AddNewCustomer;

    PROCEDURE UpdateCustomer (
        p_customer_id IN Customers.CustomerID%TYPE,
        p_name        IN Customers.Name%TYPE,
        p_balance     IN Customers.Balance%TYPE
    ) AS
    BEGIN
        UPDATE Customers
        SET    Name    = p_name,
               Balance = p_balance,
               LastModified = SYSDATE
        WHERE  CustomerID = p_customer_id;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: Customer ID ' || p_customer_id || ' not found.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Customer ' || p_customer_id || ' updated.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
    END UpdateCustomer;

    FUNCTION GetBalance (
        p_customer_id IN Customers.CustomerID%TYPE
    ) RETURN NUMBER AS
        v_balance Customers.Balance%TYPE;
    BEGIN
        SELECT Balance INTO v_balance
        FROM   Customers
        WHERE  CustomerID = p_customer_id;
        RETURN v_balance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: Customer ID ' || p_customer_id || ' not found.');
            RETURN NULL;
    END GetBalance;

END CustomerManagement;
/

-- Test
BEGIN
    CustomerManagement.AddNewCustomer(20, 'Eve White', TO_DATE('1995-08-08','YYYY-MM-DD'), 3000);
    CustomerManagement.UpdateCustomer(20, 'Eve White', 3500);
    DBMS_OUTPUT.PUT_LINE('Balance: $' || CustomerManagement.GetBalance(20));
END;
/
