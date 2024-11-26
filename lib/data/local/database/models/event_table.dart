import 'package:drift/drift.dart';

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().customConstraint('REFERENCES users(phoneNumber) NOT NULL')();
  TextColumn get name => text()();
  TextColumn get category => text()();
  DateTimeColumn get eventDate => dateTime()();
}
