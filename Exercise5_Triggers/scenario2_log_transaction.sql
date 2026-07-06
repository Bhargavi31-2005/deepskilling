-- ============================================================
-- Exercise 5 - Scenario 2: LogTransaction
-- Inserts an audit record into AuditLog every time a new
-- transaction is inserted into the Transactions table.
--
-- Pre-requisite: AuditLog table must exist (see schema.sql).
-- ============================================================

CREATE OR REPLACE TRIGGER LogTransaction
    AFTER INSERT ON Transactions
    FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (TransactionID, AccountID, Amount, TransactionType, LogDate)
    VALUES (:NEW.TransactionID, :NEW.AccountID, :NEW.Amount, :NEW.TransactionType, SYSDATE);
END LogTransaction;
/

-- Test
INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (10, 1, SYSDATE, 500, 'Deposit');
COMMIT;

SELECT * FROM AuditLog;
