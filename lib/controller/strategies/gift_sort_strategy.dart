import '../../old_models/old_gift.dart';

abstract class GiftSortStrategy {
  List<OldGift> sort(List<OldGift> gifts);
}
