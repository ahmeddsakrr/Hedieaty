import '../local/database/app_database.dart';
import '../remote/firebase/models/pledge.dart' as RemotePledge;

class PledgeAdapter {
  static Pledge fromRemote(RemotePledge.Pledge pledge) {
    return Pledge(
      id: pledge.id,
      giftId: pledge.giftId,
      userId: pledge.userId,
      pledgeDate: pledge.pledgeDate,
    );
  }

  static RemotePledge.Pledge fromLocal(Pledge pledge) {
    return RemotePledge.Pledge(
      id: pledge.id,
      giftId: pledge.giftId,
      userId: pledge.userId,
      pledgeDate: pledge.pledgeDate,
    );
  }
}
