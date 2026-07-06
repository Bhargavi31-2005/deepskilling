-- ============================================================
-- Exercise 4 - Scenario 1: CalculateAge
-- Returns the age in full years given a date of birth.
-- ============================================================

CREATE OR REPLACE FUNCTION CalculateAge (
    p_dob IN DATE
) RETURN NUMBER AS
BEGIN
    RETURN FLOOR(MONTHS_BETWEEN(SYSDATE, p_dob) / 12);
END CalculateAge;
/

-- Test
DECLARE
    v_age NUMBER;
BEGIN
    SELECT CalculateAge(DOB) INTO v_age
    FROM   Customers
    WHERE  CustomerID = 1;

    DBMS_OUTPUT.PUT_LINE('Age of Customer 1: ' || v_age || ' years');
END;
/
