import 'package:drift/drift.dart';
import 'user_table.dart';

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().customConstraint('REFERENCES users(phone_number) NOT NULL')();
  TextColumn get name => text()();
  TextColumn get category => text()();
  DateTimeColumn get eventDate => dateTime()();
  BoolColumn get isPublished => boolean().withDefault(const Constant(false))();
}
