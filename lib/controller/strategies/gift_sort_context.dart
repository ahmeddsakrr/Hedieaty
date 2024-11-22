import '../../old_models/gift.dart';
import 'gift_sort_strategy.dart';

class GiftSortContext {
  GiftSortStrategy? _strategy;

  void setSortStrategy(GiftSortStrategy strategy) {
    _strategy = strategy;
  }

  List<Gift> sortGifts(List<Gift> gifts) {
    return _strategy != null ? _strategy!.sort(gifts) : gifts;
  }
}
