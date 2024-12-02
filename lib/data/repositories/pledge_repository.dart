import '../adapters/pledge_adapter.dart';
import '../local/database/app_database.dart';
import '../local/database/dao/pledge_dao.dart';
import '../remote/firebase/dao/pledge_dao.dart' as RemotePledgeDao;
import '../remote/firebase/models/pledge.dart' as RemotePledge;

class PledgeRepository {
  final PledgeDao _localPledgeDao;
  final RemotePledgeDao.PledgeDAO _remotePledgeDao = RemotePledgeDao.PledgeDAO();
  PledgeRepository(AppDatabase db) : _localPledgeDao = PledgeDao(db);

  Future<void> createPledge(RemotePledge.Pledge pledge) async {
    await _remotePledgeDao.createPledge(pledge);
    final localPledge = PledgeAdapter.fromRemote(pledge);
    await _localPledgeDao.insertOrUpdatePledge(localPledge);
  }

  Stream<List<RemotePledge.Pledge>> getPledgesForUser(String userId) {
    return _remotePledgeDao
        .getPledgesByUser(userId)
        .handleError((error) {
      return _localPledgeDao
          .getPledgesForUser(userId)
          .map((localPledges) => localPledges.map((p) => PledgeAdapter.fromLocal(p)).toList());
    }).map((remotePledges) {
      for (final remotePledge in remotePledges) {
        final localPledge = PledgeAdapter.fromRemote(remotePledge);
        _localPledgeDao.insertOrUpdatePledge(localPledge);
      }
      return remotePledges;
    });
  }


  Future<void> deletePledge(String phoneNumber, int giftId) async {
    await _remotePledgeDao.deletePledge(phoneNumber, giftId);
    await _localPledgeDao.deletePledge(phoneNumber, giftId);
  }
}
