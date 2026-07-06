public class StrategyTest {
    public static void main(String[] args) {
        PaymentContext context = new PaymentContext();

        context.setPaymentStrategy(new CreditCardPayment("1234567812345678"));
        context.executePayment(150.00);

        context.setPaymentStrategy(new PayPalPayment("user@example.com"));
        context.executePayment(75.50);
    }
}
