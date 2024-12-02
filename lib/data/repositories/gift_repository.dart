import '../adapters/gift_adapter.dart';
import '../local/database/app_database.dart';
import '../local/database/dao/gift_dao.dart';
import '../remote/firebase/dao/gift_dao.dart' as RemoteGiftDao;
import '../remote/firebase/models/gift.dart' as RemoteGift;

class GiftRepository {
  final GiftDao _localGiftDao;
  final RemoteGiftDao.GiftDAO _remoteGiftDao = RemoteGiftDao.GiftDAO();
  GiftRepository(AppDatabase db) : _localGiftDao = GiftDao(db);

  Future<void> createGift(RemoteGift.Gift gift) async {
    await _remoteGiftDao.createGift(gift);
    final localGift = GiftAdapter.fromRemote(gift);
    await _localGiftDao.insertOrUpdateGift(localGift);
  }

  Stream<List<Gift>> getAllGifts() {
    return _localGiftDao.watchAllGifts();
  }

  Future<List<RemoteGift.Gift>> getGiftsForEvent(int eventId) async {
    try {
      final remoteGifts = await _remoteGiftDao.getGiftsByEvent(eventId);
      for (final remoteGift in remoteGifts) {
        final localGift = GiftAdapter.fromRemote(remoteGift);
        await _localGiftDao.insertOrUpdateGift(localGift);
      }
      return remoteGifts;
    } catch (e) {
      final localGifts = await _localGiftDao.getGiftsForEvent(eventId);
      return localGifts.map((g) => GiftAdapter.fromLocal(g)).toList();
    }
  }

  Future<void> updateGift(RemoteGift.Gift gift) async {
    await _remoteGiftDao.updateGift(gift);
    final localGift = GiftAdapter.fromRemote(gift);
    await _localGiftDao.insertOrUpdateGift(localGift);
  }

  Future<void> deleteGift(int giftId) async {
    await _remoteGiftDao.deleteGift(giftId);
    await _localGiftDao.deleteGift(giftId);
  }

  Future<RemoteGift.Gift> getGift(int giftId) async {
    return await _remoteGiftDao.getGift(giftId);
  }
}
