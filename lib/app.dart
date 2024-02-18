import 'package:flutter/material.dart';
import '../pages/feed.dart';
import '../pages/saved.dart';
import '../pages/search.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int navIndex = 0;
  final List<Widget> pages = [
    const FeedPage(),
    const SearchPage(),
    const SavedPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick News"),
        centerTitle: true,
      ),
      body: IndexedStack(index: navIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int value) {
          setState(() {
            navIndex = value;
          });
        },
        selectedIndex: navIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.feed), label: "Feed"),
          NavigationDestination(icon: Icon(Icons.search), label: "Search"),
          NavigationDestination(icon: Icon(Icons.bookmark), label: "Saved"),
        ],
      ),
    );
  }
}
