import 'package:hedieaty/controller/enums/gift_status.dart';
import 'package:hedieaty/controller/enums/notification_type.dart';
import 'package:hedieaty/controller/services/event_service.dart';
import 'package:hedieaty/controller/services/gift_service.dart';
import 'package:hedieaty/controller/services/notification_service.dart';

import '../../data/local/database/app_database.dart';
import '../../data/repositories/pledge_repository.dart';
import '../../data/remote/firebase/models/gift.dart' as RemoteGift;
import '../../data/remote/firebase/models/pledge.dart' as RemotePledge;
import '../../data/remote/firebase/models/notification.dart' as RemoteNotification;

class PledgeService {
  final PledgeRepository _pledgeRepository;
  final GiftService _giftService;
  final EventService _eventService;
  final NotificationService _notificationService;

  PledgeService(AppDatabase db) : _pledgeRepository = PledgeRepository(db),
        _giftService = GiftService(db),
        _eventService = EventService(db),
        _notificationService = NotificationService(db);

  Stream<List<RemoteGift.Gift>> getPledgedGiftsForUser(String phoneNumber) async* {
    await for (final pledges in _pledgeRepository.getPledgesForUser(phoneNumber)) {
      final giftStreams = pledges.map((pledge) => _giftService.getGift(pledge.giftId));
      final gifts = await Stream.fromIterable(giftStreams)
          .asyncMap((giftStream) => giftStream.first)
          .cast<RemoteGift.Gift>()
          .toList();
      yield gifts;
    }
  }

  Stream<List<RemoteGift.Gift>> searchPledgedGifts(String phoneNumber, String query) async* {
    final lowerQuery = query.toLowerCase();

    await for (final pledgedGifts in getPledgedGiftsForUser(phoneNumber)) {
      final filteredGifts = pledgedGifts.where((gift) {
        final name = gift.name.toLowerCase();
        final description = gift.description.toLowerCase();
        final category = gift.category.toLowerCase();
        final price = gift.price.toString();
        final status = gift.status.toLowerCase();

        return name.contains(lowerQuery) ||
            description.contains(lowerQuery) ||
            category.contains(lowerQuery) ||
            price.contains(lowerQuery) ||
            status.contains(lowerQuery);
      }).toList();

      yield filteredGifts;
    }
  }

  Future<void> _updateGiftStatusAndNotify({required int giftId, required GiftStatus newStatus, required NotificationType notificationType, required String notificationMessage,}) async {
    final gift = await _giftService.getGift(giftId).first;
    await _giftService.updateGiftStatus(gift.id, newStatus);

    final giftUser = await _giftService.getUserForGift(gift.id).first;
    final giftUserId = giftUser?.phoneNumber;

    if (giftUserId != null) {
      final notification = RemoteNotification.Notification(
        id: 0,
        userId: giftUserId,
        type: notificationType.name,
        message: notificationMessage.replaceFirst("{giftName}", gift.name),
        isRead: false,
        createdAt: DateTime.now(),
      );
      await _notificationService.createNotification(notification);
    }
  }

  Future<void> pledgeGift(RemotePledge.Pledge pledge) async {
    await _pledgeRepository.createPledge(pledge);
    await _updateGiftStatusAndNotify(
      giftId: pledge.giftId,
      newStatus: GiftStatus.pledged,
      notificationType: NotificationType.giftPledged,
      notificationMessage: "Your gift '{giftName}' has been successfully pledged.",
    );
  }

  Future<void> unpledgeGift(String phoneNumber, int giftId) async {
    await _pledgeRepository.deletePledge(phoneNumber, giftId);
    await _updateGiftStatusAndNotify(
      giftId: giftId,
      newStatus: GiftStatus.available,
      notificationType: NotificationType.giftUnpledged,
      notificationMessage: "Your gift '{giftName}' has been unpledged.",
    );
  }


  bool isAvailable(RemoteGift.Gift gift) {
    return gift.status == GiftStatus.available.name;
  }

  bool isPledged(RemoteGift.Gift gift) {
    return gift.status == GiftStatus.pledged.name;
  }

  Stream<bool> isUnpledgeable(RemoteGift.Gift gift) {
    return _eventService.getEvent(gift.eventId).map((event) {
      final today = DateTime.now();
      final todayMidnight = DateTime(today.year, today.month, today.day);
      return event.eventDate.isAfter(todayMidnight);
    });
  }

  Stream<bool> isPledgedByUser(RemoteGift.Gift gift, String phoneNumber) {
    return _pledgeRepository.getPledgesForUser(phoneNumber).map((pledges) {
      return pledges.any((pledge) => pledge.giftId == gift.id);
    });
  }
}
