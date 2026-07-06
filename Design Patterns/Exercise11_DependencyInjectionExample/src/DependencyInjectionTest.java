public class DependencyInjectionTest {
    public static void main(String[] args) {
        // Dependency created externally and injected via constructor
        CustomerRepository repository = new CustomerRepositoryImpl();
        CustomerService service = new CustomerService(repository);

        System.out.println("C001 -> " + service.getCustomerName("C001"));
        System.out.println("C002 -> " + service.getCustomerName("C002"));
        System.out.println("C999 -> " + service.getCustomerName("C999"));
    }
}
