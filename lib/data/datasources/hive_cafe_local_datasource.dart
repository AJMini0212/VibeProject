import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/cafe_model.dart';
import 'cafe_local_datasource.dart';

class CafeCache {
  final String query;
  final double latitude;
  final double longitude;
  final List<Map<String, dynamic>> cafeData;
  final int timestamp;
  final int ttl;

  CafeCache({
    required this.query,
    required this.latitude,
    required this.longitude,
    required this.cafeData,
    required this.timestamp,
    this.ttl = 3600,
  });

  bool get isExpired {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now - timestamp > ttl;
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'latitude': latitude,
      'longitude': longitude,
      'cafeData': cafeData,
      'timestamp': timestamp,
      'ttl': ttl,
    };
  }

  factory CafeCache.fromJson(Map<String, dynamic> json) {
    return CafeCache(
      query: json['query'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      cafeData: List<Map<String, dynamic>>.from(
        (json['cafeData'] as List).map(
          (e) => Map<String, dynamic>.from(e as Map),
        ),
      ),
      timestamp: json['timestamp'] as int,
      ttl: json['ttl'] as int? ?? 3600,
    );
  }
}

class HiveCafeLocalDatasource implements CafeLocalDatasource {
  static const String _boxName = 'cafes';
  late Box<String> _box;

  @override
  Future<void> initializeHive() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  String _generateCacheKey(String query, double latitude, double longitude) {
    final key = '$query${latitude}_$longitude';
    return sha256.convert(utf8.encode(key)).toString();
  }

  @override
  Future<void> saveCafes(
    String query,
    double latitude,
    double longitude,
    List<CafeModel> cafes,
  ) async {
    final cacheKey = _generateCacheKey(query, latitude, longitude);
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final cache = CafeCache(
      query: query,
      latitude: latitude,
      longitude: longitude,
      cafeData: cafes.map((cafe) => cafe.toJson()).toList(),
      timestamp: now,
      ttl: 3600,
    );

    await _box.put(cacheKey, jsonEncode(cache.toJson()));
  }

  @override
  Future<List<CafeModel>?> getCafes(
    String query,
    double latitude,
    double longitude,
  ) async {
    final cacheKey = _generateCacheKey(query, latitude, longitude);
    final cached = _box.get(cacheKey);

    if (cached == null) {
      return null;
    }

    try {
      final json = jsonDecode(cached) as Map<String, dynamic>;
      final cache = CafeCache.fromJson(json);

      if (cache.isExpired) {
        return null;
      }

      return cache.cafeData
          .map((data) => CafeModel.fromJson(data))
          .toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<CafeModel>?> getCafesWithoutExpiry(
    String query,
    double latitude,
    double longitude,
  ) async {
    final cacheKey = _generateCacheKey(query, latitude, longitude);
    final cached = _box.get(cacheKey);

    if (cached == null) {
      return null;
    }

    try {
      final json = jsonDecode(cached) as Map<String, dynamic>;
      final cache = CafeCache.fromJson(json);
      return cache.cafeData
          .map((data) => CafeModel.fromJson(data))
          .toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearExpiredCaches() async {
    final keysToDelete = <String>[];

    for (final key in _box.keys) {
      final cached = _box.get(key);
      if (cached == null) continue;

      try {
        final json = jsonDecode(cached) as Map<String, dynamic>;
        final cache = CafeCache.fromJson(json);
        if (cache.isExpired) {
          keysToDelete.add(key as String);
        }
      } catch (e) {
        keysToDelete.add(key as String);
      }
    }

    for (final key in keysToDelete) {
      await _box.delete(key);
    }
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }
}
