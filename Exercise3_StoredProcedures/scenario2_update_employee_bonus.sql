-- ============================================================
-- Exercise 3 - Scenario 2: UpdateEmployeeBonus
-- Add a bonus percentage to the salary of all employees in a
-- given department.
-- ============================================================

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
    p_department    IN Employees.Department%TYPE,
    p_bonus_percent IN NUMBER
) AS
    v_rows_updated NUMBER := 0;
BEGIN
    UPDATE Employees
    SET    Salary = Salary * (1 + p_bonus_percent / 100)
    WHERE  Department = p_department;

    v_rows_updated := SQL%ROWCOUNT;

    IF v_rows_updated = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No employees found in department: ' || p_department);
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Bonus of ' || p_bonus_percent
                             || '% applied to ' || v_rows_updated
                             || ' employee(s) in department: ' || p_department);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END UpdateEmployeeBonus;
/

-- Test
BEGIN
    UpdateEmployeeBonus('IT', 15);   -- 15% bonus for IT department
    UpdateEmployeeBonus('Finance', 10); -- No employees in Finance
END;
/
