import java.util.Arrays;
import java.util.Comparator;
public class SearchDemo {

    
    public static Product linearSearch(Product[] products, String name) {
        for (Product p : products) {
            if (p.getProductName().equalsIgnoreCase(name)) {
                return p;
            }
        }
        return null;
    }

    
    public static Product binarySearch(Product[] sortedProducts, String name) {
        int low = 0;
        int high = sortedProducts.length - 1;

        while (low <= high) {
            int mid = low + (high - low) / 2;
            int cmp = sortedProducts[mid].getProductName().compareToIgnoreCase(name);

            if (cmp == 0) {
                return sortedProducts[mid];
            } else if (cmp < 0) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        return null;
    }

    public static void main(String[] args) {
        Product[] products = {
            new Product(1, "Laptop", "Electronics"),
            new Product(2, "Mouse", "Electronics"),
            new Product(3, "Desk", "Furniture"),
            new Product(4, "Chair", "Furniture"),
            new Product(5, "Monitor", "Electronics")
        };

        System.out.println("--- Linear Search ---");
        Product found = linearSearch(products, "Desk");
        System.out.println(found != null ? "Found: " + found : "Not found");

        // Binary search requires a sorted copy
        Product[] sorted = products.clone();
        Arrays.sort(sorted, Comparator.comparing(Product::getProductName, String.CASE_INSENSITIVE_ORDER));

        System.out.println("\n--- Sorted array for binary search ---");
        for (Product p : sorted) {
            System.out.println(p);
        }

        System.out.println("\n--- Binary Search ---");
        Product foundBinary = binarySearch(sorted, "Monitor");
        System.out.println(foundBinary != null ? "Found: " + foundBinary : "Not found");
    }
}
