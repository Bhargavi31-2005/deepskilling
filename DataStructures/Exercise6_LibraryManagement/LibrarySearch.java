import java.util.Arrays;
import java.util.Comparator;
public class LibrarySearch {

    
    public static Book linearSearchByTitle(Book[] books, String title) {
        for (Book b : books) {
            if (b.getTitle().equalsIgnoreCase(title)) {
                return b;
            }
        }
        return null;
    }

    
    public static Book binarySearchByTitle(Book[] sortedBooks, String title) {
        int low = 0;
        int high = sortedBooks.length - 1;

        while (low <= high) {
            int mid = low + (high - low) / 2;
            int cmp = sortedBooks[mid].getTitle().compareToIgnoreCase(title);

            if (cmp == 0) {
                return sortedBooks[mid];
            } else if (cmp < 0) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        return null;
    }

    public static void main(String[] args) {
        Book[] books = {
            new Book(1, "Clean Code", "Robert C. Martin"),
            new Book(2, "The Pragmatic Programmer", "Andrew Hunt"),
            new Book(3, "Effective Java", "Joshua Bloch"),
            new Book(4, "Design Patterns", "Erich Gamma"),
            new Book(5, "Introduction to Algorithms", "Thomas Cormen")
        };

        System.out.println("--- Linear Search ---");
        Book foundLinear = linearSearchByTitle(books, "Effective Java");
        System.out.println(foundLinear != null ? "Found: " + foundLinear : "Not found");

        Book[] sorted = books.clone();
        Arrays.sort(sorted, Comparator.comparing(Book::getTitle, String.CASE_INSENSITIVE_ORDER));

        System.out.println("\n--- Sorted by title ---");
        for (Book b : sorted) {
            System.out.println(b);
        }

        System.out.println("\n--- Binary Search ---");
        Book foundBinary = binarySearchByTitle(sorted, "Design Patterns");
        System.out.println(foundBinary != null ? "Found: " + foundBinary : "Not found");
    }
}
