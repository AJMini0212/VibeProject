import '../entities/cafe.dart';

abstract class CafeRepository {
  Future<List<Cafe>> searchCafes(
    double latitude,
    double longitude,
    String query,
  );
  Future<Cafe?> getCafeById(String id);
}
