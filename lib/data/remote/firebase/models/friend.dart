class Friend {
  int id;
  final String userId;
  final String friendUserId;

  Friend({
    required this.id,
    required this.userId,
    required this.friendUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'friend_user_id': friendUserId,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'],
      userId: map['user_id'],
      friendUserId: map['friend_user_id'],
    );
  }
}
