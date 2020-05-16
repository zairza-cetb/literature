import 'app_config.dart';
import 'main.dart';
import 'package:flutter/material.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Build flavors DEV',
    flavorName: 'development',
    apiBaseUrl: 'http://56d6501f.ngrok.io/',
    child: new MyApp(),
  );
  
  runApp(configuredApp);
}
