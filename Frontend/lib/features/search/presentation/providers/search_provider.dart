import 'package:flutter_riverpod/legacy.dart';

enum SearchSortType { nearest, rating, category }

// Semua kategori yang tersedia
const List<String> kAllCategories = [
  'Semua',
  'Teknisi AC',
  'Elektronik',
  'Kulkas',
  'Plumbing',
  'Listrik',
];

class ServiceProvider {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final int startingPrice;
  final double lat;
  final double lng;

  const ServiceProvider({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.startingPrice,
    required this.lat,
    required this.lng,
  });
}

class FilterState {
  final String selectedCategory;
  final double minRating;

  const FilterState({
    this.selectedCategory = 'Semua',
    this.minRating = 0.0,
  });

  bool get isActive => selectedCategory != 'Semua' || minRating > 0.0;

  FilterState copyWith({
    String? selectedCategory,
    double? minRating,
  }) {
    return FilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minRating: minRating ?? this.minRating,
    );
  }
}

class SearchState {
  final String query;
  final SearchSortType sortType;
  final FilterState filter;
  final List<ServiceProvider> results;
  final bool isLoading;
  final bool isMapVisible;

  const SearchState({
    this.query = '',
    this.sortType = SearchSortType.nearest,
    this.filter = const FilterState(),
    this.results = const [],
    this.isLoading = false,
    this.isMapVisible = true,
  });

  SearchState copyWith({
    String? query,
    SearchSortType? sortType,
    FilterState? filter,
    List<ServiceProvider>? results,
    bool? isLoading,
    bool? isMapVisible,
  }) {
    return SearchState(
      query: query ?? this.query,
      sortType: sortType ?? this.sortType,
      filter: filter ?? this.filter,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      isMapVisible: isMapVisible ?? this.isMapVisible,
    );
  }
}

// ── Dummy data ──
final _allProviders = [
  const ServiceProvider(
    id: '1',
    name: 'Samid Teknisi AC',
    subtitle: 'Teknisi AC & Kulkas',
    category: 'Teknisi AC',
    tags: ['Cuci AC', 'Instalasi'],
    rating: 4.9,
    reviewCount: 123,
    distanceKm: 0.8,
    startingPrice: 50000,
    lat: -6.5715,
    lng: 107.7583,
  ),
  const ServiceProvider(
    id: '2',
    name: 'Budi AC Service',
    subtitle: 'Teknisi AC & Kulkas',
    category: 'Teknisi AC',
    tags: ['Cuci AC', 'Freon'],
    rating: 4.7,
    reviewCount: 89,
    distanceKm: 1.2,
    startingPrice: 75000,
    lat: -6.5735,
    lng: 107.7560,
  ),
  const ServiceProvider(
    id: '3',
    name: 'Jaya Teknik AC',
    subtitle: 'Teknisi AC & Elektronik',
    category: 'Elektronik',
    tags: ['Instalasi', 'Freon', 'Cuci AC'],
    rating: 4.8,
    reviewCount: 201,
    distanceKm: 1.3,
    startingPrice: 60000,
    lat: -6.5750,
    lng: 107.7610,
  ),
  const ServiceProvider(
    id: '4',
    name: 'Rizki Service AC',
    subtitle: 'Spesialis AC Split & Cassette',
    category: 'Teknisi AC',
    tags: ['Cuci AC', 'Perbaikan'],
    rating: 4.6,
    reviewCount: 55,
    distanceKm: 1.8,
    startingPrice: 45000,
    lat: -6.5695,
    lng: 107.7595,
  ),
  const ServiceProvider(
    id: '5',
    name: 'Pak Dani Plumbing',
    subtitle: 'Ahli Pipa & Saluran Air',
    category: 'Plumbing',
    tags: ['Pipa Bocor', 'Instalasi'],
    rating: 4.5,
    reviewCount: 40,
    distanceKm: 2.1,
    startingPrice: 80000,
    lat: -6.5700,
    lng: 107.7620,
  ),
  const ServiceProvider(
    id: '6',
    name: 'CV Terang Listrik',
    subtitle: 'Instalasi & Perbaikan Listrik',
    category: 'Listrik',
    tags: ['Instalasi', 'MCB', 'Grounding'],
    rating: 4.3,
    reviewCount: 67,
    distanceKm: 2.5,
    startingPrice: 100000,
    lat: -6.5680,
    lng: 107.7570,
  ),
];

// ── Notifier ──
class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState()) {
    _applyAll();
  }

  void onQueryChanged(String q) {
    state = state.copyWith(query: q, isLoading: true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _applyAll();
    });
  }

  void setSortType(SearchSortType type) {
    state = state.copyWith(sortType: type);
    _applyAll();
  }

  void applyFilter(FilterState filter) {
    state = state.copyWith(filter: filter);
    _applyAll();
  }

  void resetFilter() {
    state = state.copyWith(filter: const FilterState());
    _applyAll();
  }

  void toggleMapVisible() {
    state = state.copyWith(isMapVisible: !state.isMapVisible);
  }

  void _applyAll() {
    final q = state.query.toLowerCase();
    final f = state.filter;

    var list = _allProviders.where((p) {
      // query filter
      final matchQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.subtitle.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));

      // category filter
      final matchCategory = f.selectedCategory == 'Semua' || p.category == f.selectedCategory;

      // rating filter
      final matchRating = p.rating >= f.minRating;

      return matchQuery && matchCategory && matchRating;
    }).toList();

    // sort
    switch (state.sortType) {
      case SearchSortType.nearest:
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case SearchSortType.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SearchSortType.category:
        list.sort((a, b) => a.category.compareTo(b.category));
        break;
    }

    state = state.copyWith(results: list, isLoading: false);
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(),
);
