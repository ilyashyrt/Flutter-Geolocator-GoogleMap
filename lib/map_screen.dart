// ignore_for_file: prefer_final_fields, prefer_const_constructors, unused_element, unused_local_variable, prefer_collection_literals, use_key_in_widget_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  CameraPosition? myPosition;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kTeknoPark = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(38.714564, 35.532802),
      //tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<bool> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  getCurrentLocation() async {
    if (await _determinePosition() == true) {
      Position myLocation = await Geolocator.getCurrentPosition();
      myPosition = CameraPosition(
          target: LatLng(myLocation.latitude, myLocation.longitude), zoom: 17);
      return myPosition;
    }
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          infoWindow: InfoWindow(title: "My Location"),
          markerId: MarkerId("my_location"),
          position: myPosition != null ? myPosition!.target : LatLng(0.0, 0.0),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
    ].toSet();
  }

  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) {
      if (value == true) {
        getCurrentLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: _createMarker(),
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (await _determinePosition() == true) {
            setState(() {
              _goToTheMyLocation();
            });
          } else {}
        },
        label: Text('Where am I?'),
        icon: Icon(Icons.location_on),
      ),
    );
  }

  Future<void> _goToTheMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(await getCurrentLocation()));
  }
}
