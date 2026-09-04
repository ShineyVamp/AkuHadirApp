import 'package:akuhadir/core/constants/api_endpoints.dart';import 'package:akuhadir/core/network/api_client.dart';import 'package:akuhadir/data/models/batch_model.dart';import 'package:akuhadir/data/models/training_model.dart';
class MasterRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<BatchModel>> getBatches() async {
    final response = await _apiClient.get(ApiEndpoints.batches, withAuth: false);
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final list = response['data'] as List<dynamic>;
      return list.map((e) => BatchModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<TrainingModel>> getTrainings() async {
    final response = await _apiClient.get(ApiEndpoints.trainings, withAuth: false);
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final list = response['data'] as List<dynamic>;
      return list.map((e) => TrainingModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
