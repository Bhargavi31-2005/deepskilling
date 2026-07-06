-- ============================================================
-- Exercise 7 - Scenario 3: AccountOperations Package
-- Groups account-related operations:
--   - OpenAccount       : create a new account for a customer
--   - CloseAccount      : remove an account (zero balance only)
--   - GetTotalBalance   : sum of balances across all accounts
--                         for a given customer
-- ============================================================

-- ---------- Package Specification ----------
CREATE OR REPLACE PACKAGE AccountOperations AS
    PROCEDURE OpenAccount (
        p_account_id   IN Accounts.AccountID%TYPE,
        p_customer_id  IN Accounts.CustomerID%TYPE,
        p_account_type IN Accounts.AccountType%TYPE,
        p_balance      IN Accounts.Balance%TYPE
    );

    PROCEDURE CloseAccount (
        p_account_id IN Accounts.AccountID%TYPE
    );

    FUNCTION GetTotalBalance (
        p_customer_id IN Customers.CustomerID%TYPE
    ) RETURN NUMBER;
END AccountOperations;
/

-- ---------- Package Body ----------
CREATE OR REPLACE PACKAGE BODY AccountOperations AS

    PROCEDURE OpenAccount (
        p_account_id   IN Accounts.AccountID%TYPE,
        p_customer_id  IN Accounts.CustomerID%TYPE,
        p_account_type IN Accounts.AccountType%TYPE,
        p_balance      IN Accounts.Balance%TYPE
    ) AS
    BEGIN
        INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
        VALUES (p_account_id, p_customer_id, p_account_type, p_balance, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Account ' || p_account_id
                             || ' opened for Customer ' || p_customer_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: Account ID ' || p_account_id || ' already exists.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
    END OpenAccount;

    PROCEDURE CloseAccount (
        p_account_id IN Accounts.AccountID%TYPE
    ) AS
        v_balance Accounts.Balance%TYPE;
        e_nonzero_balance EXCEPTION;
    BEGIN
        SELECT Balance INTO v_balance
        FROM   Accounts
        WHERE  AccountID = p_account_id;

        IF v_balance != 0 THEN
            RAISE e_nonzero_balance;
        END IF;

        DELETE FROM Accounts WHERE AccountID = p_account_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Account ' || p_account_id || ' closed successfully.');

    EXCEPTION
        WHEN e_nonzero_balance THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: Account ' || p_account_id
                                 || ' cannot be closed. Balance is ' || v_balance);
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: Account ID ' || p_account_id || ' not found.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
    END CloseAccount;

    FUNCTION GetTotalBalance (
        p_customer_id IN Customers.CustomerID%TYPE
    ) RETURN NUMBER AS
        v_total NUMBER := 0;
    BEGIN
        SELECT NVL(SUM(Balance), 0) INTO v_total
        FROM   Accounts
        WHERE  CustomerID = p_customer_id;
        RETURN v_total;
    END GetTotalBalance;

END AccountOperations;
/

-- Test
BEGIN
    AccountOperations.OpenAccount(50, 1, 'Savings', 2000);
    DBMS_OUTPUT.PUT_LINE('Total balance for Customer 1: $'
                         || AccountOperations.GetTotalBalance(1));
    -- Cannot close account with balance > 0
    AccountOperations.CloseAccount(50);
END;
/
