// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:millie/core/resources/data_state.dart';
import 'package:millie/features/dailynews/domain/use_cases/get_article_usecase.dart';
import 'package:millie/features/dailynews/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:millie/features/dailynews/presentation/bloc/article/remote/remote_article_state.dart';

class RemoteArticlesBloc extends Bloc<RemoteArticleEvent, RemoteArticleState> {
  final GetArticleUseCase _getArtcleUseCase;
  RemoteArticlesBloc(this._getArtcleUseCase)
      : super(const RemoteArticleLoading()) {
    on<GetArticles>(onGetArticles);
  } // initial State

  void onGetArticles(
      GetArticles event, Emitter<RemoteArticleState> emitter) async {
    final dataState = await _getArtcleUseCase();
    if (dataState is DataSucces && dataState.data!.isNotEmpty) {
      emit(RemoteArticleDone(dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(RemoteArticleError(dataState.error!));
    }
  }
}
