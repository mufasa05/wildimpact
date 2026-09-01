enum AccessibilityGrade {
  grade1('Grade 1: Fully Accessible', 'Paved ramps, zero steps, width >120cm, wheelchair suitable'),
  grade2('Grade 2: Assisted Access', 'Compact gravel, low incline <8%, assistance recommended'),
  grade3('Grade 3: Rugged Nature Path', 'Steep inclines, rock steps, high obstacle level');

  final String label;
  final String description;
  const AccessibilityGrade(this.label, this.description);
}

class AccessibilityFeature {
  final String id;
  final String name;
  final String destinationName;
  final String location;
  final AccessibilityGrade grade;
  final double slopeInclinePct;
  final int stepCount;
  final bool hasTactilePaving;
  final bool hasAccessibleAblution;
  final bool hasAudioGuide;
  final bool hasMountingPlatform;
  final double latitude;
  final double longitude;
  final String notes;

  const AccessibilityFeature({
    required this.id,
    required this.name,
    required this.destinationName,
    required this.location,
    required this.grade,
    required this.slopeInclinePct,
    required this.stepCount,
    required this.hasTactilePaving,
    required this.hasAccessibleAblution,
    required this.hasAudioGuide,
    required this.hasMountingPlatform,
    required this.latitude,
    required this.longitude,
    required this.notes,
  });
}
