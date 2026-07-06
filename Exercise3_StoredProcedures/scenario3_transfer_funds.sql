-- ============================================================
-- Exercise 3 - Scenario 3: TransferFunds
-- Transfer a specified amount between two accounts.
-- Verifies sufficient balance before transferring.
-- ============================================================

CREATE OR REPLACE PROCEDURE TransferFunds (
    p_from_account IN  Accounts.AccountID%TYPE,
    p_to_account   IN  Accounts.AccountID%TYPE,
    p_amount       IN  NUMBER
) AS
    v_balance Accounts.Balance%TYPE;
    e_insufficient_funds EXCEPTION;
BEGIN
    -- Lock and read source balance
    SELECT Balance INTO v_balance
    FROM   Accounts
    WHERE  AccountID = p_from_account
    FOR UPDATE;

    IF v_balance < p_amount THEN
        RAISE e_insufficient_funds;
    END IF;

    -- Debit
    UPDATE Accounts
    SET    Balance = Balance - p_amount,
           LastModified = SYSDATE
    WHERE  AccountID = p_from_account;

    -- Credit
    UPDATE Accounts
    SET    Balance = Balance + p_amount,
           LastModified = SYSDATE
    WHERE  AccountID = p_to_account;

    -- Log the transactions
    INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
    VALUES (Transactions_SEQ.NEXTVAL, p_from_account, SYSDATE, p_amount, 'Withdrawal');

    INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
    VALUES (Transactions_SEQ.NEXTVAL, p_to_account, SYSDATE, p_amount, 'Deposit');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transferred ' || p_amount
                         || ' from Account ' || p_from_account
                         || ' to Account ' || p_to_account);

EXCEPTION
    WHEN e_insufficient_funds THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: Insufficient balance in Account ' || p_from_account);

    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: Account not found.');

    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END TransferFunds;
/

-- Create sequence for TransactionID (run once)
-- CREATE SEQUENCE Transactions_SEQ START WITH 100 INCREMENT BY 1;

-- Test
BEGIN
    TransferFunds(1, 2, 100);   -- Valid
    TransferFunds(2, 1, 99999); -- Should fail: insufficient funds
END;
/
