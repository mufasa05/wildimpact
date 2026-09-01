import 'dart:math';

enum TransportMode {
  diesel4x4('Safari 4x4 Cruiser (Diesel)', 0.28, 45.0, 0.15, IconsData.car),
  solarEv('Clean Solar Safari EV', 0.02, 35.0, 0.90, IconsData.bolt),
  domesticFlight('Domestic Cessna Flight', 0.45, 180.0, 0.05, IconsData.flight),
  guidedWalking('Guided Wilderness Trail', 0.00, 20.0, 0.95, IconsData.walk),
  sharedShuttle('Local Community Shuttle', 0.08, 12.0, 0.85, IconsData.bus);

  final String label;
  final double kgCo2PerKm; // kg of CO2 per passenger km
  final double costPerKmUsd;
  final double localRetentionPct; // percentage of transport spend staying local
  final String iconTag;

  const TransportMode(
    this.label,
    this.kgCo2PerKm,
    this.costPerKmUsd,
    this.localRetentionPct,
    this.iconTag,
  );
}

class IconsData {
  static const String car = 'directions_car';
  static const String bolt = 'electric_bolt';
  static const String flight = 'flight';
  static const String walk = 'directions_walk';
  static const String bus = 'directions_bus';
}

enum AccommodationType {
  luxuryOtaLodge('Luxury Foreign-Owned Lodge (Booked via OTA)', 450.0, 0.12, 45.0),
  campfireCommunityLodge('CAMPFIRE Community Eco-Conservancy', 220.0, 0.78, 10.0),
  ruralVillageHomestay('Rural Village Homestay & Cultural Camp', 65.0, 0.95, 2.0),
  nationalParkChalet('ZimParks Sustainable Bush Chalet', 120.0, 0.65, 8.0);

  final String label;
  final double costPerNightUsd;
  final double localRetentionPct; // share that reaches local wages, trusts, and farmers
  final double kgCo2PerNight;

  const AccommodationType(
    this.label,
    this.costPerNightUsd,
    this.localRetentionPct,
    this.kgCo2PerNight,
  );
}

class ItineraryLeg {
  final String id;
  final String origin;
  final String destination;
  final double distanceKm;
  TransportMode transportMode;
  AccommodationType accommodation;
  int nights;
  bool includeCommunityGuide;
  bool includeElderStorytellingPass;

  ItineraryLeg({
    required this.id,
    required this.origin,
    required this.destination,
    required this.distanceKm,
    required this.transportMode,
    required this.accommodation,
    this.nights = 2,
    this.includeCommunityGuide = true,
    this.includeElderStorytellingPass = true,
  });

  double get transportEmissionsKg => distanceKm * transportMode.kgCo2PerKm;
  double get accommodationEmissionsKg => nights * accommodation.kgCo2PerNight;
  double get totalEmissionsKg => transportEmissionsKg + accommodationEmissionsKg;
  double get totalEmissionsTonnes => totalEmissionsKg / 1000.0;

  double get transportCostUsd => distanceKm * (transportMode.costPerKmUsd / 10.0);
  double get accommodationCostUsd => nights * accommodation.costPerNightUsd;
  double get activitiesCostUsd =>
      (includeCommunityGuide ? 35.0 * nights : 0.0) +
      (includeElderStorytellingPass ? 15.0 : 0.0);

  double get totalCostUsd => transportCostUsd + accommodationCostUsd + activitiesCostUsd;

  double get localRetainedUsd {
    final transLocal = transportCostUsd * transportMode.localRetentionPct;
    final accomLocal = accommodationCostUsd * accommodation.localRetentionPct;
    final activLocal = activitiesCostUsd * 0.95; // 95% of direct community activities stay local
    return transLocal + accomLocal + activLocal;
  }

  double get foreignLeakageUsd => max(0.0, totalCostUsd - localRetainedUsd);

  double get localRetentionPercentage =>
      totalCostUsd > 0 ? (localRetainedUsd / totalCostUsd) * 100.0 : 0.0;
}

class TripItinerary {
  final String id;
  String title;
  final List<ItineraryLeg> legs;
  int travelersCount;

  TripItinerary({
    required this.id,
    required this.title,
    required this.legs,
    this.travelersCount = 2,
  });

  double get totalDistanceKm => legs.fold(0.0, (sum, leg) => sum + leg.distanceKm);

  double get totalEmissionsTonnes =>
      legs.fold(0.0, (sum, leg) => sum + leg.totalEmissionsTonnes) * travelersCount;

  double get totalCostUsd =>
      legs.fold(0.0, (sum, leg) => sum + leg.totalCostUsd) * travelersCount;

  double get totalLocalRetentionUsd =>
      legs.fold(0.0, (sum, leg) => sum + leg.localRetainedUsd) * travelersCount;

  double get totalForeignLeakageUsd =>
      legs.fold(0.0, (sum, leg) => sum + leg.foreignLeakageUsd) * travelersCount;

  double get overallRetentionPercentage =>
      totalCostUsd > 0 ? (totalLocalRetentionUsd / totalCostUsd) * 100.0 : 0.0;

  double get carbonOffsetCostUsd => totalEmissionsTonnes * 18.0; // $18/tonne Verra ZW standard

  /// Optimizes the itinerary to maximize local economic retention and minimize carbon footprint
  void optimizeForZeroLeakageAndCarbon() {
    for (var leg in legs) {
      // Swap high emission/leakage transport to solar or shared
      if (leg.transportMode == TransportMode.diesel4x4 || leg.transportMode == TransportMode.domesticFlight) {
        leg.transportMode = TransportMode.solarEv;
      }
      // Swap foreign OTA accommodation to CAMPFIRE or village homestay
      if (leg.accommodation == AccommodationType.luxuryOtaLodge) {
        leg.accommodation = AccommodationType.campfireCommunityLodge;
      }
      leg.includeCommunityGuide = true;
      leg.includeElderStorytellingPass = true;
    }
  }

  static TripItinerary createDefault() {
    return TripItinerary(
      id: 'itinerary-default',
      title: '7-Day Living Zimbabwe Eco & Heritage Odyssey',
      travelersCount: 2,
      legs: [
        ItineraryLeg(
          id: 'leg-1',
          origin: 'Harare International Airport',
          destination: 'Great Zimbabwe Ancient City (Masvingo)',
          distanceKm: 295.0,
          transportMode: TransportMode.diesel4x4,
          accommodation: AccommodationType.luxuryOtaLodge,
          nights: 2,
          includeCommunityGuide: true,
          includeElderStorytellingPass: true,
        ),
        ItineraryLeg(
          id: 'leg-2',
          origin: 'Masvingo',
          destination: 'Nyanga Eastern Highlands',
          distanceKm: 280.0,
          transportMode: TransportMode.diesel4x4,
          accommodation: AccommodationType.luxuryOtaLodge,
          nights: 2,
          includeCommunityGuide: false,
          includeElderStorytellingPass: false,
        ),
        ItineraryLeg(
          id: 'leg-3',
          origin: 'Nyanga',
          destination: 'Hwange National Park Conservancy',
          distanceKm: 650.0,
          transportMode: TransportMode.domesticFlight,
          accommodation: AccommodationType.campfireCommunityLodge,
          nights: 3,
          includeCommunityGuide: true,
          includeElderStorytellingPass: true,
        ),
      ],
    );
  }
}
