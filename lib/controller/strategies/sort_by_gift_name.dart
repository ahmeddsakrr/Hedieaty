import 'package:hedieaty/data/local/database/app_database.dart';

import 'gift_sort_strategy.dart';

class SortByGiftName implements GiftSortStrategy {
  @override
  List<Gift> sort(List<Gift> gifts) {
    gifts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return gifts;
  }
}
