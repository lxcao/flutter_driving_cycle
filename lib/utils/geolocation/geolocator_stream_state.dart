import 'package:flutter/foundation.dart';
import 'package:flutter_driving_cycle/models/trip.dart';
import 'package:geolocator/geolocator.dart';

enum GeolocatorStreamState { denied, listening, pause, resume, dislistened }

class GeolocatorAppStreamState with ChangeNotifier {
  GeolocatorStreamState _geolocatorStreamState =
      GeolocatorStreamState.dislistened;
  Trip _trip;
  List<double> _point;

  List<Position> _positions = List<Position>();

  void initialPositions() {
    _positions = List<Position>();
  }

  void addPositionToPositions(Position _position) {
    _positions.add(_position);
    notifyListeners();
  }

  List<Position> get getPositions => _positions;

  void initialTrip(
      {String name, String description, String profile, String vin}) {
    _trip = Trip(
        route_id: DateTime.now().toString(),
        name: name,
        description: description,
        start: new List<double>(),
        end: new List<double>(),
        points: new List<List<double>>(),
        profile: profile,
        vin: vin);
  }

  void addPositionsToTrip(List<Position> positions) {
    _trip.start.add(_positions[0].latitude);
    _trip.start.add(_positions[0].longitude);
    _trip.end.add(_positions[_positions.length - 1].latitude);
    _trip.end.add(_positions[_positions.length - 1].longitude);
    _positions.forEach((position) {
      List<double> point = new List<double>();
      point.add(position.latitude);
      point.add(position.longitude);
      _trip.points.add(point);
    });
    notifyListeners();
  }

  Trip get getTrip => _trip;

  void addPointToTrip(List<double> point) {
    _point = point;
    _trip.points.add(point);
    notifyListeners();
  }

  List<double> get getPoint => _point;

  void setGeolocatorStreamState(GeolocatorStreamState state) {
    _geolocatorStreamState = state;
    notifyListeners();
  }

  GeolocatorStreamState get getGeolocatorStreamState => _geolocatorStreamState;
}
