import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/yahoo_finance.dart';  // Adjust path if needed

class StockDetailScreen extends StatefulWidget {
  final String symbol;

  const StockDetailScreen({super.key, required this.symbol});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  late Future<Map<String, dynamic>> _stockDataFuture;

  @override
  void initState() {
    super.initState();
    _stockDataFuture = YahooFinanceService.fetchStockDetails(widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Details: ${widget.symbol}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _stockDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading spinner
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!;

          // Extract fields safely from the API response
          final price = data['regularMarketPrice'] ?? 'N/A';
          final change = data['regularMarketChange'] ?? 0;
          final changePercent = data['regularMarketChangePercent'] ?? 0;
          final marketCap = data['marketCap'] ?? 'N/A';
          final name = data['shortName'] ?? widget.symbol;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('\$${price.toString()}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    if (change >= 0)
                      Icon(Icons.arrow_upward, color: Colors.green)
                    else
                      Icon(Icons.arrow_downward, color: Colors.red),
                    Text(
                      ' ${change.toStringAsFixed(2)} (${changePercent.toStringAsFixed(2)}%)',
                      style: TextStyle(
                          fontSize: 16,
                          color: change >= 0 ? Colors.green : Colors.red),
                    )
                  ],
                ),
                const Divider(height: 32),
                Text('Market Cap: \$${marketCap.toString()}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),

                // Add more stock details below as you want, for example:
                // - Volume
                // - 52 Week High / Low
                // - PE Ratio
                // - Dividend Yield
                // Just add and extract similarly from data map.

                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/search'); // or wherever
                    },
                    child: const Text('Back to Search'),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
