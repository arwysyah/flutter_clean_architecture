import 'package:dio/dio.dart';
import 'package:millie/core/constant/constants.dart';
import 'package:millie/features/dailynews/data/models/article_models.dart';
import 'package:retrofit/retrofit.dart';

part "news_api_service.g.dart";

@RestApi(baseUrl: newsApiBaseUrl)
abstract class NewsApiService {
  factory NewsApiService(Dio dio) = _NewsApiService;

  Future<HttpResponse<List<ArticleModel>>> getNewsArticles({
    @Query("apikey") String? apikey,
    @Query("country") String? country,
    @Query("categoty") String? category,
  });
}
