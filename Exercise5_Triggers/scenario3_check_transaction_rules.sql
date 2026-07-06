-- ============================================================
-- Exercise 5 - Scenario 3: CheckTransactionRules
-- Before inserting a transaction, enforce:
--   1. Deposits must be a positive amount.
--   2. Withdrawals must not exceed the current account balance.
-- ============================================================

CREATE OR REPLACE TRIGGER CheckTransactionRules
    BEFORE INSERT ON Transactions
    FOR EACH ROW
DECLARE
    v_balance Accounts.Balance%TYPE;
BEGIN
    IF :NEW.TransactionType = 'Deposit' THEN
        IF :NEW.Amount <= 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Deposit amount must be positive.');
        END IF;

    ELSIF :NEW.TransactionType = 'Withdrawal' THEN
        SELECT Balance INTO v_balance
        FROM   Accounts
        WHERE  AccountID = :NEW.AccountID;

        IF :NEW.Amount > v_balance THEN
            RAISE_APPLICATION_ERROR(-20002,
                'Withdrawal of ' || :NEW.Amount
                || ' exceeds account balance of ' || v_balance || '.');
        END IF;

        IF :NEW.Amount <= 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Withdrawal amount must be positive.');
        END IF;
    END IF;
END CheckTransactionRules;
/

-- Test: valid deposit
INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (20, 1, SYSDATE, 300, 'Deposit');
COMMIT;

-- Test: invalid withdrawal (exceeds balance) - should raise error
INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (21, 1, SYSDATE, 999999, 'Withdrawal');
