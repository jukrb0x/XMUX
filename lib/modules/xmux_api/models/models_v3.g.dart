// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models_v3.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResp _$LoginRespFromJson(Map<String, dynamic> json) {
  return LoginResp(
    json['customToken'] as String,
  );
}

GetTimetableResp _$GetTimetableRespFromJson(Map<String, dynamic> json) {
  return GetTimetableResp(
    (json['timetable'] as List)
        ?.map((e) => e == null
            ? null
            : TimetableClass.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['recentUpdateS'] == null
        ? null
        : DateTime.parse(json['recentUpdateS'] as String),
  );
}

Map<String, dynamic> _$GetTimetableRespToJson(GetTimetableResp instance) =>
    <String, dynamic>{
      'timetable': instance.timetable,
      'recentUpdateS': instance.recentUpdate?.toIso8601String(),
    };

TimetableClass _$TimetableClassFromJson(Map<String, dynamic> json) {
  return TimetableClass(
    json['cid'] as String,
    json['name'] as String,
    json['lecturer'] as String,
    json['room'] as String,
    json['day'] as int,
    TimetableClass._timeOfDayFromJson(json['start'] as String),
    TimetableClass._timeOfDayFromJson(json['end'] as String),
    TimetableClass._dayFromJson(json['startDay'] as String),
    TimetableClass._dayFromJson(json['endDay'] as String),
  );
}

Map<String, dynamic> _$TimetableClassToJson(TimetableClass instance) =>
    <String, dynamic>{
      'cid': instance.cid,
      'name': instance.name,
      'lecturer': instance.lecturer,
      'room': instance.room,
      'day': instance.day,
      'start': TimetableClass._timeOfDayToJson(instance.start),
      'end': TimetableClass._timeOfDayToJson(instance.end),
      'startDay': TimetableClass._dayToJson(instance.startDay),
      'endDay': TimetableClass._dayToJson(instance.endDay),
    };