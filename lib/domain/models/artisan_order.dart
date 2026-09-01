enum CraftMaterial {
  serpentineStone('Black Serpentine Stone (Chitungwiza)', 35.0, 1.8, 'Rich glossy dark green & black mineral luster'),
  verditeStone('Rare Zimbabwean Verdite (Green Gold)', 65.0, 2.2, 'Ancient metamorphic rock renowned globally for jade tones'),
  springstone('Hard Springstone Granite (Guruve)', 50.0, 2.5, 'Dense volcanic stone that polishes to jet black'),
  hardwoodTeak('Zambezi Valley Reclaimed Teak', 40.0, 0.9, 'Sustainably salvaged hardwood with deep honey grain'),
  zimbabweBatik('Hand-Dyed Sadza Batik Tapestry', 25.0, 0.2, 'Traditional porridge-resist patterned African cotton');

  final String label;
  final double basePriceUsd;
  final double weightKg;
  final String description;

  const CraftMaterial(this.label, this.basePriceUsd, this.weightKg, this.description);
}

enum CraftDimension {
  pocket(1.0, 'Pocket Sized (10-15cm)', 1),
  mantelpiece(1.8, 'Mantelpiece Showcase (25-35cm)', 3),
  statementCenterpiece(3.5, 'Gallery Masterpiece (50cm+)', 7);

  final double priceMultiplier;
  final String label;
  final int estimatedArtisanDays;

  const CraftDimension(this.priceMultiplier, this.label, this.estimatedArtisanDays);
}

class ArtisanCommissionOrder {
  final String id;
  final String artisanName;
  final String artisanVillage;
  final String artisanWhatsApp;
  CraftMaterial selectedMaterial;
  CraftDimension selectedDimension;
  String customInscription;
  String theme; // 'Chapungu Spirit Bird', 'Mother & Child', 'Rhino Sanctuary Totem', 'Baobab Tree'
  String touristName;
  String deliveryLocation; // 'Lodge Front Desk (Harare/VicFalls)', 'International Air Freight'

  ArtisanCommissionOrder({
    required this.id,
    required this.artisanName,
    required this.artisanVillage,
    required this.artisanWhatsApp,
    this.selectedMaterial = CraftMaterial.serpentineStone,
    this.selectedDimension = CraftDimension.mantelpiece,
    this.customInscription = 'Mhuri (Family & Unity)',
    this.theme = 'Chapungu Spirit Bird (Great Zimbabwe)',
    this.touristName = 'Tawanda Moyo',
    this.deliveryLocation = 'Lodge Front Desk (Hwange Safari Lodge)',
  });

  double get baseMaterialCost => selectedMaterial.basePriceUsd * selectedDimension.priceMultiplier;
  double get artisanLaborWageUsd => selectedDimension.estimatedArtisanDays * 22.0; // $22/day fair trade artisan rate
  double get communityHeritageRoyaltyUsd => (baseMaterialCost + artisanLaborWageUsd) * 0.15; // 15% village fund
  double get totalOrderPriceUsd => baseMaterialCost + artisanLaborWageUsd + communityHeritageRoyaltyUsd;

  String get provenanceCertificateHash {
    final seed = '${artisanName}_${selectedMaterial.name}_${selectedDimension.name}_${id.hashCode.abs()}';
    return 'PROV-ZW-${seed.hashCode.abs().toString().padLeft(8, '0')}';
  }

  /// Generates the direct WhatsApp URI/text string for 0% commission booking
  String generateWhatsAppMessage() {
    return Uri.encodeComponent(
      '🌟 *NEW DIRECT ARTISAN COMMISSION INQUIRY*\n\n'
      'Hello $artisanName,\n'
      'I would like to commission an authentic Zimbabwean handcraft directly through WildImpact:\n\n'
      '• *Theme*: $theme\n'
      '• *Material*: ${selectedMaterial.label}\n'
      '• *Size*: ${selectedDimension.label}\n'
      '• *Inscription*: "$customInscription"\n'
      '• *Direct Artisan Payout*: US\$${artisanLaborWageUsd.toStringAsFixed(2)}\n'
      '• *Total Order Price*: US\$${totalOrderPriceUsd.toStringAsFixed(2)}\n'
      '• *Provenance Code*: $provenanceCertificateHash\n'
      '• *Delivery To*: $deliveryLocation\n\n'
      'Please confirm your availability and carving timeline! Tatenda / Siyabonga.',
    );
  }
}
