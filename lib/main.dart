import 'package:flutter/material.dart';
import 'package:photozilla/config/EnvConfig.dart';
import 'package:photozilla/config/flavor_config.dart';

import 'app/PhotoZilla.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.DEV,
      color: Colors.purple,
      values: FlavorValues(
          //https://medium.com/flutter-community/flutter-ready-to-go-e59873f9d7de#c38c
          mapApiKey: EnvConfig.MAP_API_KEY));
  runApp(PhotoZilla());
}
