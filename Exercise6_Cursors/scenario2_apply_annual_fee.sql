-- ============================================================
-- Exercise 6 - Scenario 2: ApplyAnnualFee
-- Explicit cursor that deducts an annual maintenance fee of $50
-- from every account. Skips accounts whose balance would fall
-- below zero after the deduction.
-- ============================================================

DECLARE
    v_annual_fee CONSTANT NUMBER := 50;

    CURSOR ApplyAnnualFee IS
        SELECT AccountID, Balance
        FROM   Accounts
        FOR UPDATE OF Balance;   -- Lock rows for update
BEGIN
    FOR rec IN ApplyAnnualFee LOOP
        IF rec.Balance >= v_annual_fee THEN
            UPDATE Accounts
            SET    Balance      = Balance - v_annual_fee,
                   LastModified = SYSDATE
            WHERE  CURRENT OF ApplyAnnualFee;

            DBMS_OUTPUT.PUT_LINE('Annual fee deducted from Account '
                                 || rec.AccountID
                                 || '. New balance: '
                                 || (rec.Balance - v_annual_fee));
        ELSE
            DBMS_OUTPUT.PUT_LINE('Skipped Account ' || rec.AccountID
                                 || ': balance (' || rec.Balance
                                 || ') insufficient to cover annual fee.');
        END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Annual fee processing complete.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/
