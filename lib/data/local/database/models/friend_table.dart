import 'package:drift/drift.dart';
import 'user_table.dart';

class Friends extends Table {
  IntColumn get id => integer().autoIncrement()();

  @ReferenceName('userFriends')
  TextColumn get userId => text().customConstraint('REFERENCES users(phone_number) NOT NULL')();

  @ReferenceName('friendFriends')
  TextColumn get friendUserId => text().customConstraint('REFERENCES users(phone_number) NOT NULL')();
}