import '../errors/result.dart';

abstract class ApiClientContract {
  Future<Result<Map<String, dynamic>>> getJson(
    String path, {
    Map<String, String> headers,
    Map<String, String> query,
  });

  Future<Result<Map<String, dynamic>>> postJson(
    String path, {
    Map<String, String> headers,
    Map<String, dynamic> body,
  });
}
