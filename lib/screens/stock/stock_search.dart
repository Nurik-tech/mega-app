import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // For navigation
import '../../services/yahoo_finance.dart';
import '../../services/yahoo_finance.dart'; // Make sure this matches your file name

class StockSearchScreen extends StatefulWidget {
  const StockSearchScreen({super.key});

  @override
  State<StockSearchScreen> createState() => _StockSearchScreenState();
}

class _StockSearchScreenState extends State<StockSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _results = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _searchStocks(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final stocks = await YahooFinanceService.searchStocks(query);
      setState(() {
        _results = stocks;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load stocks';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.length > 2) {
        _searchStocks(_searchController.text);
      } else {
        setState(() {
          _results = [];
          _error = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Stocks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search for stocks',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red))
            else if (_results.isEmpty)
                const Text('No results found')
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final stock = _results[index];
                      final symbol = stock['symbol'] ?? '';
                      final name = stock['shortname']!.isNotEmpty
                          ? stock['shortname']!
                          : symbol;

                      return ListTile(
                        title: Text('$name ($symbol)'),
                        onTap: () {
                          // Navigate to stock detail page with symbol param
                          context.go('/stocks/$symbol');
                        },
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
