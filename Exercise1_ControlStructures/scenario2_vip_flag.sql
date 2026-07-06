-- ============================================================
-- Exercise 1 - Scenario 2: Set IsVIP Flag
-- Promote customers with a balance over $10,000 to VIP status.
--
-- NOTE: Run the ALTER statement below once to add the IsVIP
--       column if it does not already exist in your schema.
-- ============================================================

-- Add IsVIP column (run once)
-- ALTER TABLE Customers ADD (IsVIP VARCHAR2(5) DEFAULT 'FALSE');

DECLARE
    CURSOR c_customers IS
        SELECT CustomerID, Name, Balance
        FROM   Customers;

    v_isVIP VARCHAR2(5);
BEGIN
    FOR rec IN c_customers LOOP
        IF rec.Balance > 10000 THEN
            v_isVIP := 'TRUE';
        ELSE
            v_isVIP := 'FALSE';
        END IF;

        UPDATE Customers
        SET    IsVIP = v_isVIP
        WHERE  CustomerID = rec.CustomerID;

        DBMS_OUTPUT.PUT_LINE('Customer: ' || rec.Name
                             || ' | Balance: ' || rec.Balance
                             || ' | IsVIP: ' || v_isVIP);
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('VIP flag update complete.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
