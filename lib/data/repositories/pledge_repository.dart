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

  Future<List<RemotePledge.Pledge>> getPledgesForUser(String userId) async {
    try {
      final remotePledges = await _remotePledgeDao.getPledgesByUser(userId);
      for (final remotePledge in remotePledges) {
        final localPledge = PledgeAdapter.fromRemote(remotePledge);
        await _localPledgeDao.insertOrUpdatePledge(localPledge);
      }
      return remotePledges;
    } catch (e) {
      final localPledges = await _localPledgeDao.getPledgesForUser(userId);
      return localPledges.map((p) => PledgeAdapter.fromLocal(p)).toList();
    }
  }

  Future<void> deletePledge(String phoneNumber, int giftId) async {
    await _remotePledgeDao.deletePledge(phoneNumber, giftId);
    await _localPledgeDao.deletePledge(phoneNumber, giftId);
  }
}
