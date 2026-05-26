import 'dart:convert';
import 'package:http/http.dart' as http;

class NaverApiClient {
  static const String _baseUrl = 'https://openapi.naver.com/v1/search/local.json';

  final String clientId;
  final String clientSecret;
  final http.Client _httpClient;

  NaverApiClient({
    required this.clientId,
    required this.clientSecret,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  Future<List<dynamic>> searchPlaces({
    required String query,
    required double latitude,
    required double longitude,
    int display = 15,
    int start = 1,
    String sort = 'distance',
  }) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'query': query,
        'display': display.toString(),
        'start': start.toString(),
        'sort': sort,
        'coords': '$longitude,$latitude',
      },
    );

    try {
      final response = await _httpClient.get(
        uri,
        headers: {
          'X-Naver-Client-Id': clientId,
          'X-Naver-Client-Secret': clientSecret,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final items = (json['items'] as List<dynamic>?) ?? [];
        return items;
      } else if (response.statusCode == 400) {
        throw Exception('잘못된 요청: ${response.body}');
      } else if (response.statusCode == 403) {
        throw Exception('API 키 오류 - Naver API 설정을 확인하세요');
      } else {
        throw Exception('Naver API 오류: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
