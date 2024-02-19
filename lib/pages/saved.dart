import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_news/database/news_database.dart';

import '../models/news.dart';
import 'feed_view_page.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  late TextEditingController searchSavedController;

  @override
  void initState() {
    searchSavedController = TextEditingController();
    getNews();
    super.initState();
  }

  @override
  void dispose() {
    searchSavedController.dispose();
    super.dispose();
  }

  void getNews() {
    context.read<NewsDatabase>().fetchNews();
  }

  void deleteNews(int id) {
    context.read<NewsDatabase>().deleteNews(id);
  }

  Future<List<News>> sendData() async {
    return context.read<NewsDatabase>().savedNews;
  }

  @override
  Widget build(BuildContext context) {
    final newsDatabase = context.watch<NewsDatabase>();
    List<News> savedNews = newsDatabase.savedNews;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
          child: Text(
            'Saved News',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: savedNews.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  deleteNews(savedNews[index].id);
                },
                child: ListTile(
                  minVerticalPadding: 12,
                  title: Text(
                    savedNews[index].title,
                    maxLines: 2,
                  ),
                  subtitle: Text(
                    savedNews[index].description ??
                        savedNews[index].content ??
                        "",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FeedViewPage(
                          data: sendData(),
                          initialPage: index,
                          pageTitle: "Saved News",
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
