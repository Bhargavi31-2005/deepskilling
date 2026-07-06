public class CustomerService {
    private final CustomerRepository customerRepository;

    // Constructor injection: the dependency is provided from the outside
    public CustomerService(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    public String getCustomerName(String id) {
        return customerRepository.findCustomerById(id);
    }
}
