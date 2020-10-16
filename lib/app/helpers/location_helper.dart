import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:photozilla/config/flavor_config.dart';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?'
        'center=&$latitude,$longitude&zoom=13&size=600x300&'
        'markers=color:red%7Clabel:C%7C$latitude,$longitude'
        '&key=${FlavorConfig.instance.values.mapApiKey}';
  }

  static Future<String> getPlaceAddress({double long, double lat}) async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${FlavorConfig.instance.values.mapApiKey}';
    http.get(url);
    final response = await http.get(url);

    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
