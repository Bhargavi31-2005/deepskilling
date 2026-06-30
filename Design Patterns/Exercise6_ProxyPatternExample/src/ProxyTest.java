public class ProxyTest {
    public static void main(String[] args) {
        Image image = new ProxyImage("photo1.jpg");

        // Image is loaded from remote server only on first display call
        System.out.println("First call:");
        image.display();

        // Image is loaded from cache on subsequent calls
        System.out.println("Second call:");
        image.display();
    }
}
