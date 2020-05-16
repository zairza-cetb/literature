import 'app_config.dart';
import 'main.dart';
import 'package:flutter/material.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Build flavors',
    flavorName: 'production',
    apiBaseUrl: 'https://api.example.com/', //Setup the server api url here, to test the server api after deployment
    child: new MyApp(),
  );

  runApp(configuredApp);
}
