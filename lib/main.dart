import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import '../database/news_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NewsDatabase.initialize();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NewsDatabase(),
        )
      ],
      builder: (context, child) => MaterialApp(
        title: 'Quick News',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: const ColorScheme.dark(
            brightness: Brightness.dark,
            primary: Colors.green,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const App(),
      ),
    );
  }
}
