enum GiftStatus {
  available,
  pledged;

  String get name {
    switch (this) {
      case GiftStatus.available:
        return 'Available';
      case GiftStatus.pledged:
        return 'Pledged';
      default:
        return '';
    }
  }

  static GiftStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return GiftStatus.available;
      case 'pledged':
        return GiftStatus.pledged;
      default:
        return GiftStatus.available;
    }
  }
}