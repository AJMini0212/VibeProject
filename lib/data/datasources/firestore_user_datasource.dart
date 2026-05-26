abstract class FirestoreUserDatasource {
  Future<void> addFavorite(String uid, String cafeId);
  Future<void> removeFavorite(String uid, String cafeId);
  Future<List<String>> getFavorites(String uid);
}
