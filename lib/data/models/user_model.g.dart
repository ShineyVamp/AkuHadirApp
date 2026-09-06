part of 'user_model.dart';

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  jenisKelamin: json['jenis_kelamin']?.toString() ?? json['gender']?.toString(),
  profilePhoto:
      json['profile_photo']?.toString() ??
      json['photo']?.toString() ??
      json['profile_photo_url']?.toString(),
  batchId: json['batch_id'] ?? json['batchId'],
  trainingId: json['training_id'] ?? json['trainingId'] ?? json['kejuruan_id'],
  createdAt: json['created_at']?.toString(),
  updatedAt: json['updated_at']?.toString(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'jenis_kelamin': instance.jenisKelamin,
  'profile_photo': instance.profilePhoto,
  'batch_id': instance.batchId,
  'training_id': instance.trainingId,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
