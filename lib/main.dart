import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_testing_tutorial/controllers/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/pages/news_page.dart';
import 'package:flutter_testing_tutorial/services/news_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(NewsService()),
        child: const NewsPage(),
      ),
    );
  }
}
