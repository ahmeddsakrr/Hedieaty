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

  Stream<List<RemoteGift.Gift>> getGiftsForEvent(int eventId) {
    return _remoteGiftDao
        .getGiftsByEvent(eventId)
        .handleError((error) {
      return _localGiftDao
          .getGiftsForEvent(eventId)
          .map((localGifts) => localGifts.map((g) => GiftAdapter.fromLocal(g)).toList());
    }).map((remoteGifts) {
      for (final remoteGift in remoteGifts) {
        final localGift = GiftAdapter.fromRemote(remoteGift);
        _localGiftDao.insertOrUpdateGift(localGift);
      }
      return remoteGifts;
    });
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

  Stream<RemoteGift.Gift> getGift(int giftId) {
    return _remoteGiftDao.getGift(giftId);
  }

  Future<void> updateGiftStatus(int giftId, String status) async {
    await _remoteGiftDao.updateGiftStatus(giftId, status);
    final gift = await getGift(giftId).first;
    await _localGiftDao.insertOrUpdateGift(GiftAdapter.fromRemote(gift));
  }
}
