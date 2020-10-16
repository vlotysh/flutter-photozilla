import 'package:flutter/material.dart';
import 'package:photozilla/app/models/place.dart';
import 'package:photozilla/app/providers/grate_places.dart';
import 'package:photozilla/app/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = '/place-detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;

    Place place = Provider.of<GreatPlaces>(context, listen: false).findById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Places'),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              place.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            place.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          FlatButton.icon(
            icon: Icon(Icons.map),
            label: Text('View on mpa'),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => MapScreen(
                        isSelecting: false,
                        initialLocation: place.location,
                      )));
            },
          )
        ],
      ),
    );
  }
}
