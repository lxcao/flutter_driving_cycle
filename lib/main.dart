import 'package:flutter/material.dart';
import 'package:flutter_driving_cycle/pages/home_page.dart';
import 'package:flutter_driving_cycle/utils/geolocation/geolocator_stream_state.dart';
import 'package:flutter_driving_cycle/utils/mqtt/mqtt_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Driving Cycle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
/*       home: ChangeNotifierProvider<MQTTAppState>(
        create: (_) => MQTTAppState(),
        child: HomePage(),
      ), */
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MQTTAppState()),
          ChangeNotifierProvider(
              create: (context) => GeolocatorAppStreamState()),
        ],
        child: HomePage(),
      ),
    );
  }
}
