import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/controllers/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/models/article.dart';
import 'package:flutter_testing_tutorial/services/news_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier systemUnderTest;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    systemUnderTest = NewsChangeNotifier(mockNewsService);
  });

  test("initial values are correct", () {
    expect(systemUnderTest.articles, []);
    expect(systemUnderTest.isLoading, false);
  });

  group('getArticles', () {

    final _mockArticles = [
      Article(title: 'title 1', content: 'content 1'),
      Article(title: 'title 2', content: 'content 2'),
      Article(title: 'title 3', content: 'content 3'),
    ];

    void _arrangeNewsServiceReturns3Articles() {
      when(() => mockNewsService.getArticles()).thenAnswer((_) async => _mockArticles);
    }

    test('gets articles using the NewsService', () async {
      _arrangeNewsServiceReturns3Articles();
      await systemUnderTest.getArticles();
      verify(() => mockNewsService.getArticles()).called(1);
    });

    test(
      """indicates loading of data, 
      set articles to the ones from the service,
      indicates that data is not being loaded anymore""",
      () async {
        _arrangeNewsServiceReturns3Articles();
        final future = systemUnderTest.getArticles();
        expect(systemUnderTest.isLoading, true);
        await future;
        expect(systemUnderTest.articles, _mockArticles);
        expect(systemUnderTest.isLoading, false);
      },
    );
  });
}
