import 'package:flutter/foundation.dart';
import '../core/services/supabase_service.dart';
import '../domain/models/tenant_lodge.dart';
import '../domain/models/offset_purchase.dart';
import '../domain/models/booking_contribution.dart';
import 'tourism_repository.dart';

class SupabaseTourismRepository extends TourismRepository {
  final SupabaseService _supabaseService;

  SupabaseTourismRepository({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService.instance;

  bool get _hasSupabase => _supabaseService.isInitialized && _supabaseService.client != null;

  // --- Lodges ---
  Future<List<TenantLodge>> fetchLodgesFromSupabase() async {
    if (!_hasSupabase) return getLodges();
    try {
      final response = await _supabaseService.client!.from('lodges').select();
      final list = (response as List).map((row) {
        return TenantLodge(
          id: row['id'] as String,
          name: row['name'] as String,
          slug: row['slug'] as String,
          country: row['country'] as String? ?? 'Zimbabwe',
          region: row['region'] as String,
          description: row['description'] as String,
          bannerUrl: row['banner_url'] as String,
          campfireSharePct: (row['campfire_share_pct'] as num).toDouble(),
          totalPatrolHours: row['total_patrol_hours'] as int,
          hectaresProtected: row['hectares_protected'] as int,
          carbonOffsetFundedUsd: (row['carbon_offset_funded_usd'] as num).toDouble(),
          treesPlanted: row['trees_planted'] as int,
          waterLitersProvided: row['water_liters_provided'] as int,
        );
      }).toList();
      return list.isNotEmpty ? list : getLodges();
    } catch (e) {
      debugPrint('Supabase fetchLodges fallback: $e');
      return getLodges();
    }
  }

  @override
  void addMilestone({
    required String projectId,
    required String title,
    required String description,
    required double metricDelta,
    String? evidenceUrl,
    double? latitude,
    double? longitude,
    String? verifiedBy,
  }) {
    super.addMilestone(
      projectId: projectId,
      title: title,
      description: description,
      metricDelta: metricDelta,
      evidenceUrl: evidenceUrl,
      latitude: latitude,
      longitude: longitude,
      verifiedBy: verifiedBy,
    );

    if (_hasSupabase) {
      final milestoneId = 'm-${DateTime.now().millisecondsSinceEpoch}';
      _supabaseService.client!.from('milestones').insert({
        'id': milestoneId,
        'project_id': projectId,
        'title': title,
        'description': description,
        'metric_delta': metricDelta,
        'evidence_url': evidenceUrl,
        'latitude': latitude,
        'longitude': longitude,
        'verified_by': verifiedBy ?? 'Field Ranger',
        'created_at': DateTime.now().toIso8601String(),
      }).then((_) {
        debugPrint('Milestone synced to Supabase: $milestoneId');
      }).catchError((e) {
        debugPrint('Supabase sync milestone error: $e');
      });
    }
  }

  // --- Booking Contributions ---
  @override
  void addContribution(BookingContribution contribution) {
    super.addContribution(contribution);

    if (_hasSupabase) {
      _supabaseService.client!.from('booking_contributions').insert({
        'id': contribution.id,
        'tour_name': contribution.tourName,
        'amount': contribution.amount,
        'date_str': contribution.date,
        'guest_name': contribution.guestName,
        'guest_count': contribution.guestCount,
        'status': contribution.status,
        'co2_offset_tonnes': contribution.co2OffsetTonnes,
        'allocation_category': contribution.allocationCategory,
        'created_at': contribution.timestamp.toIso8601String(),
      }).then((_) {
        debugPrint('Booking contribution synced to Supabase: ${contribution.id}');
      }).catchError((e) {
        debugPrint('Supabase sync contribution error: $e');
      });
    }
  }

  // --- Carbon Offset Purchases ---
  @override
  OffsetPurchase purchaseOffset({
    required String offsetProjectId,
    required String touristName,
    required String touristEmail,
    required double tonnes,
    required String paymentMethod,
  }) {
    final purchase = super.purchaseOffset(
      offsetProjectId: offsetProjectId,
      touristName: touristName,
      touristEmail: touristEmail,
      tonnes: tonnes,
      paymentMethod: paymentMethod,
    );

    if (_hasSupabase) {
      _supabaseService.client!.from('offset_purchases').insert({
        'id': purchase.id,
        'offset_project_id': purchase.offsetProjectId,
        'project_name': purchase.projectName,
        'tourist_name': purchase.touristName,
        'tourist_email': purchase.touristEmail,
        'tonnes': purchase.tonnes,
        'amount_paid': purchase.amountPaid,
        'campfire_share': purchase.campfireShare,
        'certificate_code': purchase.certificateCode,
        'payment_method': purchase.paymentMethod,
        'created_at': purchase.createdAt.toIso8601String(),
      }).then((_) {
        debugPrint('Offset purchase synced to Supabase: ${purchase.certificateCode}');
      }).catchError((e) {
        debugPrint('Supabase sync offset purchase error: $e');
      });
    }

    return purchase;
  }
}
