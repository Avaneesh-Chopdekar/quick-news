// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:quick_news/widgets/feed_view.dart';

import '../models/news.dart';

class FeedViewPage extends StatelessWidget {
  Future<List<News>> data;
  int initialPage;
  String pageTitle;
  FeedViewPage(
      {super.key,
      required this.data,
      required this.initialPage,
      required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        centerTitle: true,
      ),
      body: FeedView(data: data, initialPage: initialPage),
    );
  }
}
