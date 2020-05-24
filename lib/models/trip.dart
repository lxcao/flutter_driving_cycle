import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
  final String route_id;
  final String name;
  final String description;
  List<double> start;
  List<double> end;
  final String profile;
  final String vin;
  List<List<double>> points;

  Trip({
    @required this.route_id,
    @required this.name,
    @required this.description,
    @required this.start,
    @required this.end,
    @required this.profile,
    @required this.vin,
    @required this.points,
  });

  //Map tripMap = jsonDecode(jsonString);
  //var trip = Trip.fromJson(tripMap);
  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  //String json = jsonEncode(trip);
  Map<String, dynamic> toJson() => _$TripToJson(this);
}
