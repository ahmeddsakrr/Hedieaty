import '../local/database/app_database.dart';
import '../local/database/dao/pledge_dao.dart';

class PledgeRepository {
  final PledgeDao _pledgeDao;
  PledgeRepository(AppDatabase db) : _pledgeDao = PledgeDao(db);

  Future<void> addPledge(Pledge pledge) async {
    await _pledgeDao.insertPledge(pledge);
  }

  Stream<List<Pledge>> getAllPledges() {
    return _pledgeDao.watchAllPledges();
  }

  Future<List<Pledge>> getPledgesForUser(String phoneNumber) {
    return _pledgeDao.getPledgesForUser(phoneNumber);
  }

  Future<void> deletePledge(String phoneNumber, int giftId) async {
    await _pledgeDao.deletePledge(phoneNumber, giftId);
  }
}
