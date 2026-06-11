import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../shared/widgets/app_search_bar.dart';
import 'providers/home_provider.dart';
import 'widgets/banner_promo.dart';
import 'widgets/category_section.dart';
import 'widgets/home_header.dart';
import 'widgets/service_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── Header biru ──────────────────────────────────────
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
                    child: AppSearchBar(onChanged: notifier.setSearchQuery),
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
                    // Error state
                    if (state.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                state.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: notifier.refresh,
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
                      )
                    else ...[
                      // Loading skeleton untuk kategori
                      if (state.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primary,
                            ),
                          ),
                        )
                      else ...[
                        CategorySection(categories: state.categories),
                        const BannerPromo(),
                        ServiceSection(
                          services: state.filteredServices,
                          isLoading: state.isLoading,
                        ),

                        // Empty state saat search tidak ada hasil
                        if (state.searchQuery.isNotEmpty &&
                            state.filteredServices.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Color(0xFFCCCCCC),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Jasa "${state.searchQuery}" tidak ditemukan',
                                  style: const TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Navigation Bar ────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: const Color(0xFFAAAAAA),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        elevation: 8,
        currentIndex: 0,
        onTap: (index) {
          // TODO: navigasi antar tab dengan go_router
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
