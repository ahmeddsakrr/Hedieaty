import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'models/user_table.dart';
import 'models/event_table.dart';
import 'models/friend_table.dart';
import 'models/gift_table.dart';
import 'models/pledge_table.dart';
import 'models/notification_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users, Friends, Events, Gifts, Pledges, Notifications])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
