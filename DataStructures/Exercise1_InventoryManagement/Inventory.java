import java.util.HashMap;
import java.util.Map;
public class Inventory {
    private Map<Integer, Product> products;

    public Inventory() {
        products = new HashMap<>();
    }
    public void addProduct(Product product) {
        products.put(product.getProductId(), product);
        System.out.println("Added: " + product);
    }
    public void updateProduct(int productId, String name, int quantity, double price) {
        Product product = products.get(productId);
        if (product != null) {
            product.setProductName(name);
            product.setQuantity(quantity);
            product.setPrice(price);
            System.out.println("Updated: " + product);
        } else {
            System.out.println("Product with id " + productId + " not found.");
        }
    }
    public void deleteProduct(int productId) {
        Product removed = products.remove(productId);
        if (removed != null) {
            System.out.println("Deleted: " + removed);
        } else {
            System.out.println("Product with id " + productId + " not found.");
        }
    }
    public Product getProduct(int productId) {
        return products.get(productId);
    }

    public void printAll() {
        for (Product p : products.values()) {
            System.out.println(p);
        }
    }

    public static void main(String[] args) {
        Inventory inventory = new Inventory();

        inventory.addProduct(new Product(101, "Laptop", 10, 750.00));
        inventory.addProduct(new Product(102, "Mouse", 50, 15.50));
        inventory.addProduct(new Product(103, "Keyboard", 30, 25.00));

        System.out.println("\n--- All products ---");
        inventory.printAll();

        System.out.println("\n--- Update product 102 ---");
        inventory.updateProduct(102, "Wireless Mouse", 40, 19.99);

        System.out.println("\n--- Delete product 103 ---");
        inventory.deleteProduct(103);

        System.out.println("\n--- Final inventory ---");
        inventory.printAll();
    }
}
