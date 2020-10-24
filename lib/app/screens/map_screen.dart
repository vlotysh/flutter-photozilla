import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photozilla/app/models/place.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';
  final bool isSelecting;
  final PlaceLocation initialLocation;

  MapScreen({this.initialLocation, this.isSelecting = false});

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

  GoogleMapController _controller;

  void _onMapCreated(GoogleMapController controller) {
    this._controller = controller;
  }

  Future<CameraPosition> _cameraPositionBind() async {
    LatLng targetLatLng;
    targetLatLng = widget.initialLocation != null
        ? LatLng(
            widget.initialLocation.latitude, widget.initialLocation.longitude)
        : _pickedLocation != null
            ? LatLng(_pickedLocation.latitude, _pickedLocation.longitude)
            : null;

    if (targetLatLng == null) {
      final locData = await Location().getLocation();

      targetLatLng = LatLng(locData.latitude, locData.longitude);
    }

    return CameraPosition(
      target: targetLatLng,
      zoom: 15,
    );
  }

  @override
  void initState() {
    super.initState();

    _cameraPositionBind();
  }

  @override
  Widget build(BuildContext context) {
    final mapMarker = _pickedLocation != null
        ? _pickedLocation
        : widget.initialLocation != null
            ? LatLng(widget.initialLocation.latitude,
                widget.initialLocation.longitude)
            : null;

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
      body: Stack(
        children: [
          FutureBuilder(
            future: _cameraPositionBind(),
            builder: (context, projectSnap) {
              if (projectSnap.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onTap: widget.isSelecting ? _tapHandler : null,
                  initialCameraPosition: projectSnap.data,
                  onMapCreated: _onMapCreated,
                  markers: mapMarker == null
                      ? null
                      : {
                          Marker(markerId: MarkerId('m1'), position: mapMarker)
                        });
            },
          ),
          Positioned(
              top: 10,
              left: 10,
              width: 200,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a search term'),
                ),
              ))
        ],
      ),
      floatingActionButton:
          widget.initialLocation != null || _pickedLocation != null
              ? FloatingActionButton.extended(
                  onPressed: _goToPlace,
                  label: Text('Go to place!'),
                  icon: Icon(Icons.center_focus_weak_sharp),
                )
              : null,
    );
  }

  Future<void> _goToPlace() async {
    final LatLng cameraTarget = _pickedLocation != null
        ? _pickedLocation
        : widget.initialLocation != null
            ? LatLng(widget.initialLocation.latitude,
                widget.initialLocation.longitude)
            : null;

    if (cameraTarget == null) {
      return;
    }

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0.0,
          target: cameraTarget,
          tilt: 0.0,
          zoom: 17.0,
        ),
      ),
    );

//    final GoogleMapController controller = await _controller.future;
    //   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    // bearing: 0.0, target: cameraTarget, tilt: 0.0, zoom: 17.5)));
  }
}
