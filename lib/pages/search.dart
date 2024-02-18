import 'package:flutter/material.dart';
import '../pages/feed_view_page.dart';
import '../models/news.dart';
import '../services/news_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController(text: "India");
  final NewsService newsService = NewsService();
  late Future<List<News>> data;

  Future<List<News>> callApi() {
    return newsService.getEverything(searchController.text.trim());
  }

  @override
  void initState() {
    data = callApi();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Search',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    data = callApi();
                  });
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      minVerticalPadding: 12,
                      title: Text(
                        snapshot.data![index].title,
                        maxLines: 2,
                      ),
                      subtitle: Text(
                        snapshot.data?[index].description == null
                            ? ""
                            : snapshot.data![index].description!,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FeedViewPage(
                              data: data,
                              initialPage: index,
                              pageTitle: "Search - ${searchController.text}",
                            ),
                          ),
                        );
                      },
                    );
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
            },
          ),
        ),
      ],
    );
  }
}
