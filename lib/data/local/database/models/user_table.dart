import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get phoneNumber => text()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get profilePictureUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {phoneNumber};
}
