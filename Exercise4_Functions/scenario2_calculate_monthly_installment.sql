-- ============================================================
-- Exercise 4 - Scenario 2: CalculateMonthlyInstallment
-- Calculates EMI (Equated Monthly Installment) using the
-- standard loan amortisation formula:
--
--   EMI = P * r * (1+r)^n / ((1+r)^n - 1)
--
-- Where:
--   P = principal loan amount
--   r = monthly interest rate (annual rate / 12 / 100)
--   n = total number of months (years * 12)
-- ============================================================

CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment (
    p_loan_amount   IN NUMBER,
    p_interest_rate IN NUMBER,   -- Annual rate in percent (e.g. 5 for 5%)
    p_duration_years IN NUMBER   -- Duration in years
) RETURN NUMBER AS
    v_monthly_rate NUMBER;
    v_months       NUMBER;
    v_emi          NUMBER;
BEGIN
    v_monthly_rate := p_interest_rate / (12 * 100);
    v_months       := p_duration_years * 12;

    IF v_monthly_rate = 0 THEN
        -- Zero-interest loan: simple division
        v_emi := p_loan_amount / v_months;
    ELSE
        v_emi := p_loan_amount
                 * v_monthly_rate
                 * POWER(1 + v_monthly_rate, v_months)
                 / (POWER(1 + v_monthly_rate, v_months) - 1);
    END IF;

    RETURN ROUND(v_emi, 2);
END CalculateMonthlyInstallment;
/

-- Test
BEGIN
    DBMS_OUTPUT.PUT_LINE('Monthly installment: $'
        || CalculateMonthlyInstallment(5000, 5, 5));
END;
/
