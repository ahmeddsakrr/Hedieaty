import '../../old_models/old_gift.dart';
import 'gift_sort_strategy.dart';

class SortByGiftName implements GiftSortStrategy {
  @override
  List<OldGift> sort(List<OldGift> gifts) {
    gifts.sort((a, b) => a.name.compareTo(b.name));
    return gifts;
  }
}
