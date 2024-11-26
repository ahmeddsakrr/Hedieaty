import 'package:drift/drift.dart';

class Pledges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get giftId => integer().customConstraint('REFERENCES gifts(id) NOT NULL')();
  TextColumn get userId => text().customConstraint('REFERENCES users(phoneNumber) NOT NULL')();
  DateTimeColumn get pledgeDate => dateTime()();
}