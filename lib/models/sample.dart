import '../repositories/api.dart';

class Sample {
  const Sample({required this.id, required this.title});

  final int id;
  final String title;

  factory Sample.fromJson(JsonMap json) =>
      Sample(id: json['id'] as int, title: json['title'] as String);

  JsonMap toJson() => {'title': title};
}
