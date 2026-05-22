import 'dart:convert';
import 'package:http/http.dart' as http;

class StockApiService {
  final String apiKey = 'd1jcle9r01qkl9jbfsh0d1jcle9r01qkl9jbfshg';

  Future<double?> fetchStockPrice(String symbol) async {
    final url = Uri.parse(
        'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['c'] as num?)?.toDouble();
    } else {
      print('Error fetching stock price: ${response.statusCode}, ${response.body}');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchStockNews(String symbol) async {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month - 1, now.day);
    final fromDate = from.toIso8601String().substring(0, 10);
    final toDate = now.toIso8601String().substring(0, 10);

    final url = Uri.parse(
        'https://finnhub.io/api/v1/company-news?symbol=$symbol&from=$fromDate&to=$toDate&token=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<Map<String, dynamic>>((item) => {
        'headline': item['headline'],
        'datetime': item['datetime'],
        'source': item['source'],
        'url': item['url'],
      }).toList();
    } else {
      print('Error fetching news: ${response.statusCode}, ${response.body}');
      return [];
    }
  }
}

