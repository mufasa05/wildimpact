enum UserPersona {
  tourist('Tourist & Traveler', 'Impact Passport, Cultural Audio & Offset Receipts', '🌍'),
  operator('Safari Lodge Host', 'Multi-tenant Operations, Ranger Telemetry & Staff', '🏨'),
  ztaAuditor('ZTA National Auditor', 'Macro Flow, Economic Leakage & ESG Verification', '🏛️'),
  elderCustodian('Community Custodian', 'Oral Folklore Registry & Royalty Payouts', '🎙️');

  final String title;
  final String description;
  final String emoji;
  const UserPersona(this.title, this.description, this.emoji);
}

class UserAuthProfile {
  final String id;
  final String email;
  final String fullName;
  final UserPersona persona;
  final String? tenantLodgeId;
  final String? avatarUrl;
  final double royaltyBalanceUsd;
  final int offsetPoints;

  const UserAuthProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.persona,
    this.tenantLodgeId,
    this.avatarUrl,
    this.royaltyBalanceUsd = 0.0,
    this.offsetPoints = 0,
  });
}
