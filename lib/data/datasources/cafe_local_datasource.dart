import '../models/cafe_model.dart';

abstract class CafeLocalDatasource {
  Future<void> initializeHive();
  Future<void> saveCafes(String query, double latitude, double longitude, List<CafeModel> cafes);
  Future<List<CafeModel>?> getCafes(String query, double latitude, double longitude);
  Future<List<CafeModel>?> getCafesWithoutExpiry(String query, double latitude, double longitude);
  Future<void> clearExpiredCaches();
  Future<void> clearAll();
}
