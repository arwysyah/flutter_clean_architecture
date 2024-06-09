import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:millie/feature/maps/input_location.dart';

import 'package:millie/features/dailynews/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:millie/features/dailynews/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:millie/features/dailynews/presentation/pages/daily_news.dart';
import 'package:millie/injection_container.dart';

void main() async {
  await initialDependencies();
  runApp(BlocProvider<RemoteArticlesBloc>(
    create: (context) => sl()..add(const GetArticles()),
    child: const MaterialApp(
      home: DailyNews(),
      // home: NetworkChecker(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: InputLocation(),
    );
  }
}
