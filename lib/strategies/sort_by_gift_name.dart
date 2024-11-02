import '../../old_models/gift.dart';
import 'gift_sort_strategy.dart';

class SortByGiftName implements GiftSortStrategy {
  @override
  List<Gift> sort(List<Gift> gifts) {
    gifts.sort((a, b) => a.name.compareTo(b.name));
    return gifts;
  }
}
