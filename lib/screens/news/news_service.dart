import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_article.dart';

class NewsService {
  final String apiKey = 'YOUR_MARKETAUX_API_KEY';

  Future<List<NewsArticle>> fetchNews(String symbol) async {
    final url = Uri.parse(
      'https://api.marketaux.com/v1/news/all?symbols=$symbol&filter_entities=true&language=en&api_token=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final articles = jsonData['data'] as List;
      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
