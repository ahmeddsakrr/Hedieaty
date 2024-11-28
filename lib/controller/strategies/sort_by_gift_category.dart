import '../../old_models/old_gift.dart';
import 'gift_sort_strategy.dart';

class SortByGiftCategory implements GiftSortStrategy {
  @override
  List<OldGift> sort(List<OldGift> gifts) {
    gifts.sort((a, b) => a.category.compareTo(b.category));
    return gifts;
  }
}
