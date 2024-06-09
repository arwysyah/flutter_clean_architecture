import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:millie/features/dailynews/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:millie/features/dailynews/presentation/bloc/article/remote/remote_article_state.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticleState>(
        builder: (_, state) {
      if (state is RemoteArticleLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state is RemoteArticleError) {
        return const Icon(
          Icons.refresh,
          color: Colors.red,
        );
      }

      if (state is RemoteArticleDone) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("${index}"),
            );
          },
          itemCount: state.articles!.length,
        );
      }
      return Container(
        color: Colors.amber,
      );
    });
  }
}
