import 'package:flutter/material.dart';
import 'package:photozilla/app/providers/grate_places.dart';
import 'package:photozilla/app/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: true
          ? Consumer<GreatPlaces>(
              child: Center(
                  child: Text('No place here! Start to add some place!')),
              builder: (ctx, gratePlace, ch) => gratePlace.items.length <= 0
                  ? ch
                  : ListView.builder(
                      itemCount: gratePlace.items.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(gratePlace.items[index].image),
                          ),
                          title: Text(gratePlace.items[index].title),
                          onTap: () {
                            //go to details
                          },
                        );
                      }),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
