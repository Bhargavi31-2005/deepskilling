import java.util.HashMap;
import java.util.Map;

public class CustomerRepositoryImpl implements CustomerRepository {
    private final Map<String, String> customers = new HashMap<>();

    public CustomerRepositoryImpl() {
        customers.put("C001", "Alice Smith");
        customers.put("C002", "Bob Johnson");
    }

    @Override
    public String findCustomerById(String id) {
        return customers.getOrDefault(id, "Customer not found");
    }
}
