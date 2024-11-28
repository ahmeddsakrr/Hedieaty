import '../../old_models/old_gift.dart';
import 'gift_sort_strategy.dart';

class GiftSortContext {
  GiftSortStrategy? _strategy;

  void setSortStrategy(GiftSortStrategy strategy) {
    _strategy = strategy;
  }

  List<OldGift> sortGifts(List<OldGift> gifts) {
    return _strategy != null ? _strategy!.sort(gifts) : gifts;
  }
}
