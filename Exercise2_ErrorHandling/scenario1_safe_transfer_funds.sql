-- ============================================================
-- Exercise 2 - Scenario 1: SafeTransferFunds
-- Transfer funds between two accounts with full error handling.
-- Rolls back the entire transaction on any failure.
-- ============================================================

CREATE OR REPLACE PROCEDURE SafeTransferFunds (
    p_from_account IN  Accounts.AccountID%TYPE,
    p_to_account   IN  Accounts.AccountID%TYPE,
    p_amount       IN  NUMBER
) AS
    v_from_balance Accounts.Balance%TYPE;
    e_insufficient_funds EXCEPTION;
    e_invalid_account    EXCEPTION;
    v_count NUMBER;
BEGIN
    -- Validate source account exists
    SELECT COUNT(*) INTO v_count FROM Accounts WHERE AccountID = p_from_account;
    IF v_count = 0 THEN RAISE e_invalid_account; END IF;

    -- Validate destination account exists
    SELECT COUNT(*) INTO v_count FROM Accounts WHERE AccountID = p_to_account;
    IF v_count = 0 THEN RAISE e_invalid_account; END IF;

    -- Lock and read the source balance
    SELECT Balance INTO v_from_balance
    FROM   Accounts
    WHERE  AccountID = p_from_account
    FOR UPDATE;

    -- Check sufficient funds
    IF v_from_balance < p_amount THEN
        RAISE e_insufficient_funds;
    END IF;

    -- Debit source
    UPDATE Accounts
    SET    Balance = Balance - p_amount,
           LastModified = SYSDATE
    WHERE  AccountID = p_from_account;

    -- Credit destination
    UPDATE Accounts
    SET    Balance = Balance + p_amount,
           LastModified = SYSDATE
    WHERE  AccountID = p_to_account;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transfer of ' || p_amount
                         || ' from Account ' || p_from_account
                         || ' to Account ' || p_to_account
                         || ' successful.');

EXCEPTION
    WHEN e_insufficient_funds THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: Insufficient funds in Account ' || p_from_account);

    WHEN e_invalid_account THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: One or both account IDs are invalid.');

    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: Unexpected error during transfer - ' || SQLERRM);
END SafeTransferFunds;
/

-- Test
BEGIN
    SafeTransferFunds(1, 2, 200);   -- Valid transfer
    SafeTransferFunds(1, 2, 99999); -- Should fail: insufficient funds
END;
/
