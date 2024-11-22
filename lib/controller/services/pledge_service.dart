import '../../data/local/database/app_database.dart';
import '../../data/repositories/pledge_repository.dart';

class PledgeService {
  final PledgeRepository _pledgeRepository;

  PledgeService(this._pledgeRepository);

  Future<List<Pledge>> getPledgedGiftsForUser(String phoneNumber) async {
    return await _pledgeRepository.getPledgesForUser(phoneNumber);
  }

  // TODO: Implement the unpledgeGift method and update the state of the gift to available
}
