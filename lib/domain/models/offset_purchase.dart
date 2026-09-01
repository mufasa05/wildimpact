class OffsetPurchase {
  final String id;
  final String offsetProjectId;
  final String projectName;
  final String touristName;
  final String touristEmail;
  final double tonnes;
  final double amountPaid;
  final double campfireShare;
  final String certificateCode;
  final String paymentMethod;
  final DateTime createdAt;

  OffsetPurchase({
    required this.id,
    required this.offsetProjectId,
    required this.projectName,
    required this.touristName,
    required this.touristEmail,
    required this.tonnes,
    required this.amountPaid,
    required this.campfireShare,
    required this.certificateCode,
    required this.paymentMethod,
    required this.createdAt,
  });
}
