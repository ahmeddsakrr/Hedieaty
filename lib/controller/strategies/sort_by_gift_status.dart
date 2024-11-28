import '../../old_models/old_gift.dart';
import 'gift_sort_strategy.dart';

class SortByGiftStatus implements GiftSortStrategy {
  @override
  List<OldGift> sort(List<OldGift> gifts) {
    gifts.sort((a, b) => a.status.compareTo(b.status));
    return gifts;
  }
}
