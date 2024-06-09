import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:millie/utils/locator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MapSample extends StatefulWidget {
  final double lat;
  final double long;

  const MapSample({super.key, required this.lat, required this.long});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng data = LatLng(0.01, 0.01);

  List<LatLng> list = [];

  List<Marker> markerLists = [];

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.0, -0.0),
    zoom: 14.4746,
  );
  CameraPosition _kLake = const CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(0.0, 0.0),
      tilt: 59.440717697143555,
      zoom: 7);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initSocket();
    getData();
  }

  late IO.Socket socket;
  double latitude = 0.0;
  double longitude = 0.1;

  double lats = 0.0;
  double longs = 0.1;

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
      // socket.on("position-change", (data) {
      //   final res = jsonDecode(data);

      //   setState(() {
      //     latitude = res["latitude"];
      //     longitude = res["longitude"];
      //   });
      // });
      // socket.on("position-change", (data) {
      //   if (data) {
      //     final res = jsonDecode(data);

      //     setState(() {
      //       latitude = res["latitude"];
      //       longitude = res["longitude"];
      //     });
      //   }
      // });
      socket.on("position-change", (data) {
        final res = jsonDecode(data);

        _addPolyline(LatLng(res["latitude"], res["longitude"]));
        setState(() {
          lats = res["latitude"];
          longs = res["longitude"];
        });

        setState(() {
          _kGooglePlex = CameraPosition(
            target: LatLng(res["latitude"], res["longitude"]),
            zoom: 14.4746,
          );
          _kLake = CameraPosition(
              bearing: 192.8334901395799,
              // target: LatLng(3.0070674484270765, 99.61365708238503),
              target: calculateCenter(list),
              tilt: widget.long,
              zoom: 19.151926040649414);
        });
      });
    } catch (e) {
      print("ERRORS : ${e}");
    }
  }

// 3.595196
// 98.672226
  @override
  void didUpdateWidget(covariant MapSample oldWidget) {
    super.didUpdateWidget(oldWidget);
    getData();
  }

  void getData() async {
    // final d = await determinePostition();
    // print(d.latitude);
    // print(d.longitude);
    print("widget: ${widget.lat}");

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon2 =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
  BitmapDescriptor markerIcon3 =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  Set<Polyline> _polylines = {};
  void _addPolyline(LatLng data) {
    list.add(data);
    double randomNumber = (random.nextDouble() * 100 * 0.4).round() / 100000;
    setState(() {
      markerLists.add(
        Marker(
          markerId: const MarkerId("marker1"),
          position: LatLng(lats, longs),
          draggable: true,
          onDragEnd: (value) {
            // value is the new position
          },
          icon: markerIcon,
        ),
      );
      markerLists.add(
        Marker(
          markerId: const MarkerId("marker2"),
          position: LatLng(lats, longs + 0.00072),
          icon: markerIcon2,
        ),
      );

      markerLists.add(
        Marker(
          markerId: const MarkerId("marker3"),
          position: LatLng(lats, longs + randomNumber),
          icon: markerIcon3,
        ),
      );

      _polylines.add(
        Polyline(
          polylineId: PolylineId("poly"),
          color: Colors.blue,
          points: list,
          width: 5,
        ),
      );
    });
  }

  LatLngBounds calculateBounds(Set<Marker> markers) {
    double minLat = markers.first.position.latitude;
    double maxLat = markers.first.position.latitude;
    double minLng = markers.first.position.longitude;
    double maxLng = markers.first.position.longitude;

    for (Marker marker in markers) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;

      minLat = min(lat, minLat);
      maxLat = max(lat, maxLat);
      minLng = min(lng, minLng);
      maxLng = max(lng, maxLng);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  LatLng calculateCenter(List<LatLng> markers) {
    double totalLat = 0.0;
    double totalLng = 0.0;

    for (LatLng marker in markers) {
      totalLat += marker.latitude;
      totalLng += marker.longitude;
    }

    return LatLng(totalLat / markers.length, totalLng / markers.length);
  }

  Random random = Random();

  // Generate a random number between 0 and 1 with 5 decimal places

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.from(markerLists),

        // polylines: _polylines,
        // myLocationButtonEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    // await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    // await controller.animateCamera(cameraUpdate)

    // Calculate the bounds containing all markers
    LatLngBounds bounds = calculateBounds(Set<Marker>.from(markerLists));

    // Animate the camera to fit the bounds
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50.0),
    );
  }
}
