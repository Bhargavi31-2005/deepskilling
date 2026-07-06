
public class EmployeeManagement {
    private Employee[] employees;
    private int size;

    public EmployeeManagement(int capacity) {
        employees = new Employee[capacity];
        size = 0;
    }

    // Add an employee - O(1) amortized
    public void addEmployee(Employee employee) {
        if (size == employees.length) {
            // grow the array - O(n)
            Employee[] newArray = new Employee[employees.length * 2];
            System.arraycopy(employees, 0, newArray, 0, employees.length);
            employees = newArray;
        }
        employees[size++] = employee;
        System.out.println("Added: " + employee);
    }

    // Search by employeeId - O(n)
    public Employee search(int employeeId) {
        for (int i = 0; i < size; i++) {
            if (employees[i].getEmployeeId() == employeeId) {
                return employees[i];
            }
        }
        return null;
    }

    // Traverse and print all employees - O(n)
    public void traverse() {
        for (int i = 0; i < size; i++) {
            System.out.println(employees[i]);
        }
    }

    // Delete by employeeId - O(n)
    public boolean delete(int employeeId) {
        for (int i = 0; i < size; i++) {
            if (employees[i].getEmployeeId() == employeeId) {
                System.out.println("Deleting: " + employees[i]);
                // shift subsequent elements left
                for (int j = i; j < size - 1; j++) {
                    employees[j] = employees[j + 1];
                }
                employees[size - 1] = null;
                size--;
                return true;
            }
        }
        return false;
    }

    public static void main(String[] args) {
        EmployeeManagement em = new EmployeeManagement(5);

        em.addEmployee(new Employee(1, "Alice", "Manager", 75000));
        em.addEmployee(new Employee(2, "Bob", "Developer", 65000));
        em.addEmployee(new Employee(3, "Charlie", "Designer", 60000));

        System.out.println("\n--- Traverse ---");
        em.traverse();

        System.out.println("\n--- Search id=2 ---");
        Employee found = em.search(2);
        System.out.println(found != null ? "Found: " + found : "Not found");

        System.out.println("\n--- Delete id=2 ---");
        em.delete(2);

        System.out.println("\n--- Traverse after delete ---");
        em.traverse();
    }
}
