import 'package:flutter/material.dart';
import 'package:quick_news/widgets/feed_view.dart';
import '../models/news.dart';
import '../services/news_service.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Future<List<News>> data;

  @override
  void initState() {
    final NewsService newsService = NewsService();
    data = newsService.getHeadlines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FeedView(
      data: data,
      initialPage: 0,
    );
  }
}
