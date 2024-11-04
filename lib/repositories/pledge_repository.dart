import '../database/app_database.dart';
import '../database/dao/pledge_dao.dart';
import '../database/models/pledge_table.dart';

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
}
