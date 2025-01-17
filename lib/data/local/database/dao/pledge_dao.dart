import 'package:drift/drift.dart';

import '../app_database.dart';

class PledgeDao {
  final AppDatabase _db;
  PledgeDao(this._db);

  Future<void> insertPledge(Pledge pledge) async {
    await _db.into(_db.pledges).insert(pledge);
  }

  Stream<List<Pledge>> watchAllPledges() {
    return _db.select(_db.pledges).watch();
  }

  Stream<List<Pledge>> getPledgesForUser(String phoneNumber) {
    return (_db.select(_db.pledges)..where((p) => p.userId.equals(phoneNumber))).watch();
  }

  Future<void> deletePledge(String phoneNumber, int giftId) async {
    await (_db.delete(_db.pledges)..where((p) => p.userId.equals(phoneNumber) & p.giftId.equals(giftId))).go();
  }

  Future<void> insertOrUpdatePledge(Pledge pledge) async {
    await _db.into(_db.pledges).insertOnConflictUpdate(pledge);
  }
}
