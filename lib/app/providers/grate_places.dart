import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:photozilla/app/helpers/location_helper.dart';

import '../helpers/db_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
      {String title, File image, PlaceLocation location}) async {
    final String address = await LocationHelper.getPlaceAddress(
        lat: location.latitude, long: location.longitude);

    Place newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: PlaceLocation(
          latitude: location.latitude,
          longitude: location.longitude,
          address: address),
    );

    _items.insert(0, newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList.map((Map<String, dynamic> place) {
      print(place);
      return Place(
        id: place['id'],
        title: place['title'],
        image: File(place['image']),
        location: PlaceLocation(
          latitude: place['loc_lat'],
          longitude: place['loc_lng'],
          address: place['address'],
        ),
      );
    }).toList();

    notifyListeners();
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> delete(String id) async {
    final result = await DBHelper.delete('user_places', id);

    if (result > 0) {
      int index = _items.indexWhere((element) => element.id == id);
      _items.removeAt(index);
      notifyListeners();
    }
  }
}
