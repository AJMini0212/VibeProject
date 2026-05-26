import '../models/cafe_model.dart';

class NaverPlaceConverter {
  static String _removeHtmlTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  static String _generateId(String address, double latitude, double longitude) {
    return 'naver_$address$latitude$longitude'.hashCode.toString();
  }

  static CafeModel convertNaverToModel(Map<String, dynamic> item) {
    final title = item['title'] as String? ?? '';
    final roadAddress = item['roadAddress'] as String? ?? '';
    final mapx = double.tryParse(item['mapx'] as String? ?? '0') ?? 0.0;
    final mapy = double.tryParse(item['mapy'] as String? ?? '0') ?? 0.0;

    return CafeModel(
      id: _generateId(roadAddress, mapy, mapx),
      name: _removeHtmlTags(title),
      address: roadAddress.isEmpty ? (item['address'] as String? ?? '') : roadAddress,
      latitude: mapy,
      longitude: mapx,
      rating: 0.0,
      reviewCount: 0,
    );
  }

  static List<CafeModel> convertNaverListToModels(List<dynamic> items) {
    return items
        .whereType<Map<String, dynamic>>()
        .map((item) => convertNaverToModel(item))
        .toList();
  }
}
