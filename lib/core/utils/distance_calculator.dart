import 'dart:math';

class DistanceCalculator {
  static const double earthRadiusKm = 6371.0;

  /// Haversine 공식을 사용하여 두 좌표 간 거리를 킬로미터 단위로 계산
  ///
  /// [userLat], [userLng]: 사용자의 위도, 경도
  /// [cafeLat], [cafeLng]: 카페의 위도, 경도
  /// 반환: 킬로미터 단위의 거리
  static double getDistance(
    double userLat,
    double userLng,
    double cafeLat,
    double cafeLng,
  ) {
    final dLat = _toRadian(cafeLat - userLat);
    final dLng = _toRadian(cafeLng - userLng);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadian(userLat)) *
            cos(_toRadian(cafeLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  /// 도(degree)를 라디안(radian)으로 변환
  static double _toRadian(double degree) {
    return degree * pi / 180;
  }

  /// 거리를 읽기 좋은 형식으로 포맷팅 (예: 1.2 km, 250 m)
  static String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).toStringAsFixed(0)} m';
    } else if (distanceKm < 10) {
      return '${distanceKm.toStringAsFixed(1)} km';
    } else {
      return '${distanceKm.toStringAsFixed(0)} km';
    }
  }
}
