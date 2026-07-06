-- ============================================================
-- Exercise 6 - Scenario 1: GenerateMonthlyStatements
-- Explicit cursor that fetches all transactions for the current
-- month and prints a statement line for each customer.
-- ============================================================

DECLARE
    CURSOR GenerateMonthlyStatements IS
        SELECT c.CustomerID,
               c.Name,
               t.TransactionID,
               t.TransactionDate,
               t.Amount,
               t.TransactionType
        FROM   Transactions t
        JOIN   Accounts     a ON a.AccountID    = t.AccountID
        JOIN   Customers    c ON c.CustomerID   = a.CustomerID
        WHERE  EXTRACT(MONTH FROM t.TransactionDate) = EXTRACT(MONTH FROM SYSDATE)
          AND  EXTRACT(YEAR  FROM t.TransactionDate) = EXTRACT(YEAR  FROM SYSDATE)
        ORDER BY c.CustomerID, t.TransactionDate;

    v_last_customer Customers.CustomerID%TYPE := -1;
BEGIN
    FOR rec IN GenerateMonthlyStatements LOOP
        -- Print header when customer changes
        IF rec.CustomerID != v_last_customer THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('=== Monthly Statement for: '
                                 || rec.Name || ' (ID: ' || rec.CustomerID || ') ===');
            v_last_customer := rec.CustomerID;
        END IF;

        DBMS_OUTPUT.PUT_LINE('  TxnID: ' || rec.TransactionID
                             || ' | Date: ' || TO_CHAR(rec.TransactionDate, 'DD-MON-YYYY')
                             || ' | Type: ' || rec.TransactionType
                             || ' | Amount: $' || rec.Amount);
    END LOOP;

    IF v_last_customer = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No transactions found for the current month.');
    END IF;
END;
/
