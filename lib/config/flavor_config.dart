import 'package:flutter/material.dart';

enum Flavor { DEV, QA, PRODUCTION }

class FlavorValues {
  final String mapApiKey;

  FlavorValues({@required this.mapApiKey});
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  final FlavorValues values;
  static FlavorConfig _instance;

  factory FlavorConfig(
      {@required Flavor flavor,
      Color color: Colors.blue,
      @required FlavorValues values}) {
    String flavorValue;
    if (flavor == Flavor.DEV) {
      flavorValue = 'DEV';
    }
    if (flavor == Flavor.QA) {
      flavorValue = 'QA';
    }
    if (flavor == Flavor.PRODUCTION) {
      flavorValue = 'PRODUCTION';
    }

    _instance ??= FlavorConfig._internal(flavor, flavorValue, color, values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.color, this.values);
  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.flavor == Flavor.PRODUCTION;
  static bool isDevelopment() => _instance.flavor == Flavor.DEV;
  static bool isQA() => _instance.flavor == Flavor.QA;
}
