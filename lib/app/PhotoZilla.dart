import 'package:flutter/material.dart';
import 'package:photozilla/app/providers/grate_places.dart';
import 'package:photozilla/app/screens/add_place_screen.dart';
import 'package:photozilla/app/screens/map_screen.dart';
import 'package:photozilla/app/screens/place_list_screen.dart';
import 'package:provider/provider.dart';

class PhotoZilla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
        title: 'Photozilla',
        theme:
            ThemeData(primarySwatch: Colors.indigo, accentColor: Colors.amber),
        home: PlacesListScreen(),
        routes: {AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(), MapScreen.routeName: (ctx) => MapScreen()},
      ),
    );
  }
}
