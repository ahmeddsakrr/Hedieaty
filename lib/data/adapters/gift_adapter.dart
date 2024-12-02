import '../local/database/app_database.dart';
import '../remote/firebase/models/gift.dart' as RemoteGift;

class GiftAdapter {
  static Gift fromRemote(RemoteGift.Gift gift) {
    return Gift(
      id: gift.id,
      eventId: gift.eventId,
      name: gift.name,
      description: gift.description,
      category: gift.category,
      price: gift.price,
      imageUrl: gift.imageUrl,
      status: gift.status,
    );
  }

  static RemoteGift.Gift fromLocal(Gift gift) {
    return RemoteGift.Gift(
      id: gift.id,
      eventId: gift.eventId,
      name: gift.name,
      description: gift.description ?? '',
      category: gift.category,
      price: gift.price ?? 0.0,
      imageUrl: gift.imageUrl,
      status: gift.status,
    );
  }
}
