import 'package:hedieaty/controller/services/gift_service.dart';

import '../../data/local/database/app_database.dart';
import '../../data/repositories/pledge_repository.dart';

class PledgeService {
  final PledgeRepository _pledgeRepository;
  final GiftService _giftService;

  PledgeService(AppDatabase db) : _pledgeRepository = PledgeRepository(db), _giftService = GiftService(db);

  Future<List<Gift>> getPledgedGiftsForUser(String phoneNumber) async {
    final pledges = await _pledgeRepository.getPledgesForUser(phoneNumber);
    final gifts = await Future.wait(pledges.map((pledge) => _giftService.getGift(pledge.giftId)));
    return gifts.whereType<Gift>().toList(); // Exclude null gifts
  }

  Future<List<Gift>> searchPledgedGifts(String phoneNumber, String query) async {
    final pledgedGifts = await getPledgedGiftsForUser(phoneNumber);
    final lowerQuery = query.toLowerCase();

    return pledgedGifts.where((gift) {
      final name = gift.name.toLowerCase();
      final description = gift.description?.toLowerCase() ?? '';
      final category = gift.category.toLowerCase();
      final price = gift.price?.toString() ?? '';
      final status = gift.status.toLowerCase();

      return name.contains(lowerQuery) ||
          description.contains(lowerQuery) ||
          category.contains(lowerQuery) ||
          price.contains(lowerQuery) ||
          status.contains(lowerQuery);
    }).toList();
  }

  Future<void> unpledgeGift(String phoneNumber, int giftId) async {
    await _pledgeRepository.deletePledge(phoneNumber, giftId);
    // Update the status of the gift to available
    final gift = await _giftService.getGift(giftId);
    await _giftService.updateGift(gift.copyWith(status: 'Available'));
  }
}
