class SmeProvider {
  final String id;
  final String businessName;
  final String category; // 'Artisan Craft' | 'Community Guide' | 'Village Homestay' | 'Traditional Cuisine' | 'Local Transport'
  final String location;
  final String ownerName;
  final String whatsappNumber;
  final double startingPriceUsd;
  final String priceUnit;
  final double rating;
  final int reviewCount;
  final bool isZtaRegistered;
  final bool isEcoCertified;
  final String description;
  final String imageUrl;

  const SmeProvider({
    required this.id,
    required this.businessName,
    required this.category,
    required this.location,
    required this.ownerName,
    required this.whatsappNumber,
    required this.startingPriceUsd,
    required this.priceUnit,
    required this.rating,
    required this.reviewCount,
    required this.isZtaRegistered,
    required this.isEcoCertified,
    required this.description,
    required this.imageUrl,
  });
}
