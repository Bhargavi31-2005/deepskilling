-- ============================================================
-- Exercise 3 - Scenario 1: ProcessMonthlyInterest
-- Apply 1% monthly interest to all Savings accounts.
-- ============================================================

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest AS
    v_rows_updated NUMBER := 0;
BEGIN
    UPDATE Accounts
    SET    Balance       = Balance * 1.01,
           LastModified  = SYSDATE
    WHERE  AccountType   = 'Savings';

    v_rows_updated := SQL%ROWCOUNT;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Monthly interest applied to '
                         || v_rows_updated || ' savings account(s).');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END ProcessMonthlyInterest;
/

-- Execute
BEGIN
    ProcessMonthlyInterest;
END;
/
