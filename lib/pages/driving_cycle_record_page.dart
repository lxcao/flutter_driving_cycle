import 'package:flutter/material.dart';
import 'package:flutter_driving_cycle/utils/geolocation/geolocation_stream_manager.dart';
import 'package:flutter_driving_cycle/utils/geolocation/geolocator_stream_state.dart';
import 'package:flutter_driving_cycle/utils/mqtt/mqtt_server_client_manager.dart';
import 'package:flutter_driving_cycle/utils/mqtt/mqtt_state.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:async';
import 'dart:convert';

import 'package:provider/provider.dart';

class DrivingCycleRecordPage extends StatefulWidget {
  @override
  _DrivingCycleRecordPageState createState() => _DrivingCycleRecordPageState();
}

class _DrivingCycleRecordPageState extends State<DrivingCycleRecordPage> {
  StreamSubscription<Position> _positionStreamSubscription;

  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();

  final TextEditingController _drivingCycleNameTextController =
      TextEditingController();
  final TextEditingController _drivingCycleDecriptionTextController =
      TextEditingController();

  MQTTAppState currentAWSIOTState;
  MQTTServerClientManager awsIOTmanager;

  GeolocatorAppStreamState currentGeolocationState;
  GeolocationStreamManager geolocationStreamManager;

  final String demoRouteProfile = 'normal';
  final String demoVIN = '1D4HR48N83F556450';
  final String demoAWSIOTEndpoint =
      'a1vh8wv3c2znzr.ats.iot.cn-north-1.amazonaws.com.cn';
  final String demoAWSIOTTopic = 'drivingCycleTopic';
  final String demoText =
      '{"route_id":"2020-05-22 19:27:09.469356","name":"人行道","description":"二锅头","start":[31.22583099989862,121.55426799960533],"end":[31.22583099989862,121.55426799960533],"profile":"normal","vin":"1D4HR48N83F556450","points":[[31.22583099989862,121.55426799960533],[31.22583099989862,121.55426799960533],[31.22583099989862,121.55426799960533]]}';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }

    _hostTextController.dispose();
    _topicTextController.dispose();

    _drivingCycleNameTextController.dispose();
    _drivingCycleDecriptionTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState mqttState = Provider.of<MQTTAppState>(context);
    // Keep a reference to the app state.
    currentAWSIOTState = mqttState;
    final GeolocatorAppStreamState geoState =
        Provider.of<GeolocatorAppStreamState>(context);
    currentGeolocationState = geoState;
    return _buildMainListView();
  }

  Widget _buildMainListView() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 30.0,
        ),
        _buildAWSIOTColumn(),
        _buildGeolocatorColumn(),
      ],
    );
  }

  Widget _buildAWSIOTColumn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildConnectionStateText(_prepareAWSIOTStateMessageFrom(
              currentAWSIOTState.getAppConnectionState)),
          _buildEditableColumn(),
        ],
      ),
    );
  }

  // Utility state for AWS IOT
  String _prepareAWSIOTStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'AWS IOT Connected';
      case MQTTAppConnectionState.connecting:
        return 'AWS IOT Connecting';
      case MQTTAppConnectionState.disconnected:
        return 'AWS IOT Disconnected';
    }
    return 'AWS IOT Status Unkown';
  }

  Widget _buildConnectionStateText(String status) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              color: Colors.deepOrangeAccent,
              child: Text(status, textAlign: TextAlign.center)),
        ),
      ],
    );
  }

  Widget _buildEditableColumn() {
    return Column(
      children: <Widget>[
        _buildTextFieldWith(
            _hostTextController,
            'Default: ' + demoAWSIOTEndpoint,
            currentAWSIOTState.getAppConnectionState),
        const SizedBox(height: 10),
        _buildTextFieldWith(_topicTextController, 'Default: ' + demoAWSIOTTopic,
            currentAWSIOTState.getAppConnectionState),
        const SizedBox(height: 10),
        //_buildPublishMessageRow(),
        const SizedBox(height: 10),
        _buildConnecteButtonFrom(currentAWSIOTState.getAppConnectionState),
      ],
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if ((controller == _hostTextController &&
            state == MQTTAppConnectionState.disconnected) ||
        (controller == _topicTextController &&
            state == MQTTAppConnectionState.disconnected)) {
      shouldEnable = true;
    }
    return TextField(
        enabled: shouldEnable,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            color: Colors.lightBlueAccent,
            child: const Text('Connect'),
            onPressed: state == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : null, //
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RaisedButton(
            color: Colors.redAccent,
            child: const Text('Disconnect'),
            onPressed: state == MQTTAppConnectionState.connected
                ? _disconnect
                : null, //
          ),
        ),
      ],
    );
  }

  void _configureAndConnect() {
    awsIOTmanager = MQTTServerClientManager(
        //host: _hostTextController.text,
        //topic: _topicTextController.text,
        host: demoAWSIOTEndpoint,
        topic: demoAWSIOTTopic,
        identifier: demoVIN,
        state: currentAWSIOTState);
    awsIOTmanager.initializeMQTTClient();
    awsIOTmanager.connect();
    //manager.subscribe();
  }

  void _disconnect() {
    awsIOTmanager.disconnect();
  }

  void _publishMessage(String text) {
    final String message = text;
    awsIOTmanager.publish(message);
  }

  /// *****************************************华丽的分割线**************************************************** */

  // Utility state for Geolocation
  String _prepareGeoLocationStateMessageFrom(GeolocatorStreamState state) {
    switch (state) {
      case GeolocatorStreamState.denied:
        return 'GPS Denied';
      case GeolocatorStreamState.dislistened:
        return 'GeoLocator Dislistened';
      case GeolocatorStreamState.listening:
        return 'GeoLocator Listening';
      case GeolocatorStreamState.pause:
        return 'GeoLocator Paused';
      case GeolocatorStreamState.resume:
        return 'GeoLocator Listening';
    }
    return 'Geolocator Status Unkown';
  }

  Widget _buildGeolocatorColumn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildConnectionStateText(
            _prepareGeoLocationStateMessageFrom(
                currentGeolocationState.getGeolocatorStreamState),
          ),
          _buildGeolocationEditableColumn(),
          _buildListenButtonFrom(
              currentGeolocationState.getGeolocatorStreamState),
          _buildScrollableTextWith(jsonEncode(currentGeolocationState.getTrip)),
          _buildScrollableTextWith(
              currentGeolocationState.getPositions.toString()),
        ],
      ),
    );
  }

  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 400,
        height: 100,
        child: SingleChildScrollView(
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildListenButtonFrom(GeolocatorStreamState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            color: Colors.lightBlueAccent,
            child: const Text('Listen'),
            onPressed: state == GeolocatorStreamState.dislistened
                ? _geolocatorConfigureAndListen
                : null, //
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RaisedButton(
            color: Colors.redAccent,
            child: const Text('Stop'),
            onPressed: state == GeolocatorStreamState.listening
                ? _geolocatorDislisten
                : null, //
          ),
        ),
      ],
    );
  }

  void _geolocatorConfigureAndListen() {
    geolocationStreamManager = GeolocationStreamManager(
        accuracy: LocationAccuracy.best,
        state: currentGeolocationState,
        forceAndroidLocationManager: true);
    geolocationStreamManager.initialPositionStream();
    geolocationStreamManager.listen(
        dcName: _drivingCycleNameTextController.text,
        dcDesc: _drivingCycleDecriptionTextController.text,
        vin: demoVIN,
        profile: demoRouteProfile);
  }

  void _geolocatorDislisten() {
    geolocationStreamManager.cancel();
    currentGeolocationState
        .addPositionsToTrip(currentGeolocationState.getPositions);
    _publishMessage(jsonEncode(currentGeolocationState.getTrip));
  }

  Widget _buildGeolocationEditableColumn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildGeolocatorTextFieldWith(
              _drivingCycleNameTextController,
              'Enter driving cycle name',
              currentGeolocationState.getGeolocatorStreamState),
          const SizedBox(height: 10),
          _buildGeolocatorTextFieldWith(
              _drivingCycleDecriptionTextController,
              'Enter driving cycle description',
              currentGeolocationState.getGeolocatorStreamState),
        ],
      ),
    );
  }

  Widget _buildGeolocatorTextFieldWith(TextEditingController controller,
      String hintText, GeolocatorStreamState state) {
    bool shouldEnable = false;
    if (controller == _drivingCycleNameTextController &&
        state == GeolocatorStreamState.dislistened) {
      shouldEnable = true;
    } else if ((controller == _drivingCycleDecriptionTextController &&
        state == GeolocatorStreamState.dislistened)) {
      shouldEnable = true;
    }
    return TextField(
      enabled: shouldEnable,
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
        labelText: hintText,
      ),
    );
  }
}
