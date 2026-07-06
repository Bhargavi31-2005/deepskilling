public class SortDemo {

    // Bubble Sort - O(n^2)
    public static void bubbleSort(Order[] orders) {
        int n = orders.length;
        for (int i = 0; i < n - 1; i++) {
            boolean swapped = false;
            for (int j = 0; j < n - 1 - i; j++) {
                if (orders[j].getTotalPrice() > orders[j + 1].getTotalPrice()) {
                    Order temp = orders[j];
                    orders[j] = orders[j + 1];
                    orders[j + 1] = temp;
                    swapped = true;
                }
            }
            if (!swapped) break; // already sorted, stop early
        }
    }

    // Quick Sort - average O(n log n)
    public static void quickSort(Order[] orders, int low, int high) {
        if (low < high) {
            int pivotIndex = partition(orders, low, high);
            quickSort(orders, low, pivotIndex - 1);
            quickSort(orders, pivotIndex + 1, high);
        }
    }

    private static int partition(Order[] orders, int low, int high) {
        double pivot = orders[high].getTotalPrice();
        int i = low - 1;

        for (int j = low; j < high; j++) {
            if (orders[j].getTotalPrice() <= pivot) {
                i++;
                Order temp = orders[i];
                orders[i] = orders[j];
                orders[j] = temp;
            }
        }
        Order temp = orders[i + 1];
        orders[i + 1] = orders[high];
        orders[high] = temp;

        return i + 1;
    }

    private static void printOrders(Order[] orders) {
        for (Order o : orders) {
            System.out.println(o);
        }
    }

    public static void main(String[] args) {
        Order[] bubbleOrders = {
            new Order(1, "Alice", 250.00),
            new Order(2, "Bob", 75.50),
            new Order(3, "Charlie", 500.00),
            new Order(4, "Diana", 120.25),
            new Order(5, "Evan", 30.00)
        };

        Order[] quickOrders = bubbleOrders.clone();

        System.out.println("--- Before sorting ---");
        printOrders(bubbleOrders);

        bubbleSort(bubbleOrders);
        System.out.println("\n--- After Bubble Sort (by totalPrice) ---");
        printOrders(bubbleOrders);

        quickSort(quickOrders, 0, quickOrders.length - 1);
        System.out.println("\n--- After Quick Sort (by totalPrice) ---");
        printOrders(quickOrders);
    }
}
