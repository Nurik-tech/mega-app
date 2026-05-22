import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final List<Map<String, dynamic>> portfolio = [
    {
      'symbol': 'AAPL',
      'shares': 10,
      'buyPrice': 145.0,
      'currentPrice': 180.0,
    },
    {
      'symbol': 'TSLA',
      'shares': 5,
      'buyPrice': 700.0,
      'currentPrice': 610.0,
    },
  ];

  final currencyFormatter = NumberFormat.simpleCurrency();

  double get totalInvestment => portfolio.fold(
      0, (sum, item) => sum + (item['shares'] * item['buyPrice']));

  double get currentValue => portfolio.fold(
      0, (sum, item) => sum + (item['shares'] * item['currentPrice']));

  double get gainLoss => currentValue - totalInvestment;

  double _percent(double value, double base) =>
      base == 0 ? 0 : (value / base) * 100;

  Future<void> _updateCurrentPrices() async {
    // Mock price update (In real app, call your API)
    setState(() {
      for (var stock in portfolio) {
        // Simulate price change ±10%
        final base = stock['currentPrice'] as double;
        final changePercent = (0.9 + (0.2 * ( DateTime.now().second % 10) / 10));
        stock['currentPrice'] = (base * changePercent).clamp(0, double.infinity);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Update prices every 10 seconds (demo)
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 10));
      if (!mounted) return false;
      await _updateCurrentPrices();
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gainLossPercent = _percent(gainLoss, totalInvestment);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Portfolio"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Summary Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryTile(
                    icon: Icons.account_balance_wallet_outlined,
                    label: "Investment",
                    value: currencyFormatter.format(totalInvestment),
                    color: Colors.blueGrey,
                  ),
                  _summaryTile(
                    icon: Icons.show_chart,
                    label: "Value",
                    value: currencyFormatter.format(currentValue),
                    color: Colors.teal,
                  ),
                  _summaryTile(
                    icon: gainLoss >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    label: "Gain/Loss",
                    value:
                    "${gainLoss >= 0 ? '+' : '-'}${currencyFormatter.format(gainLoss.abs())} (${gainLossPercent.toStringAsFixed(2)}%)",
                    color: gainLoss >= 0 ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Portfolio Stocks List
            Expanded(
              child: portfolio.isEmpty
                  ? Center(
                child: Text(
                  "Your portfolio is empty",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
                  : ListView.separated(
                itemCount: portfolio.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final stock = portfolio[index];
                  final value = stock['shares'] * stock['currentPrice'];
                  final profit =
                      (stock['currentPrice'] - stock['buyPrice']) * stock['shares'];
                  final profitPercent =
                  _percent(profit, stock['buyPrice'] * stock['shares']);
                  final isProfit = profit >= 0;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            stock['symbol'][0],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stock['symbol'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${stock['shares']} shares @ ${currencyFormatter.format(stock['buyPrice'])}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              currencyFormatter.format(value),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${isProfit ? '+' : '-'}${currencyFormatter.format(profit.abs())} (${isProfit ? '+' : '-'}${profitPercent.toStringAsFixed(2)}%)",
                              style: TextStyle(
                                color: isProfit ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Stock"),
        onPressed: () {
          _showAddStockDialog();
        },
      ),
    );
  }

  void _showAddStockDialog() {
    final symbolController = TextEditingController();
    final sharesController = TextEditingController();
    final buyPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add New Stock'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: symbolController,
                  decoration: const InputDecoration(labelText: 'Stock Symbol'),
                  textCapitalization: TextCapitalization.characters,
                ),
                TextField(
                  controller: sharesController,
                  decoration: const InputDecoration(labelText: 'Number of Shares'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: buyPriceController,
                  decoration: const InputDecoration(labelText: 'Buy Price per Share'),
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final symbol = symbolController.text.trim().toUpperCase();
                final shares = int.tryParse(sharesController.text.trim());
                final buyPrice = double.tryParse(buyPriceController.text.trim());

                if (symbol.isEmpty || shares == null || shares <= 0 || buyPrice == null || buyPrice <= 0) {
                  // Optionally: show error message/snackbar here
                  return;
                }

                setState(() {
                  portfolio.add({
                    'symbol': symbol,
                    'shares': shares,
                    'buyPrice': buyPrice,
                    'currentPrice': buyPrice,
                  });
                });

                Navigator.of(ctx).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _summaryTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
