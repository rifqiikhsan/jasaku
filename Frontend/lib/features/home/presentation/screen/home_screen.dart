import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../providers/home_provider.dart';
import '../widgets/banner_promo.dart';
import '../widgets/category_section.dart';
import '../widgets/home_header.dart';
import '../widgets/service_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);

    return Material(
      color: AppTheme.background,
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  HomeHeader(
                    userName: state.userName,
                    location: state.location,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: AppSearchBar(
                      readOnly: true,
                      onTap: () => context.push('/search'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Scrollable content ───────────────────────────────
          Expanded(
            child: RefreshIndicator(
              color: AppTheme.primary,
              onRefresh: notifier.refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    if (state.errorMessage != null)
                      _ErrorState(
                        message: state.errorMessage!,
                        onRetry: notifier.refresh,
                      )
                    else if (state.isLoading)
                      const _LoadingState()
                    else ...[
                      CategorySection(categories: state.categories),
                      const BannerPromo(),
                      ServiceSection(
                        services: state.filteredServices,
                        isLoading: state.isLoading,
                      ),
                      if (state.searchQuery.isNotEmpty &&
                          state.filteredServices.isEmpty)
                        _EmptySearchState(query: state.searchQuery),
                      SizedBox(
                        height: 80 + MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── State widgets ────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 64, color: Color(0xFFCCCCCC)),
          const SizedBox(height: 16),
          Text(
            'Jasa "$query" tidak ditemukan',
            style: const TextStyle(color: Color(0xFF888888), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
