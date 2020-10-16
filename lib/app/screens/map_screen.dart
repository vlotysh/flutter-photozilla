import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photozilla/app/models/place.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';
  final bool isSelecting;
  final PlaceLocation initialLocation;

  MapScreen(
      {this.initialLocation = const PlaceLocation(
          latitude: 37.42296133580664, longitude: -122.085749655962),
      this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _tapHandler(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    final CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(
          widget.initialLocation.latitude, widget.initialLocation.longitude),
      zoom: 14.4746,
    );

    return new Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: [
          if (widget.isSelecting && _pickedLocation != null)
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  Navigator.of(context)
                      .pop(_pickedLocation); // return to previous screen
                })
        ],
      ),
      body: GoogleMap(
          mapType: MapType.normal,
          onTap: widget.isSelecting ? _tapHandler : null,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: _pickedLocation == null
              ? null
              : {Marker(markerId: MarkerId('m1'), position: _pickedLocation)}),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: _pickedLocation == null
            ? LatLng(37.43296265331129, -122.08832357078792)
            : _pickedLocation,
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)));
  }
}
