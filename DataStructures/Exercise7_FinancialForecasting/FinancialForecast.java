import java.util.HashMap;
import java.util.Map;
public class FinancialForecast {

    
    public static double futureValueRecursive(double presentValue, double growthRate, int years) {
        if (years == 0) {
            return presentValue;
        }
        return futureValueRecursive(presentValue, growthRate, years - 1) * (1 + growthRate);
    }

    
    public static double futureValueMemoized(double presentValue, double growthRate, int years,
                                              Map<Integer, Double> memo) {
        if (years == 0) {
            return presentValue;
        }
        if (memo.containsKey(years)) {
            return memo.get(years);
        }
        double result = futureValueMemoized(presentValue, growthRate, years - 1, memo) * (1 + growthRate);
        memo.put(years, result);
        return result;
    }

    
    public static double futureValueIterative(double presentValue, double growthRate, int years) {
        double value = presentValue;
        for (int i = 0; i < years; i++) {
            value *= (1 + growthRate);
        }
        return value;
    }

    public static void main(String[] args) {
        double presentValue = 10000.0;
        double growthRate = 0.05; // 5% annual growth
        int years = 10;

        double recursiveResult = futureValueRecursive(presentValue, growthRate, years);
        System.out.printf("Recursive future value after %d years: %.2f%n", years, recursiveResult);

        Map<Integer, Double> memo = new HashMap<>();
        double memoizedResult = futureValueMemoized(presentValue, growthRate, years, memo);
        System.out.printf("Memoized future value after %d years: %.2f%n", years, memoizedResult);

        double iterativeResult = futureValueIterative(presentValue, growthRate, years);
        System.out.printf("Iterative future value after %d years: %.2f%n", years, iterativeResult);
    }
}
