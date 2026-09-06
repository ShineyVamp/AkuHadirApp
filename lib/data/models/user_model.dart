import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int? id;
  final String? name;
  final String? email;
  @JsonKey(name: 'jenis_kelamin')
  final String? jenisKelamin;
  @JsonKey(name: 'profile_photo')
  final String? profilePhoto;
  @JsonKey(name: 'profile_photo_url')
  final String? profilePhotoUrl;
  @JsonKey(name: 'batch_id')
  final dynamic batchId;
  @JsonKey(name: 'batch_ke')
  final dynamic batchKe;
  @JsonKey(name: 'training_id')
  final dynamic trainingId;
  @JsonKey(name: 'training_title')
  final String? trainingTitle;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.jenisKelamin,
    this.profilePhoto,
    this.profilePhotoUrl,
    this.batchId,
    this.batchKe,
    this.trainingId,
    this.trainingTitle,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> rawJson) {
    final json =
        (rawJson.containsKey('user') && rawJson['user'] is Map<String, dynamic>)
            ? rawJson['user'] as Map<String, dynamic>
            : (rawJson.containsKey('data') && rawJson['data'] is Map<String, dynamic>)
                ? rawJson['data'] as Map<String, dynamic>
                : rawJson;
    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? jenisKelamin,
    String? profilePhoto,
    String? profilePhotoUrl,
    dynamic batchId,
    dynamic batchKe,
    dynamic trainingId,
    String? trainingTitle,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      batchId: batchId ?? this.batchId,
      batchKe: batchKe ?? this.batchKe,
      trainingId: trainingId ?? this.trainingId,
      trainingTitle: trainingTitle ?? this.trainingTitle,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
