import 'package:flutter/material.dart';
import 'package:flutter_driving_cycle/pages/driving_cycle_record_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driving Cycle Geolocator to AWS'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return DrivingCycleRecordPage();
  }
}
