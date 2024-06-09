import 'package:millie/core/resources/data_state.dart';
import 'package:millie/features/dailynews/domain/entities/article.dart';

abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getNewsArticles();
}
