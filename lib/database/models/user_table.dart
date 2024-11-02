import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get phoneNumber => text().customConstraint('PRIMARY KEY NOT NULL')();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get profilePictureUrl => text().nullable()();
}
