import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'models/user_table.dart';
import 'models/event_table.dart';
import 'models/friend_table.dart';
import 'models/gift_table.dart';
import 'models/pledge_table.dart';
import 'models/notification_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users, Friends, Events, Gifts, Pledges, Notifications])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(NativeDatabase.memory());

  int get schemaVersion => 1;
}
