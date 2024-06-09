import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:millie/feature/maps/maps_ui.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class InputLocation extends StatefulWidget {
  const InputLocation({super.key});

  @override
  State<InputLocation> createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  late IO.Socket socket;
  double latitude = 0.0;
  double longitude = 0.1;

  double lats = 0.0;
  double longs = 0.1;

  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    initSocket();
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io("http://localhost:3000", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": true
      });
      socket.connect();
      socket.onConnect((data) => {print("Connect ${data}")});

      socket.on("position-change", (data) {
        final res = jsonDecode(data);

        setState(() {
          lats = res["latitude"];
          longs = res["longitude"];
        });
      });
    } catch (e) {
      print("ERRORS : ${e}");
    }
  }

  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();

  Future<void> startBackgroundLocation() async {
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      var coords = {
        "latitude": location.coords.latitude,
        "longitude": location.coords.longitude,
      };
      socket.emit("position-change", jsonEncode(coords));
      setState(() {
        lats = location.coords.latitude;
        longs = location.coords.longitude;
      });
    });
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print('[motionchange] - $location');
    });
    ////
    // 2.  Configure the plugin
    //
    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            stopOnTerminate: false,
            startOnBoot: true,
            debug: true,
            locationTimeout: 1000,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE))
        .then((bg.State state) {
      if (!state.enabled) {
        ////
        // 3.  Start the plugin.
        //
        bg.BackgroundGeolocation.start();
      }
    });
    // Start background location service
    // await BackgroundLocation.startLocationService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: globalKey,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    var coords = {"latitude": latitude, "longitude": longitude};

                    socket.emit("position-change", jsonEncode(coords));

                    // }
                  },
                  child: const Text('Submit'),
                ),
              ),
              SizedBox(
                height: 400,
                width: 400,
                child: MapSample(
                  lat: lats,
                  long: longs,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () async {
                  await startBackgroundLocation();
                },
                child: Text('Start Background Location Updates'),
              ),
            ],
          )),
    );
  }
}
