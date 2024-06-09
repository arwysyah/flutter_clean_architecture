import 'dart:io';

import 'package:dio/dio.dart';
import 'package:millie/core/constant/constants.dart';
import 'package:millie/core/resources/data_state.dart';
import 'package:millie/features/dailynews/data/data_sources/remote/news_api_service.dart';
import 'package:millie/features/dailynews/data/models/article_models.dart';
import 'package:millie/features/dailynews/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;

  ArticleRepositoryImpl(this._newsApiService);
  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      // final httpResponse = await _newsApiService.getNewsArticles(
      //     apikey: apikey, country: country, category: categoryQuery);
      final httpResponse = await _newsApiService.getNewsArticles(
          apikey: apikey, country: country, category: categoryQuery);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSucces(httpResponse.data);
      } else {
        return DataFailed(DioException(
            requestOptions: httpResponse.response.requestOptions,
            error: httpResponse.response.statusCode,
            message: httpResponse.response.statusMessage));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
