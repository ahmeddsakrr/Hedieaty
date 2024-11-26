import 'package:drift/drift.dart';

class Notifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().customConstraint('REFERENCES users(phoneNumber) NOT NULL')();
  TextColumn get type => text()();
  TextColumn get message => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}