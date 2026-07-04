import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryModel {
  final String id;
  final String label;
  final String icon;

  const CategoryModel({
    required this.id,
    required this.label,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      label: json['label'],
      icon: json['icon'],
    );
  }
}

class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double distance;
  final double rating;
  final int reviewCount;
  final int price;
  final bool isVerified;
  final String icon;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.isVerified,
    required this.icon,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      distance: (json['distance'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'],
      price: json['price'],
      isVerified: json['is_verified'],
      icon: json['icon'],
    );
  }
}

class HomeState {
  final String userName;
  final String location;
  final String searchQuery;
  final List<CategoryModel> categories;
  final List<ServiceModel> nearbyServices;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    this.userName = '',
    this.location = '',
    this.searchQuery = '',
    this.categories = const [],
    this.nearbyServices = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  // filter nearbyServices berdasarkan searchQuery
  List<ServiceModel> get filteredServices {
    if (searchQuery.isEmpty) return nearbyServices;
    return nearbyServices
        .where(
          (s) =>
              s.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              s.description.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  HomeState copyWith({
    String? userName,
    String? location,
    String? searchQuery,
    List<CategoryModel>? categories,
    List<ServiceModel>? nearbyServices,
    bool? isLoading,
    Object? errorMessage = _sentinel,
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      location: location ?? this.location,
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
      nearbyServices: nearbyServices ?? this.nearbyServices,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const _sentinel = Object();

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    Future.microtask(() => loadData());
    return const HomeState(isLoading: true);
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final String raw = await rootBundle.loadString(
        'assets/dummy/home_data.json',
      );

      final Map<String, dynamic> json = jsonDecode(raw);

      final user = json['user'] as Map<String, dynamic>;
      final categories = (json['categories'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      final services = (json['nearby_services'] as List)
          .map((e) => ServiceModel.fromJson(e))
          .toList();

      state = state.copyWith(
        userName: user['name'],
        location: user['location'],
        categories: categories,
        nearbyServices: services,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      // tampilkan error lengkap untuk debug
      debugPrint('Error loadData: $e');
      debugPrint('StackTrace: $stackTrace');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat data: $e',
      );
    }
  }

  void setSearchQuery(String query) =>
      state = state.copyWith(searchQuery: query);

  Future<void> refresh() => loadData();
}

final homeProvider = NotifierProvider.autoDispose<HomeNotifier, HomeState>(
  HomeNotifier.new,
);
