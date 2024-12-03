import 'package:hedieaty/controller/enums/gift_status.dart';
import 'package:hedieaty/controller/services/gift_service.dart';

import '../../data/local/database/app_database.dart';
import '../../data/repositories/pledge_repository.dart';
import '../../data/remote/firebase/models/gift.dart' as RemoteGift;

class PledgeService {
  final PledgeRepository _pledgeRepository;
  final GiftService _giftService;

  PledgeService(AppDatabase db) : _pledgeRepository = PledgeRepository(db), _giftService = GiftService(db);

  Stream<List<RemoteGift.Gift>> getPledgedGiftsForUser(String phoneNumber) async* {
    await for (final pledges in _pledgeRepository.getPledgesForUser(phoneNumber)) {
      final giftStreams = pledges.map((pledge) => _giftService.getGift(pledge.giftId));
      await for (final gift in Stream.fromIterable(giftStreams).asyncMap((giftStream) => giftStream.first)) {
        yield [gift].whereType<RemoteGift.Gift>().toList();
      }
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

  Future<void> unpledgeGift(String phoneNumber, int giftId) async {
    await _pledgeRepository.deletePledge(phoneNumber, giftId);
    // Update the status of the gift to available
    final gift = await _giftService.getGift(giftId).first;
    await _giftService.updateGiftStatus(gift.id, GiftStatus.available);
  }
}
