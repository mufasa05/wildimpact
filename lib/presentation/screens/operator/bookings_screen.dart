import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/eco_stat_card.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../../domain/models/booking_contribution.dart';
import '../../providers/tourism_providers.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  String _searchFilter = '';

  @override
  Widget build(BuildContext context) {
    final lodge = ref.watch(selectedLodgeProvider);
    final contributions = ref.watch(contributionsProvider);

    final filtered = contributions.where((c) =>
      c.tourName.toLowerCase().contains(_searchFilter.toLowerCase()) ||
      c.guestName.toLowerCase().contains(_searchFilter.toLowerCase())
    ).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14,
            runSpacing: 12,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tour Bookings & Eco-Contributions',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: EcoColors.textPrimaryLight),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lodge.name} • Automated 100% Guest Eco-Levy Opt-in Ledger',
                    style: const TextStyle(fontSize: 13, color: EcoColors.textSecondaryLight),
                  ),
                ],
              ),
              SafariGlowButton(
                text: 'Record New Booking',
                icon: Icons.add_rounded,
                onPressed: () => _showAddBookingDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stat Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = constraints.maxWidth < 600 ? 1 : constraints.maxWidth < 1100 ? 2 : 4;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 160,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const EcoStatCard(
                        title: 'Total Active Bookings',
                        value: '248',
                        subtitle: 'Current Month (May 2026)',
                        icon: Icons.luggage_rounded,
                        iconColor: EcoColors.mintAccent,
                        changePercent: '+12%',
                        isPositive: true,
                      );
                    case 1:
                      return EcoStatCard(
                        title: 'Eco-Levy Collected',
                        value: '\$${contributions.fold<double>(0.0, (s, c) => s + c.amount).toStringAsFixed(0)}',
                        subtitle: '100% Verified Allocation',
                        icon: Icons.paid_rounded,
                        iconColor: EcoColors.savannaGold,
                        changePercent: '+18%',
                        isPositive: true,
                      );
                    case 2:
                      return EcoStatCard(
                        title: 'Total Guests Engaged',
                        value: '${contributions.fold<int>(0, (s, c) => s + c.guestCount)}',
                        subtitle: 'Conscious Travelers',
                        icon: Icons.people_rounded,
                        iconColor: EcoColors.emeraldPrimary,
                        changePercent: '+22%',
                        isPositive: true,
                      );
                    case 3:
                    default:
                      return const EcoStatCard(
                        title: 'Carbon Offset Tonnage',
                        value: '8.7 tCO₂e',
                        subtitle: 'ZCR Verified Teak Plots',
                        icon: Icons.cloud_done_rounded,
                        iconColor: EcoColors.terracotta,
                        changePercent: '+15%',
                        isPositive: true,
                      );
                  }
                },
              );
            },
          ),
          const SizedBox(height: 24),

          // Search and Filters Bar
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: EcoColors.mintAccent, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchFilter = val),
                    style: const TextStyle(color: EcoColors.textPrimaryLight, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Search tour or lead guest...',
                      hintStyle: TextStyle(color: EcoColors.textMuted, fontSize: 12),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (_searchFilter.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 16, color: EcoColors.textMuted),
                    onPressed: () => setState(() => _searchFilter = ''),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bookings Table
          GlassCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active Tour Manifest',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                ),
                const SizedBox(height: 14),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const Divider(color: EcoColors.cardBorder, height: 16),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: EcoColors.emeraldPrimary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.explore_rounded, color: EcoColors.mintAccent, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.tourName,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.guestName} • ${item.allocationCategory}',
                                style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${item.amount.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: EcoColors.mintAccent),
                            ),
                            Text(
                              '${item.co2OffsetTonnes} tCO₂',
                              style: const TextStyle(fontSize: 10, color: EcoColors.textSecondaryLight),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBookingDialog(BuildContext context) {
    final tourNameCtrl = TextEditingController(text: 'Hwange Sunrise Wilderness Safari');
    final guestNameCtrl = TextEditingController(text: 'Amara & Group (4 Guests)');
    final amountCtrl = TextEditingController(text: '175');
    String selectedCategory = 'Anti-Poaching';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          backgroundColor: const Color(0xFF0F241C),
          title: const Text('Record Tour Eco-Contribution', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tourNameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Safari Tour Name', labelStyle: TextStyle(color: EcoColors.textSecondaryLight)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: guestNameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Guest / Lead Traveler', labelStyle: TextStyle(color: EcoColors.textSecondaryLight)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Eco-Contribution (\$ USD)', labelStyle: TextStyle(color: EcoColors.textSecondaryLight)),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  dropdownColor: EcoColors.darkCardBg,
                  style: const TextStyle(color: Colors.white),
                  items: ['Anti-Poaching', 'Community Projects', 'Habitat Restoration']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDlgState(() => selectedCategory = val);
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Fund Allocation Pillar', labelStyle: TextStyle(color: EcoColors.textSecondaryLight)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel', style: TextStyle(color: EcoColors.textMuted))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: EcoColors.emeraldPrimary),
              onPressed: () {
                final amt = double.tryParse(amountCtrl.text) ?? 150.0;
                ref.read(contributionsProvider.notifier).addContribution(
                  BookingContribution(
                    id: 'cb-${DateTime.now().millisecondsSinceEpoch}',
                    tourName: tourNameCtrl.text,
                    amount: amt,
                    date: 'May 31, 2026',
                    timestamp: DateTime.now(),
                    guestName: guestNameCtrl.text,
                    guestCount: 4,
                    status: 'Verified',
                    co2OffsetTonnes: (amt / 150.0).clamp(0.5, 3.0),
                    allocationCategory: selectedCategory,
                  ),
                );
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking & Eco-Levy successfully registered!')),
                );
              },
              child: const Text('Save Booking', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
