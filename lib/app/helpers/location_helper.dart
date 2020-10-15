import 'package:photozilla/config/flavor_config.dart';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?'
        'center=&$latitude,$longitude&zoom=13&size=600x300&'
        'markers=color:red%7Clabel:C%7C$latitude,$longitude'
        '&key=${FlavorConfig.instance.values.mapApiKey}';
  }
}
