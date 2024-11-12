import '../database/app_database.dart';
import '../repositories/gift_repository.dart';

class GiftService {
  final GiftRepository _giftRepository;

  GiftService(this._giftRepository);

  Future<List<Gift>> getGiftsForEvent(int eventId) async {
    return await _giftRepository.getGiftsForEvent(eventId);
  }
}
