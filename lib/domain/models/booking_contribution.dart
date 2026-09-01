class BookingContribution {
  final String id;
  final String tourName;
  final double amount;
  final String date;
  final DateTime timestamp;
  final String guestName;
  final int guestCount;
  final String status; // 'Verified' | 'Allocated' | 'Pending'
  final double co2OffsetTonnes;
  final String allocationCategory; // 'Anti-Poaching' | 'Community Projects' | 'Habitat Restoration'

  const BookingContribution({
    required this.id,
    required this.tourName,
    required this.amount,
    required this.date,
    required this.timestamp,
    required this.guestName,
    required this.guestCount,
    required this.status,
    required this.co2OffsetTonnes,
    required this.allocationCategory,
  });
}
