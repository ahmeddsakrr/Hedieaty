import 'package:hedieaty/controller/services/event_service.dart';
import 'package:hedieaty/controller/services/user_service.dart';

import '../../data/local/database/app_database.dart';
import '../../data/repositories/gift_repository.dart';

class GiftService {
  final GiftRepository _giftRepository;
  final EventService _eventService;
  final UserService _userService;

  GiftService(AppDatabase db) : _giftRepository = GiftRepository(db), _eventService = EventService(db), _userService = UserService(db);

  Future<List<Gift>> getGiftsForEvent(int eventId) async {
    return await _giftRepository.getGiftsForEvent(eventId);
  }

  Future<void> addGift(Gift gift) async {
    await _giftRepository.addGift(gift);
  }

  Future<void> updateGift(Gift updatedGift) async {
    await _giftRepository.updateGift(updatedGift);
  }

  Future<void> deleteGift(int giftId) async {
    await _giftRepository.deleteGift(giftId);
  }

  Future<Gift> getGift(int giftId) async {
    return await _giftRepository.getGift(giftId);
  }

  Future<User?> getUserForGift(int giftId) async {
    final gift = await getGift(giftId);
    final event = await _eventService.getEvent(gift.eventId);
    return await _userService.getUser(event.userId);
  }

  Future<Event> getEventForGift(int giftId) async {
    final gift = await getGift(giftId);
    return await _eventService.getEvent(gift.eventId);
  }
}
