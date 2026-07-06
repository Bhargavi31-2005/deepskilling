-- ============================================================
-- Exercise 6 - Scenario 3: UpdateLoanInterestRates
-- Explicit cursor that fetches all loans and updates interest
-- rates based on the new policy:
--   LoanAmount < 5000  -> InterestRate = 6%
--   LoanAmount < 10000 -> InterestRate = 5%
--   LoanAmount >= 10000 -> InterestRate = 4%
-- ============================================================

DECLARE
    CURSOR UpdateLoanInterestRates IS
        SELECT LoanID, LoanAmount, InterestRate
        FROM   Loans
        FOR UPDATE OF InterestRate;

    v_new_rate Loans.InterestRate%TYPE;
BEGIN
    FOR rec IN UpdateLoanInterestRates LOOP
        IF rec.LoanAmount < 5000 THEN
            v_new_rate := 6;
        ELSIF rec.LoanAmount < 10000 THEN
            v_new_rate := 5;
        ELSE
            v_new_rate := 4;
        END IF;

        UPDATE Loans
        SET    InterestRate = v_new_rate
        WHERE  CURRENT OF UpdateLoanInterestRates;

        DBMS_OUTPUT.PUT_LINE('Loan ID: ' || rec.LoanID
                             || ' | Amount: ' || rec.LoanAmount
                             || ' | Old Rate: ' || rec.InterestRate || '%'
                             || ' | New Rate: ' || v_new_rate || '%');
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Loan interest rate update complete.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/
