import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/sample.dart';
import 'api.dart';

class SampleRepository {
  const SampleRepository(this._client);

  final ApiClient _client;

  // GET /samples
  Future<List<Sample>> fetchAll() async {
    final list = await _client.get<JsonList>('/samples');
    return list.cast<JsonMap>().map(Sample.fromJson).toList();
  }

  // GET /samples/:id
  Future<Sample> fetchById(int id) async {
    final json = await _client.get<JsonMap>('/samples/$id');
    return Sample.fromJson(json);
  }

  // POST /samples
  Future<Sample> create({required String title}) async {
    final json = await _client.post<JsonMap>(
      '/samples',
      data: {'title': title},
    );
    return Sample.fromJson(json);
  }

  // PUT /samples/:id
  Future<Sample> update(int id, {required String title}) async {
    final json = await _client.put<JsonMap>(
      '/samples/$id',
      data: {'title': title},
    );
    return Sample.fromJson(json);
  }

  // DELETE /samples/:id
  Future<void> delete(int id) async {
    await _client.delete<JsonMap>('/samples/$id');
  }
}

final sampleRepositoryProvider = Provider<SampleRepository>(
  (ref) => SampleRepository(ref.watch(apiClientProvider)),
);
