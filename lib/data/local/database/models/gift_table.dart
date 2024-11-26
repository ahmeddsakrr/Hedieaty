import 'package:drift/drift.dart';

class Gifts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId => integer().customConstraint('REFERENCES events(id) NOT NULL')();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text()();
  RealColumn get price => real().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get status => text()();
}
