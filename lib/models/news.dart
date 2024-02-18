import 'package:isar/isar.dart';

part 'news.g.dart';

@Collection()
class News {
  Id id = Isar.autoIncrement;
  String? sourceId;
  String? sourceName;
  String title;
  String? description;
  String url;
  String? urlToImage;
  String? content;

  News({
    this.sourceId,
    this.sourceName,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.content,
  });

  factory News.fromJson(Map<dynamic, dynamic> json) {
    return News(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      sourceId: json['source']['id'],
      sourceName: json['source']['name'],
      content: json['content'],
    );
  }
}
