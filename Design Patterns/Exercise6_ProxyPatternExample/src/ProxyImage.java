public class ProxyImage implements Image {
    private final String fileName;
    private RealImage realImage; // lazily initialized, acts as a cache

    public ProxyImage(String fileName) {
        this.fileName = fileName;
    }

    @Override
    public void display() {
        if (realImage == null) {
            realImage = new RealImage(fileName); // loaded only when needed
        } else {
            System.out.println("Using cached image for " + fileName);
        }
        realImage.display();
    }
}
