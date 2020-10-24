import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photozilla/app/models/place.dart';
import 'package:photozilla/app/providers/grate_places.dart';
import 'package:photozilla/widgets/image_input.dart';
import 'package:photozilla/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add_place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  TextEditingController _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _placedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double latitude, double longitude) {
    _placedLocation = PlaceLocation(latitude: latitude, longitude: longitude);
  }

  void _savePlace() {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      return;
    }

    Provider.of<GreatPlaces>(context, listen: false).addPlace(
        title: _titleController.text,
        image: _pickedImage,
        location: PlaceLocation(
            latitude: _placedLocation.latitude,
            longitude: _placedLocation.longitude));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new place'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ImageInput(_selectImage),
                      SizedBox(
                        height: 10,
                      ),
                      LocationInput(_selectPlace),
                    ],
                  ),
                ),
              ),
            ),
            RaisedButton.icon(
                elevation: 0,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                color: Theme.of(context).accentColor,
                label: Text('Add place'),
                onPressed: _savePlace,
                icon: Icon(Icons.add))
          ],
        ),
      ),
    );
  }
}
