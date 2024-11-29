import 'package:hedieaty/data/local/database/app_database.dart';


abstract class GiftSortStrategy {
  List<Gift> sort(List<Gift> gifts);
}
