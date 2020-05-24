// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) {
  return Trip(
    route_id: json['route_id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    start:
        (json['start'] as List)?.map((e) => (e as num)?.toDouble())?.toList(),
    end: (json['end'] as List)?.map((e) => (e as num)?.toDouble())?.toList(),
    profile: json['profile'] as String,
    vin: json['vin'] as String,
    points: (json['points'] as List)
        ?.map((e) => (e as List)?.map((e) => (e as num)?.toDouble())?.toList())
        ?.toList(),
  );
}

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'route_id': instance.route_id,
      'name': instance.name,
      'description': instance.description,
      'start': instance.start,
      'end': instance.end,
      'profile': instance.profile,
      'vin': instance.vin,
      'points': instance.points,
    };
