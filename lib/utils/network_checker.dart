import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

Future<void> startInternetSpeedTest(
    FlutterInternetSpeedTest internetSpeedTest) async {
  await internetSpeedTest.startTesting(
    onStarted: () {},
    onCompleted: (TestResult download, TestResult upload) {},
    onProgress: (double percent, TestResult data) {},
    onError: (String errorMessage, String speedTestError) {},
    onDefaultServerSelectionInProgress: () {},
    onDefaultServerSelectionDone: (Client? client) {},
    onDownloadComplete: (TestResult data) {},
    onUploadComplete: (TestResult data) {},
    onCancel: () {},
  );
}
