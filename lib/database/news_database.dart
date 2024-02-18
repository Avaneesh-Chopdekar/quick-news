import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/news.dart';

class NewsDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NewsSchema], directory: dir.path);
  }

  final List<News> savedNews = [];

  // CREATE
  Future<void> addNews(News news) async {
    await isar.writeTxn(() => isar.news.put(news));

    // revalidating data
    await fetchNews();
  }

  // READ
  Future<void> fetchNews() async {
    List<News> fetchedNews = await isar.news.where().findAll();
    savedNews.clear();
    savedNews.addAll(fetchedNews);
    notifyListeners();
  }

  // DELETE
  Future<void> deleteNews(int id) async {
    await isar.writeTxn(() => isar.news.delete(id));

    // revalidating data
    await fetchNews();
  }

  // Check if news articles already contains or not
  bool checkIfExists(News news) {
    for (News n in savedNews) {
      if (n.title == news.title) {
        return true;
      }
    }
    return false;
  }
}
