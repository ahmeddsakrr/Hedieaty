import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'app_database.dart';

class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  Future<void> seed() async {
    await _insertUsers();
    await _insertEvents();
    await _insertGifts();
    await _insertFriends();
    await _insertPledges();
  }

  Future<void> _insertUsers() async {
    final users = [
      const UsersCompanion(
        phoneNumber: Value('1234567890'),
        name: Value('John Doe'),
        email: Value('johndoe@example.com'),
        // profilePictureUrl: Value('https://example.com/john.jpg'),
      ),
      const UsersCompanion(
        phoneNumber: Value('0987654321'),
        name: Value('Jane Smith'),
        email: Value('janesmith@example.com'),
        // profilePictureUrl: Value('https://example.com/jane.jpg'),
      ),
    ];

    for (var user in users) {
      await db.into(db.users).insertOnConflictUpdate(user);
    }
    if (kDebugMode) {
      print('Users inserted');
    }
  }

  Future<void> _insertEvents() async {
    final events = [
      EventsCompanion(
        userId: const Value('1234567890'),
        name: const Value('Birthday Party'),
        category: const Value('Personal'),
        eventDate: Value(DateTime.now().add(const Duration(days: 10))),
      ),
      EventsCompanion(
        userId: const Value('0987654321'),
        name: const Value('Office Meeting'),
        category: const Value('Work'),
        eventDate: Value(DateTime.now().add(const Duration(days: 15))),
      ),
    ];

    for (var event in events) {
      await db.into(db.events).insertOnConflictUpdate(event);
    }
    if (kDebugMode) {
      print('Events inserted');
    }
  }

  Future<void> _insertGifts() async {
    final gifts = [
      const GiftsCompanion(
        eventId: Value(1),
        name: Value('Chocolate Box'),
        description: Value('Delicious assorted chocolates.'),
        category: Value('Food'),
        price: Value(25.99),
        // imageUrl: Value('https://example.com/chocolates.jpg'),
        status: Value('Available'),
      ),
      const GiftsCompanion(
        eventId: Value(2),
        name: Value('Planner'),
        description: Value('A stylish office planner.'),
        category: Value('Stationery'),
        price: Value(15.50),
        // imageUrl: Value('https://example.com/planner.jpg'),
        status: Value('Available'),
      ),
    ];

    for (var gift in gifts) {
      await db.into(db.gifts).insertOnConflictUpdate(gift);
    }
    if (kDebugMode) {
      print('Gifts inserted');
    }
  }

  Future<void> _insertFriends() async {
    final friends = [
      const FriendsCompanion(
        userId: Value('1234567890'),
        friendUserId: Value('0987654321'),
      ),
      const FriendsCompanion(
        userId: Value('0987654321'),
        friendUserId: Value('1234567890'),
      ),
    ];

    for (var friend in friends) {
      await db.into(db.friends).insertOnConflictUpdate(friend);
    }
    if (kDebugMode) {
      print('Friends inserted');
    }
  }

  Future<void> _insertPledges() async {
    final pledges = [
      PledgesCompanion(
        userId: const Value('1234567890'),
        giftId: const Value(1),
        pledgeDate: Value(DateTime.now()),
      ),
      PledgesCompanion(
        userId: const Value('0987654321'),
        giftId: const Value(2),
        pledgeDate: Value(DateTime.now()),
      ),
    ];

    for (var pledge in pledges) {
      await db.into(db.pledges).insertOnConflictUpdate(pledge);
    }
    if (kDebugMode) {
      print('Pledges inserted');
    }
  }
}
