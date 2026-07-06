-- ============================================================
-- Exercise 7 - Scenario 2: EmployeeManagement Package
-- Groups employee-related operations:
--   - HireEmployee      : insert a new employee record
--   - UpdateEmployee    : update position and salary
--   - GetAnnualSalary   : calculate annual salary (salary * 12)
-- ============================================================

-- ---------- Package Specification ----------
CREATE OR REPLACE PACKAGE EmployeeManagement AS
    PROCEDURE HireEmployee (
        p_employee_id IN Employees.EmployeeID%TYPE,
        p_name        IN Employees.Name%TYPE,
        p_position    IN Employees.Position%TYPE,
        p_salary      IN Employees.Salary%TYPE,
        p_department  IN Employees.Department%TYPE,
        p_hire_date   IN Employees.HireDate%TYPE
    );

    PROCEDURE UpdateEmployee (
        p_employee_id IN Employees.EmployeeID%TYPE,
        p_position    IN Employees.Position%TYPE,
        p_salary      IN Employees.Salary%TYPE
    );

    FUNCTION GetAnnualSalary (
        p_employee_id IN Employees.EmployeeID%TYPE
    ) RETURN NUMBER;
END EmployeeManagement;
/

-- ---------- Package Body ----------
CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS

    PROCEDURE HireEmployee (
        p_employee_id IN Employees.EmployeeID%TYPE,
        p_name        IN Employees.Name%TYPE,
        p_position    IN Employees.Position%TYPE,
        p_salary      IN Employees.Salary%TYPE,
        p_department  IN Employees.Department%TYPE,
        p_hire_date   IN Employees.HireDate%TYPE
    ) AS
    BEGIN
        INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
        VALUES (p_employee_id, p_name, p_position, p_salary, p_department, p_hire_date);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Employee hired: ' || p_name);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: Employee ID ' || p_employee_id || ' already exists.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
    END HireEmployee;

    PROCEDURE UpdateEmployee (
        p_employee_id IN Employees.EmployeeID%TYPE,
        p_position    IN Employees.Position%TYPE,
        p_salary      IN Employees.Salary%TYPE
    ) AS
    BEGIN
        UPDATE Employees
        SET    Position = p_position,
               Salary   = p_salary
        WHERE  EmployeeID = p_employee_id;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: Employee ID ' || p_employee_id || ' not found.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Employee ' || p_employee_id || ' updated.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
    END UpdateEmployee;

    FUNCTION GetAnnualSalary (
        p_employee_id IN Employees.EmployeeID%TYPE
    ) RETURN NUMBER AS
        v_salary Employees.Salary%TYPE;
    BEGIN
        SELECT Salary INTO v_salary
        FROM   Employees
        WHERE  EmployeeID = p_employee_id;
        RETURN v_salary * 12;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: Employee ID ' || p_employee_id || ' not found.');
            RETURN NULL;
    END GetAnnualSalary;

END EmployeeManagement;
/

-- Test
BEGIN
    EmployeeManagement.HireEmployee(30, 'Carol King', 'Analyst', 50000, 'Finance', SYSDATE);
    EmployeeManagement.UpdateEmployee(30, 'Senior Analyst', 55000);
    DBMS_OUTPUT.PUT_LINE('Annual Salary: $' || EmployeeManagement.GetAnnualSalary(30));
END;
/
