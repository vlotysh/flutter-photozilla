import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photozilla/app/helpers/location_helper.dart';
import 'package:photozilla/app/screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  LocationData _locationData;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();

    setState(() {
      _locationData = locData;
      _renderMapImage(
          latitude: _locationData.latitude, longitude: _locationData.longitude);
    });
  }

  void _renderMapImage({double latitude, double longitude}) {
    _previewImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: latitude, longitude: longitude);
  }

  Future<void> _pickUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   print('Location picked');
    //   print('latitude ${currentLocation.latitude}');
    //   print('longitude ${currentLocation.longitude}');
    // });
  }

  Future<void> _selectLocation() async {
    final LatLng selectedLocation =
        await Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => MapScreen(
                  isSelecting: true,
                )));

    if (selectedLocation == null) {
      return;
    }

    setState(() {
      //   selectedLocation.longitude, selectedLocation.latitude
      _renderMapImage(
          latitude: selectedLocation.latitude,
          longitude: selectedLocation.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          alignment: Alignment.center,
          width: double.infinity,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? Text('No location')
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select on map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _selectLocation,
            ),
          ],
        )
      ],
    );
  }
}
