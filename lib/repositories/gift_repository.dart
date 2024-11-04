import '../database/app_database.dart';
import '../database/dao/gift_dao.dart';
import '../database/models/gift_table.dart';

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
}
