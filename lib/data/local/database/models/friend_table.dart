import 'package:drift/drift.dart';
import 'user_table.dart';

class Friends extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().customConstraint('REFERENCES users(phoneNumber) NOT NULL')();
  TextColumn get friendUserId => text().customConstraint('REFERENCES users(phoneNumber) NOT NULL')();
}