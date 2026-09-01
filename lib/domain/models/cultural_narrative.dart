class CulturalNarrative {
  final String id;
  final String title;
  final String location;
  final String elderName;
  final String communityName;
  final String language; // 'ChiShona' | 'SiNdebele' | 'ChiTonga' | 'English'
  final String audioDuration;
  final String audioUrl;
  final String transcript;
  final String spiritualContext;
  final double royaltyEarnedUsd;
  final int totalListens;
  final String coverImageUrl;

  const CulturalNarrative({
    required this.id,
    required this.title,
    required this.location,
    required this.elderName,
    required this.communityName,
    required this.language,
    required this.audioDuration,
    required this.audioUrl,
    required this.transcript,
    required this.spiritualContext,
    required this.royaltyEarnedUsd,
    required this.totalListens,
    required this.coverImageUrl,
  });
}
