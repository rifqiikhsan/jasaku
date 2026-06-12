import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jasaku/features/search/pages/fullscreen_map_page.dart';
import 'package:jasaku/features/search/providers/search_provider.dart';
import 'package:jasaku/features/search/widgets/active_filter_badge.dart';
import 'package:jasaku/features/search/widgets/distance_bubble.dart';
import 'package:jasaku/features/search/widgets/filter_bottom_sheet.dart';
import 'package:jasaku/features/search/widgets/icon_btn.dart';
import 'package:jasaku/features/search/widgets/service_card.dart';
import 'package:jasaku/features/search/widgets/sort_chip.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/theme.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final MapController _mapController = MapController();

  late final AnimationController _mapAnim;
  late final Animation<double> _mapHeight;

  static const _subangCenter = LatLng(-6.5715, 107.7583);
  static const _mapExpandedHeight = 200.0;

  // ── Lifecycle ───────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _mapAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 1.0,
    );
    _mapHeight = Tween<double>(begin: 0, end: _mapExpandedHeight).animate(
      CurvedAnimation(parent: _mapAnim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _mapController.dispose();
    _mapAnim.dispose();
    super.dispose();
  }

  // ── Actions ─────────────────────────────────────────────────

  void _toggleMap() {
    ref.read(searchProvider.notifier).toggleMapVisible();
    _mapAnim.value == 1.0 ? _mapAnim.reverse() : _mapAnim.forward();
  }

  void _openFullscreenMap(List<ServiceProvider> providers) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => FullscreenMapPage(
          providers: providers,
          center: _subangCenter,
        ),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  void _openFilterSheet() {
    final currentFilter = ref.read(searchProvider).filter;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        initialFilter: currentFilter,
        onApply: (f) => ref.read(searchProvider.notifier).applyFilter(f),
        onReset: () => ref.read(searchProvider.notifier).resetFilter(),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────

  List<Marker> _buildMarkers(List<ServiceProvider> providers) {
    return providers.map((p) {
      return Marker(
        point: LatLng(p.lat, p.lng),
        width: 82,
        height: 34,
        child: DistanceBubble(
          distanceKm: p.distanceKm,
          color: p.distanceKm <= 1.0 ? AppTheme.primary : const Color(0xFFE63946),
        ),
      );
    }).toList();
  }

  // ── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    final notifier = ref.read(searchProvider.notifier);
    final filterActive = state.filter.isActive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(filterActive),
            _buildSearchBar(notifier),
            const SizedBox(height: 12),
            _buildSortAndMapToggle(state, notifier),
            const SizedBox(height: 12),
            _buildAnimatedMap(state),
            if (state.isMapVisible) const SizedBox(height: 12),
            if (filterActive) _buildActiveFilters(state, notifier),
            _buildResultCount(state),
            _buildResultList(state),
          ],
        ),
      ),
    );
  }

  // ── Section builders ─────────────────────────────────────────

  Widget _buildHeader(bool filterActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          IconBtn(icon: Icons.arrow_back, onTap: () => Navigator.maybePop(context)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Cari Jasa',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconBtn(icon: Icons.tune, onTap: _openFilterSheet),
              if (filterActive)
                Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE63946),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(SearchNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search, color: AppTheme.textHint, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: notifier.onQueryChanged,
                style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF1A1A2E)),
                decoration: InputDecoration(
                  hintText: 'Teknisi AC Di Subang...',
                  hintStyle: GoogleFonts.poppins(color: AppTheme.textHint, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic_none_rounded, color: AppTheme.textHint, size: 22),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortAndMapToggle(SearchState state, SearchNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SortChip(
            label: 'Terdekat',
            icon: Icons.location_on_outlined,
            isSelected: state.sortType == SearchSortType.nearest,
            onTap: () => notifier.setSortType(SearchSortType.nearest),
          ),
          const SizedBox(width: 8),
          SortChip(
            label: 'Rating',
            icon: Icons.star_border_rounded,
            isSelected: state.sortType == SearchSortType.rating,
            onTap: () => notifier.setSortType(SearchSortType.rating),
          ),
          const SizedBox(width: 8),
          SortChip(
            label: 'Kategori',
            icon: Icons.filter_list_rounded,
            isSelected: state.sortType == SearchSortType.category,
            onTap: () => notifier.setSortType(SearchSortType.category),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _toggleMap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: state.isMapVisible ? AppTheme.primary.withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: state.isMapVisible ? AppTheme.primary : const Color(0xFFDDE1EA),
                ),
              ),
              child: Icon(
                state.isMapVisible ? Icons.map : Icons.map_outlined,
                size: 18,
                color: state.isMapVisible ? AppTheme.primary : const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMap(SearchState state) {
    return AnimatedBuilder(
      animation: _mapHeight,
      builder: (_, __) => SizedBox(
        height: _mapHeight.value,
        child: _mapHeight.value < 10
            ? const SizedBox.shrink()
            : Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: const MapOptions(
                      initialCenter: _subangCenter,
                      initialZoom: 14.5,
                      interactionOptions: InteractionOptions(
                        flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.jasaku.app',
                      ),
                      MarkerLayer(markers: _buildMarkers(state.results)),
                    ],
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => _openFullscreenMap(state.results),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.open_in_full, size: 13, color: Color(0xFF1A1A2E)),
                            const SizedBox(width: 5),
                            Text(
                              'Lihat Peta',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildActiveFilters(SearchState state, SearchNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          if (state.filter.selectedCategory != 'Semua')
            ActiveFilterBadge(
              label: state.filter.selectedCategory,
              onRemove: () => notifier.applyFilter(
                state.filter.copyWith(selectedCategory: 'Semua'),
              ),
            ),
          if (state.filter.minRating > 0)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: ActiveFilterBadge(
                label: '≥ ${state.filter.minRating.toStringAsFixed(1)} ★',
                onRemove: () => notifier.applyFilter(
                  state.filter.copyWith(minRating: 0.0),
                ),
              ),
            ),
          const Spacer(),
          GestureDetector(
            onTap: notifier.resetFilter,
            child: Text(
              'Reset',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE63946),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCount(SearchState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.poppins(fontSize: 13),
          children: [
            TextSpan(
              text: '${state.results.length} penyedia jasa ',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const TextSpan(
              text: 'ditemukan di sekitar kamu',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultList(SearchState state) {
    if (state.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (state.results.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 52, color: AppTheme.textHint.withOpacity(0.4)),
              const SizedBox(height: 12),
              Text(
                'Tidak ada hasil ditemukan.',
                style: GoogleFonts.poppins(color: AppTheme.textHint, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        itemCount: state.results.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) => ServiceCard(provider: state.results[i]),
      ),
    );
  }
}
