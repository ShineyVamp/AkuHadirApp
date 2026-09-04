// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchModel _$BatchModelFromJson(Map<String, dynamic> json) => BatchModel(
  id: (json['id'] as num).toInt(),
  batchKe: json['batch_ke'],
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  trainings: (json['trainings'] as List<dynamic>?)
      ?.map((e) => TrainingModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BatchModelToJson(BatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'batch_ke': instance.batchKe,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'trainings': instance.trainings,
    };
