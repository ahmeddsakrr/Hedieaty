import 'package:hedieaty/controller/enums/gift_status.dart';
import 'package:hedieaty/controller/services/event_service.dart';
import 'package:hedieaty/controller/services/user_service.dart';

import '../../data/local/database/app_database.dart';
import '../../data/repositories/gift_repository.dart';
import '../../data/remote/firebase/models/gift.dart' as RemoteGift;
import '../../data/remote/firebase/models/user.dart' as RemoteUser;
import '../../data/remote/firebase/models/event.dart' as RemoteEvent;

class GiftService {
  final GiftRepository _giftRepository;
  final EventService _eventService;
  final UserService _userService;

  GiftService(AppDatabase db) : _giftRepository = GiftRepository(db), _eventService = EventService(db), _userService = UserService(db);

  Stream<List<RemoteGift.Gift>> getGiftsForEvent(int eventId) {
    return _giftRepository.getGiftsForEvent(eventId);
  }

  Future<void> addGift(RemoteGift.Gift gift) async {
    await _giftRepository.createGift(gift);
  }

  Future<void> updateGift(RemoteGift.Gift updatedGift) async {
    await _giftRepository.updateGift(updatedGift);
  }

  Future<void> deleteGift(int giftId) async {
    await _giftRepository.deleteGift(giftId);
  }

  Stream<RemoteGift.Gift> getGift(int giftId) {
    return _giftRepository.getGift(giftId);
  }

  Future<RemoteUser.User?> getUserForGift(int giftId) async {
    final gift = await getGift(giftId).first;
    final event = await _eventService.getEvent(gift.eventId).first;
    return await _userService.getUser(event.userId);
  }


  Future<Stream<RemoteEvent.Event>> getEventForGift(int giftId) async {
    final gift =  await getGift(giftId).first;
    return await _eventService.getEvent(gift.eventId);
  }

  Future<void> updateGiftStatus(int giftId, GiftStatus status) async {
    await _giftRepository.updateGiftStatus(giftId, status.name);
  }
}
