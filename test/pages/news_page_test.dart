import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/controllers/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/models/article.dart';
import 'package:flutter_testing_tutorial/pages/news_page.dart';
import 'package:flutter_testing_tutorial/services/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  final _mockArticles = [
    Article(title: 'title 1', content: 'content 1'),
    Article(title: 'title 2', content: 'content 2'),
    Article(title: 'title 3', content: 'content 3'),
  ];

  void _arrangeNewsServiceReturns3Articles() {
    when(() => mockNewsService.getArticles()).thenAnswer((_) async => _mockArticles);
  }

  void _arrangeNewsServiceReturns3ArticlesAfter2SecondWait() {
    when(() => mockNewsService.getArticles()).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return _mockArticles;
    });
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets(
    "title is displayed",
    (WidgetTester tester) async {
      _arrangeNewsServiceReturns3Articles();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('News'), findsOneWidget);
    },
  );

  testWidgets(
    "loading indicator is displayed while waiting for articles",
        (WidgetTester tester) async {
      _arrangeNewsServiceReturns3ArticlesAfter2SecondWait();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 500)); // wait for provider for initialize
      // expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byKey(const Key('progress_indicator')), findsOneWidget);
      await tester.pumpAndSettle(); // wait until no more animations happens
    },
  );

  testWidgets(
    "articles are displayed",
        (WidgetTester tester) async {
      _arrangeNewsServiceReturns3Articles();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      for (final article in _mockArticles) {
        expect(find.text(article.title), findsOneWidget);
        expect(find.text(article.content), findsOneWidget);
      }
    },
  );
}
