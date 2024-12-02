import '../../data/remote/firebase/models/gift.dart';
import 'gift_sort_strategy.dart';

class SortByGiftCategory implements GiftSortStrategy {
  @override
  List<Gift> sort(List<Gift> gifts) {
    gifts.sort((a, b) => a.category.toLowerCase().compareTo(b.category.toLowerCase()));
    return gifts;
  }
}
