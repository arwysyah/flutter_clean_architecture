import 'package:millie/features/dailynews/domain/entities/article.dart';

class ArticleModel extends ArticleEntity {
  final String? sourceId;
  final String? sourceName;
  final String? author;
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final String publishedAt;
  final String content;

  ArticleModel({
    this.sourceId,
    this.sourceName,
    this.author,
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      sourceId: json['source']?['id'] as String?,
      sourceName: json['source']?['name'] as String?,
      author: json['author'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      url: json['url'] as String? ?? '',
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'ArticleModel(sourceId: $sourceId, sourceName: $sourceName, author: $author, title: $title, description: $description, url: $url, urlToImage: $urlToImage, publishedAt: $publishedAt, content: $content)';
  }
}
