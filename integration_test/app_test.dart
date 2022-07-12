import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/controllers/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/models/article.dart';
import 'package:flutter_testing_tutorial/pages/article_page.dart';
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
    when(() => mockNewsService.getArticles())
        .thenAnswer((_) async => _mockArticles);
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
    """tapping on the first article excerpt opens the article page 
    where the full article content is displayed""",
    (WidgetTester tester) async {
      _arrangeNewsServiceReturns3Articles();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.tap(find.text('content 1'));
      await tester.pumpAndSettle();
      expect(find.byType(NewsPage), findsNothing);
      expect(find.byType(ArticlePage), findsOneWidget);
      expect(find.text('title 1'), findsOneWidget);
      expect(find.text('content 1'), findsOneWidget);
    },
  );
}
