import 'dart:io';

import 'package:flutter/foundation.dart';

import '../helpers/db_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace({String title, File image}) {
    Place newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: null,
    );

    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }

  Future<void> fetchPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((Map<String, dynamic> place) => Place(
              id: place['id'],
              title: place['title'],
              image: File(place['image']),
              location: null,
            ))
        .toList();

    notifyListeners();
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
