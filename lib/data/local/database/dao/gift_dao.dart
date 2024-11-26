import '../app_database.dart';

class GiftDao {
  final AppDatabase _db;
  GiftDao(this._db);

  Future<void> insertGift(Gift gift) async {
    await _db.into(_db.gifts).insert(gift);
  }

  Stream<List<Gift>> watchAllGifts() {
    return _db.select(_db.gifts).watch();
  }

  Future<List<Gift>> getGiftsForEvent(int eventId) {
    return (_db.select(_db.gifts)..where((g) => g.eventId.equals(eventId))).get();
  }

  Future<void> updateGift(Gift updatedGift) async {
    await _db.update(_db.gifts).replace(updatedGift);
  }

  Future<void> deleteGift(int giftId) async {
    await (_db.delete(_db.gifts)..where((g) => g.id.equals(giftId))).go();
  }
}
