public class ObserverTest {
    public static void main(String[] args) {
        StockMarket stockMarket = new StockMarket();

        Observer mobileApp = new MobileApp();
        Observer webApp = new WebApp();

        stockMarket.registerObserver(mobileApp);
        stockMarket.registerObserver(webApp);

        stockMarket.setStockPrice("AAPL", 195.32);
        stockMarket.setStockPrice("GOOG", 2750.10);

        stockMarket.deregisterObserver(webApp);
        System.out.println("WebApp unsubscribed.");
        stockMarket.setStockPrice("AAPL", 197.80);
    }
}
