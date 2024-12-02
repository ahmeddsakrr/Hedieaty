import '../../data/remote/firebase/models/gift.dart';

import 'gift_sort_strategy.dart';

class SortByGiftStatus implements GiftSortStrategy {
  @override
  List<Gift> sort(List<Gift> gifts) {
    gifts.sort((a, b) => a.status.toLowerCase().compareTo(b.status.toLowerCase()));
    return gifts;
  }
}
