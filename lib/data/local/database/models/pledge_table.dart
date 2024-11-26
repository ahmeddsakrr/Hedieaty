import 'package:drift/drift.dart';
import 'gift_table.dart';
import 'user_table.dart';

class Pledges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get giftId => integer().customConstraint('REFERENCES gifts(id) NOT NULL')();
  TextColumn get userId => text().customConstraint('REFERENCES users(phone_number) NOT NULL')();
  DateTimeColumn get pledgeDate => dateTime()();
}