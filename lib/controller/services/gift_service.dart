import '../../data/local/database/app_database.dart';
import '../../data/repositories/gift_repository.dart';

class GiftService {
  final GiftRepository _giftRepository;

  GiftService(this._giftRepository);

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

  // unpledge gift

}
