import 'package:dio/dio.dart';

abstract class DataState<T> {
  const DataState({this.data, this.error});
  final T? data;
  final DioException? error;
}

class DataSucces<T> extends DataState<T> {
  const DataSucces(T data) : super(data: data);
}

class DataLoading<T> extends DataState<T> {
  const DataLoading() : super();
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(DioException error) : super(error: error);
}
