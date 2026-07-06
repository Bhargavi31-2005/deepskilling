-- ============================================================
-- Exercise 4 - Scenario 3: HasSufficientBalance
-- Returns 1 (TRUE) if the account has at least p_amount,
-- otherwise returns 0 (FALSE).
-- Note: Oracle PL/SQL does not support BOOLEAN as a SQL return
-- type, so NUMBER (1/0) is used for compatibility with SQL queries.
-- ============================================================

CREATE OR REPLACE FUNCTION HasSufficientBalance (
    p_account_id IN Accounts.AccountID%TYPE,
    p_amount     IN NUMBER
) RETURN NUMBER AS
    v_balance Accounts.Balance%TYPE;
BEGIN
    SELECT Balance INTO v_balance
    FROM   Accounts
    WHERE  AccountID = p_account_id;

    IF v_balance >= p_amount THEN
        RETURN 1;  -- TRUE
    ELSE
        RETURN 0;  -- FALSE
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Account ID ' || p_account_id || ' not found.');
        RETURN 0;
END HasSufficientBalance;
/

-- Test
BEGIN
    IF HasSufficientBalance(1, 500) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Account 1 has sufficient balance for $500.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Account 1 does NOT have sufficient balance for $500.');
    END IF;
END;
/
