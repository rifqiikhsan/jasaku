import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jasaku/features/search/providers/search_provider.dart';
import '../../../app/theme.dart';
import 'sheet_divider.dart';

class FilterBottomSheet extends StatefulWidget {
  final FilterState initialFilter;
  final void Function(FilterState) onApply;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedCategory;
  late double _minRating;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialFilter.selectedCategory;
    _minRating = widget.initialFilter.minRating;
  }

  void _resetLocally() {
    setState(() {
      _selectedCategory = 'Semua';
      _minRating = 0.0;
    });
    widget.onReset();
  }

  void _applyFilter() {
    widget.onApply(
      FilterState(selectedCategory: _selectedCategory, minRating: _minRating),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Title + Reset
          Row(
            children: [
              Text(
                'Filter',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _resetLocally,
                child: Text(
                  'Reset',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE63946),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const SheetDivider(),

          // ── Kategori ──
          const SizedBox(height: 16),
          Text(
            'Kategori',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kAllCategories.map((cat) {
              final sel = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? AppTheme.primary : const Color(0xFFF0F2F7),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: sel ? AppTheme.primary : const Color(0xFFDDE1EA),
                    ),
                  ),
                  child: Text(
                    cat,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: sel ? Colors.white : const Color(0xFF374151),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          const SheetDivider(),

          // ── Rating Minimum ──
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Rating Minimum',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _minRating > 0
                      ? AppTheme.accent.withValues(alpha: 0.12)
                      : const Color(0xFFF0F2F7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 15,
                      color: _minRating > 0
                          ? AppTheme.accent
                          : AppTheme.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _minRating > 0 ? _minRating.toStringAsFixed(1) : 'Semua',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _minRating > 0
                            ? AppTheme.accent
                            : AppTheme.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primary,
              inactiveTrackColor: const Color(0xFFE5E7EB),
              thumbColor: AppTheme.primary,
              overlayColor: AppTheme.primary.withValues(alpha: 0.12),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              min: 0.0,
              max: 5.0,
              divisions: 10,
              value: _minRating,
              onChanged: (v) => setState(() => _minRating = v),
            ),
          ),

          // Rating labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Semua', '2.0', '3.0', '4.0', '5.0'].map((l) {
              return Text(
                l,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppTheme.textHint,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Tombol Terapkan
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _applyFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Terapkan Filter',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
