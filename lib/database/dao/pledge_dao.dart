import 'package:drift/drift.dart';
import '../app_database.dart';
import '../models/pledge_table.dart';

class PledgeDao {
  final AppDatabase _db;
  PledgeDao(this._db);

  Future<void> insertPledge(Pledge pledge) async {
    await _db.into(_db.pledges).insert(pledge);
  }

  Stream<List<Pledge>> watchAllPledges() {
    return _db.select(_db.pledges).watch();
  }

  Future<List<Pledge>> getPledgesForUser(String userId) {
    return (_db.select(_db.pledges)..where((p) => p.userId.equals(userId))).get();
  }
}
