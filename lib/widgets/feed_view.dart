// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../models/news.dart';
import 'feed_card.dart';

class FeedView extends StatefulWidget {
  Future<List<News>> data;
  int initialPage;
  FeedView({super.key, required this.data, required this.initialPage});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(
      initialPage: widget.initialPage,
    );
    return FutureBuilder(
      future: widget.data,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return PageView.builder(
            controller: pageController,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return FeedCard(data: snapshot.data![index]);
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
