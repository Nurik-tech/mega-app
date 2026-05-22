import 'dart:convert';
import 'package:http/http.dart' as http;

class YahooFinanceService {
  static Future<Map<String, dynamic>> fetchStockDetails(String symbol) async {
    final url = Uri.parse('https://query1.finance.yahoo.com/v7/finance/quote?symbols=$symbol');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['quoteResponse']['result'] != null && jsonData['quoteResponse']['result'].isNotEmpty) {
        return jsonData['quoteResponse']['result'][0];
      } else {
        throw Exception('No stock data found');
      }
    } else {
      throw Exception('Failed to fetch stock data');
    }
  }

  // Search stocks by query and return a list of matching symbols with their names
  static Future<List<Map<String, String>>> searchStocks(String query) async {
    final url = Uri.parse('https://query1.finance.yahoo.com/v1/finance/search?q=$query&quotesCount=10&newsCount=0');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['quotes'] != null) {
        final List quotes = jsonData['quotes'];
        return quotes.map<Map<String, String>>((item) {
          return {
            'symbol': item['symbol'] ?? '',
            'shortname': item['shortname'] ?? item['longname'] ?? item['symbol'] ?? '',
            'exchDisp': item['exchDisp'] ?? '',
          };
        }).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to search stocks');
    }
  }
}
