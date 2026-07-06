-- ============================================================
-- Exercise 1 - Scenario 1: Age-Based Loan Interest Discount
-- Apply a 1% discount on loan interest rates for customers
-- who are above 60 years old.
-- ============================================================

DECLARE
    CURSOR c_customers IS
        SELECT c.CustomerID,
               c.Name,
               FLOOR(MONTHS_BETWEEN(SYSDATE, c.DOB) / 12) AS Age
        FROM   Customers c;

    v_age Customers.CustomerID%TYPE;
BEGIN
    FOR rec IN c_customers LOOP
        -- Check if the customer is older than 60
        IF rec.Age > 60 THEN
            -- Apply a 1% discount to all loans belonging to this customer
            UPDATE Loans
            SET    InterestRate = InterestRate - 1
            WHERE  CustomerID = rec.CustomerID
              AND  InterestRate > 1;  -- Guard: do not push rate below 0

            DBMS_OUTPUT.PUT_LINE('Discount applied for customer: ' || rec.Name
                                 || ' (Age: ' || rec.Age || ')');
        ELSE
            DBMS_OUTPUT.PUT_LINE('No discount for: ' || rec.Name
                                 || ' (Age: ' || rec.Age || ')');
        END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Age-based discount update complete.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
