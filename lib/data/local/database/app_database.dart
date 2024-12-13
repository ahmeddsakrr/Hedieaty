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
  // static instance for the singleton pattern
  static AppDatabase? _instance;
  // private constructor
  AppDatabase._() : super(_openConnection());
  // factory constructor to return the singleton instance
  factory AppDatabase() {
    _instance ??= AppDatabase._();
    return _instance!;
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from == 1) {
        await migrator.addColumn(events, events.isPublished);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
