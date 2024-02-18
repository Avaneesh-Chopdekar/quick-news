import 'dart:convert';

import 'package:http/http.dart' as http;
import '../secrets.dart';
import '../models/news.dart';

class NewsService {
  Future<List<News>> getHeadlines() async {
    final url = Uri.parse('$BASE_URL/top-headlines?country=in&apiKey=$API_KEY');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<News> articles = [];
      json['articles'].forEach((item) {
        if (item['title'] != '[Removed]') {
          articles.add(News.fromJson(item));
        }
      });
      return articles;
    } else {
      throw Exception('Failed to load (headlines) news');
    }
  }

  Future<List<News>> getEverything(String query) async {
    final url = Uri.parse('$BASE_URL/everything?q=$query&apiKey=$API_KEY');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<News> articles = [];
      json['articles'].forEach((item) {
        if (item['title'] != '[Removed]') {
          articles.add(News.fromJson(item));
        }
      });
      return articles;
    } else {
      throw Exception('Failed to load (headlines) news');
    }
  }
}
