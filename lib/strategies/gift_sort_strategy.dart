import '../../models/gift.dart';

abstract class GiftSortStrategy {
  List<Gift> sort(List<Gift> gifts);
}
