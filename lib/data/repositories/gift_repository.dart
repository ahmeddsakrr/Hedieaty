import '../local/database/app_database.dart';
import '../local/database/dao/gift_dao.dart';

class GiftRepository {
  final GiftDao _giftDao;
  GiftRepository(AppDatabase db) : _giftDao = GiftDao(db);

  Future<void> addGift(Gift gift) async {
    await _giftDao.insertGift(gift);
  }

  Stream<List<Gift>> getAllGifts() {
    return _giftDao.watchAllGifts();
  }

  Future<List<Gift>> getGiftsForEvent(int eventId) {
    return _giftDao.getGiftsForEvent(eventId);
  }

  Future<void> updateGift(Gift updatedGift) async {
    await _giftDao.updateGift(updatedGift);
  }

  Future<void> deleteGift(int giftId) async {
    await _giftDao.deleteGift(giftId);
  }

  Future<Gift> getGift(int giftId) async {
    return await _giftDao.getGift(giftId);
  }
}
