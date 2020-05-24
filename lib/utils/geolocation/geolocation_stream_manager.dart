import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_driving_cycle/utils/geolocation/geolocator_stream_state.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationStreamManager {
  final GeolocatorAppStreamState _currentState;
  final LocationAccuracy _accuracy;
  final int _timeInverval;
  final int _distanceFilter;
  final bool _forceAndroidLocationManager;
  LocationOptions _locationOptions;
  Stream<Position> _positionStream;
  StreamSubscription<Position> _positionStreamSubscription;
  final List<Position> _positions = List<Position>();
  Geolocator _geolocator;

  GeolocationStreamManager(
      {@required LocationAccuracy accuracy,
      @required bool forceAndroidLocationManager,
      @required GeolocatorAppStreamState state,
      int timeInverval,
      int distanceFilter})
      : _accuracy = accuracy,
        _forceAndroidLocationManager = forceAndroidLocationManager,
        _timeInverval = timeInverval,
        _distanceFilter = distanceFilter,
        _currentState = state;

  Future<void> checkGeolocationStatus() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    print('GEOLOCATOR::status is ${geolocationStatus.toString()}');
    geolocationStatus.toString() != GeolocationStatus.granted.toString()
        ? _currentState.setGeolocatorStreamState(GeolocatorStreamState.denied)
        : _currentState
            .setGeolocatorStreamState(GeolocatorStreamState.dislistened);
  }

  void initialPositionStream() {
    _locationOptions = LocationOptions(
      accuracy: _accuracy,
      forceAndroidLocationManager: _forceAndroidLocationManager,
      //timeInterval: _timeInverval,
      //distanceFilter: _distanceFilter,
    );

    _positionStream = Geolocator().getPositionStream(_locationOptions);
  }

  void listen({String dcName, String dcDesc, String vin, String profile}) {
    _currentState.setGeolocatorStreamState(GeolocatorStreamState.listening);
    _currentState.initialPositions();
    _currentState.initialTrip(
        name: dcName, description: dcDesc, vin: vin, profile: profile);
    _positionStreamSubscription = _positionStream
        .listen((position) => _currentState.addPositionToPositions(position));
  }

  void pause() {
    _currentState.setGeolocatorStreamState(GeolocatorStreamState.dislistened);
    _positionStreamSubscription.pause();
  }

  void resume() {
    _currentState.setGeolocatorStreamState(GeolocatorStreamState.resume);
    _positionStreamSubscription.resume();
  }

  void cancel() {
    _currentState.setGeolocatorStreamState(GeolocatorStreamState.dislistened);
    _positionStreamSubscription.cancel();
  }
}
