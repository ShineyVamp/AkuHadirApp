import 'package:json_annotation/json_annotation.dart';

part 'training_model.g.dart';

@JsonSerializable()
class TrainingModel {
  final int id;
  final String title;
  final String? description;

  TrainingModel({
    required this.id,
    required this.title,
    this.description,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) => _$TrainingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingModelToJson(this);
}
