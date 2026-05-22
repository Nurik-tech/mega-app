class NewsArticle {
  final String title;
  final String url;
  final String source;
  final String? imageUrl;
  final String publishedAt;

  NewsArticle({
    required this.title,
    required this.url,
    required this.source,
    this.imageUrl,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      source: json['source'] ?? '',
      imageUrl: json['image_url'],
      publishedAt: json['published_at'] ?? '',
    );
  }
}
