import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:millie/features/dailynews/data/data_sources/remote/news_api_service.dart';
import 'package:millie/features/dailynews/data/repository/article_repository.dart';
import 'package:millie/features/dailynews/domain/repository/article_repository.dart';
import 'package:millie/features/dailynews/domain/use_cases/get_article_usecase.dart';
import 'package:millie/features/dailynews/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:millie/features/dailynews/presentation/bloc/article/remote/remote_article_event.dart';

final sl = GetIt.instance;

Future<void> initialDependencies() async {
// DIO
  sl.registerSingleton<Dio>(Dio());

  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));

  sl.registerSingleton<ArticleRepository>(ArticleRepositoryImpl(sl()));
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));
  sl.registerSingleton<RemoteArticlesBloc>(RemoteArticlesBloc(sl()));
}
//in get it you can use Factory or SingleTon;
// in factory you will get an instance whenerever you use that

// with singleton you will only will use one time instance/same instance in app lifetime