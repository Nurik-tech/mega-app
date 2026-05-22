import 'package:flutter/material.dart';
import '/models/owned_stock.dart';
import '/services/stock_api_service.dart';
import '../news/news_feed_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final StockApiService apiService = StockApiService();

  // Your portfolio
  final List<OwnedStock> portfolio = [];

  // Stocks to show on dashboard
  final List<String> stockSymbols = ['AAPL', 'GOOGL', 'TSLA', 'AMZN'];

  // Store live prices here
  Map<String, double> livePrices = {};

  bool isLoadingPrices = false;

  @override
  void initState() {
    super.initState();
    fetchLivePrices();
  }

  Future<void> fetchLivePrices() async {
    setState(() {
      isLoadingPrices = true;
    });

    Map<String, double> prices = {};
    for (final symbol in stockSymbols) {
      final price = await apiService.fetchStockPrice(symbol);
      if (price != null) prices[symbol] = price;
    }

    setState(() {
      livePrices = prices;
      isLoadingPrices = false;
    });
  }

  void buyStock(String symbol, double price) {
    showDialog(
      context: context,
      builder: (ctx) {
        final qtyController = TextEditingController();
        return AlertDialog(
          title: Text('Buy $symbol'),
          content: TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final qty = int.tryParse(qtyController.text);
                if (qty != null && qty > 0) {
                  final index = portfolio.indexWhere((stock) => stock.symbol == symbol);
                  if (index >= 0) {
                    final existing = portfolio[index];
                    final totalCost =
                        existing.avgPrice * existing.quantity + price * qty;
                    final totalQty = existing.quantity + qty;
                    existing.avgPrice = totalCost / totalQty;
                    existing.quantity = totalQty;
                  } else {
                    portfolio.add(OwnedStock(
                        symbol: symbol, quantity: qty, avgPrice: price));
                  }
                  setState(() {});
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bought $qty shares of $symbol')));
                }
              },
              child: const Text('Buy'),
            ),
          ],
        );
      },
    );
  }

  void sellStock(String symbol, double price) {
    showDialog(
      context: context,
      builder: (ctx) {
        final qtyController = TextEditingController();
        return AlertDialog(
          title: Text('Sell $symbol'),
          content: TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final qty = int.tryParse(qtyController.text);
                if (qty != null && qty > 0) {
                  final index = portfolio.indexWhere((stock) => stock.symbol == symbol);
                  if (index < 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You do not own any $symbol')));
                  } else {
                    final existing = portfolio[index];
                    if (qty > existing.quantity) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              'You only own ${existing.quantity} shares of $symbol')));
                    } else {
                      existing.quantity -= qty;
                      if (existing.quantity == 0) {
                        portfolio.removeAt(index);
                      }
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sold $qty shares of $symbol')));
                    }
                  }
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Sell'),
            ),
          ],
        );
      },
    );
  }

  double get portfolioValue {
    double total = 0;
    for (final stock in portfolio) {
      final livePrice = livePrices[stock.symbol] ?? 0;
      total += livePrice * stock.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Dashboard'),
        actions: [
          IconButton(
            onPressed: fetchLivePrices,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Prices',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Updated Portfolio value section wrapped in Card
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio Value',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: isLoadingPrices
                          ? const CircularProgressIndicator()
                          : Text(
                        '\$${portfolioValue.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Text(
              'Available Stocks',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (isLoadingPrices)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Center(child: CircularProgressIndicator()),
              ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: stockSymbols.length,
                itemBuilder: (context, index) {
                  final symbol = stockSymbols[index];
                  final price = livePrices[symbol];
                  return Card(
                    child: ListTile(
                      title: Text(symbol),
                      subtitle: price != null
                          ? Text('\$${price.toStringAsFixed(2)}')
                          : const Text('Loading...'),
                      trailing: Wrap(
                        spacing: 12,
                        children: [
                          ElevatedButton(
                            onPressed: price == null ? null : () => buyStock(symbol, price),
                            child: const Text('Buy'),
                          ),
                          ElevatedButton(
                            onPressed: price == null ? null : () => sellStock(symbol, price),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Sell'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.article),
                            tooltip: 'View News',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewsFeedScreen(symbol: symbol),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(),

            const Text(
              'Your Portfolio',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Expanded(
              flex: 1,
              child: portfolio.isEmpty
                  ? const Center(child: Text('You do not own any stocks yet.'))
                  : ListView.builder(
                itemCount: portfolio.length,
                itemBuilder: (context, index) {
                  final stock = portfolio[index];
                  final livePrice = livePrices[stock.symbol] ?? 0;
                  final currentValue = livePrice * stock.quantity;
                  final profit =
                      currentValue - stock.avgPrice * stock.quantity;
                  return ListTile(
                    title: Text(stock.symbol),
                    subtitle: Text(
                        '${stock.quantity} shares @ avg \$${stock.avgPrice.toStringAsFixed(2)}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${currentValue.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text(
                          'Profit: \$${profit.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: profit >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}





