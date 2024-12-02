import 'package:hedieaty/controller/utils/date_utils.dart';

class Pledge {
  final int id;
  final int giftId;
  final String userId;
  final DateTime pledgeDate;

  Pledge({
    required this.id,
    required this.giftId,
    required this.userId,
    required this.pledgeDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gift_id': giftId,
      'user_id': userId,
      'pledge_date': getFormattedDate(pledgeDate),
    };
  }

  factory Pledge.fromMap(Map<String, dynamic> map) {
    return Pledge(
      id: map['id'],
      giftId: map['gift_id'],
      userId: map['user_id'],
      pledgeDate: parseFormattedDate(map['pledge_date']),
    );
  }
}
