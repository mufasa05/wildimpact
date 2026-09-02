enum UserPersona {
  tourist('Tourist & Traveler', 'Impact Passport, Real-Time Safari Discovery & Offsets', '🌍'),
  operator('Safari Lodge Host', 'Multi-tenant Operations, Bookings & ESG Reporting', '🏨'),
  ranger('Wildlife Ranger & Patrol', 'Anti-Poaching Radar, GPS Telemetry & Patrols', '🛡️'),
  ztaAuditor('National Tourism Board', 'Macro Footprints, Economic Leakage & Nationwide Analytics', '🏛️'),
  smeProvider('Community SME & Artisan', '0% Fee Supplier Portal, Direct Orders & Payouts', '🤝'),
  elderCustodian('Living Heritage Custodian', 'Oral Folklore Registry & Elder Royalties', '🎙️');

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

  UserAuthProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    UserPersona? persona,
    String? tenantLodgeId,
    String? avatarUrl,
    double? royaltyBalanceUsd,
    int? offsetPoints,
  }) {
    return UserAuthProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      persona: persona ?? this.persona,
      tenantLodgeId: tenantLodgeId ?? this.tenantLodgeId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      royaltyBalanceUsd: royaltyBalanceUsd ?? this.royaltyBalanceUsd,
      offsetPoints: offsetPoints ?? this.offsetPoints,
    );
  }
}
