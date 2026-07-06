-- ============================================================
-- Exercise 2 - Scenario 2: UpdateSalary
-- Increase an employee's salary by a given percentage.
-- Handles the case where the employee ID does not exist.
-- ============================================================

CREATE OR REPLACE PROCEDURE UpdateSalary (
    p_employee_id      IN Employees.EmployeeID%TYPE,
    p_increase_percent IN NUMBER
) AS
    v_current_salary Employees.Salary%TYPE;
    e_emp_not_found  EXCEPTION;
    v_count          NUMBER;
BEGIN
    -- Check employee exists
    SELECT COUNT(*) INTO v_count
    FROM   Employees
    WHERE  EmployeeID = p_employee_id;

    IF v_count = 0 THEN
        RAISE e_emp_not_found;
    END IF;

    -- Fetch current salary
    SELECT Salary INTO v_current_salary
    FROM   Employees
    WHERE  EmployeeID = p_employee_id;

    -- Apply increase
    UPDATE Employees
    SET    Salary = Salary * (1 + p_increase_percent / 100)
    WHERE  EmployeeID = p_employee_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Salary updated for Employee ID ' || p_employee_id
                         || ': ' || v_current_salary
                         || ' -> ' || ROUND(v_current_salary * (1 + p_increase_percent / 100), 2));

EXCEPTION
    WHEN e_emp_not_found THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Employee ID ' || p_employee_id || ' does not exist.');

    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END UpdateSalary;
/

-- Test
BEGIN
    UpdateSalary(1, 10);   -- Valid: 10% raise for Employee 1
    UpdateSalary(99, 10);  -- Should fail: employee 99 not found
END;
/
