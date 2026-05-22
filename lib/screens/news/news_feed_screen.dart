import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsFeedScreen extends StatelessWidget {
  final String? symbol;

  const NewsFeedScreen({this.symbol, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(symbol != null ? 'News for $symbol' : 'Market News'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchNewsArticles(symbol),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading news: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news available.'));
          }

          final articles = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final article = articles[index];
              final date = article['date'] != null
                  ? DateFormat.yMMMd().format(article['date'])
                  : '';

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final url = article['url'];
                    if (url != null && await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['headline'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              article['source'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (date.isNotEmpty) ...[
                              const SizedBox(width: 10),
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          article['summary'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchNewsArticles(String? symbol) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    if (symbol == null) {
      return [
        {
          'headline': 'Market rallies as inflation drops',
          'source': 'Reuters',
          'date': DateTime.now().subtract(const Duration(days: 1)),
          'summary': 'Stocks surged today as inflation showed signs of cooling, boosting investor confidence.',
          'url': 'https://www.reuters.com/markets',
        },
        {
          'headline': 'Tech stocks soar on earnings',
          'source': 'CNBC',
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'summary': 'Leading technology companies reported strong quarterly earnings, lifting the NASDAQ.',
          'url': 'https://www.cnbc.com/technology',
        },
      ];
    } else {
      return [
        {
          'headline': '$symbol hits all-time high',
          'source': 'Yahoo Finance',
          'date': DateTime.now().subtract(const Duration(hours: 5)),
          'summary': '$symbol shares reached a new record high amid strong market demand.',
          'url': 'https://finance.yahoo.com',
        },
        {
          'headline': '$symbol sees strong quarterly results',
          'source': 'Bloomberg',
          'date': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
          'summary': 'The company reported better than expected earnings and revenue for the last quarter.',
          'url': 'https://www.bloomberg.com',
        },
      ];
    }
  }
}
