public class AdapterTest {
    public static void main(String[] args) {
        PaymentProcessor payPalProcessor = new PayPalAdapter(new PayPalGateway());
        payPalProcessor.processPayment(50.00);

        PaymentProcessor stripeProcessor = new StripeAdapter(new StripeGateway());
        stripeProcessor.processPayment(50.00);
    }
}
