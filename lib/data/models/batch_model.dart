import 'package:json_annotation/json_annotation.dart';
import 'package:akuhadir/data/models/training_model.dart';
part 'batch_model.g.dart';

@JsonSerializable()
class BatchModel {
  final int id;
  @JsonKey(name: 'batch_ke')
  final dynamic batchKe;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  final List<TrainingModel>? trainings;

  BatchModel({
    required this.id,
    this.batchKe,
    this.startDate,
    this.endDate,
    this.trainings,
  });

  String get displayName => 'Batch $batchKe';

  factory BatchModel.fromJson(Map<String, dynamic> json) => _$BatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BatchModelToJson(this);
}
