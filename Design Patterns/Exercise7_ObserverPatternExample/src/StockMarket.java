import java.util.ArrayList;
import java.util.List;

public class StockMarket implements Stock {
    private final List<Observer> observers = new ArrayList<>();
    private String stockSymbol;
    private double price;

    @Override
    public void registerObserver(Observer observer) {
        observers.add(observer);
    }

    @Override
    public void deregisterObserver(Observer observer) {
        observers.remove(observer);
    }

    @Override
    public void notifyObservers() {
        for (Observer observer : observers) {
            observer.update(stockSymbol, price);
        }
    }

    public void setStockPrice(String stockSymbol, double price) {
        this.stockSymbol = stockSymbol;
        this.price = price;
        notifyObservers();
    }
}
