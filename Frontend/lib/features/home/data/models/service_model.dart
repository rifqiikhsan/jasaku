import 'package:jasaku/features/home/domain/entities/service_entity.dart';

class ServiceModel {
  final String? id;
  final String? serviceName;
  final List<Category>? category;
  final String? summaryRating;
  final String? distance;
  final int? totalReviews;
  final String? priceMinimum;
  final String? emoji;
  final String? emojiColor;
  final String? isVerification;
  final String? createdAt;
  final String? updatedAt;
  const ServiceModel({
    this.id,
    this.serviceName,
    this.category,
    this.summaryRating,
    this.distance,
    this.totalReviews,
    this.priceMinimum,
    this.emoji,
    this.emojiColor,
    this.isVerification,
    this.createdAt,
    this.updatedAt,
  });
  ServiceModel copyWith({
    String? id,
    String? serviceName,
    List<Category>? category,
    String? summaryRating,
    String? distance,
    int? totalReviews,
    String? priceMinimum,
    String? emoji,
    String? emojiColor,
    String? isVerification,
    String? createdAt,
    String? updatedAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      category: category ?? this.category,
      summaryRating: summaryRating ?? this.summaryRating,
      distance: distance ?? this.distance,
      totalReviews: totalReviews ?? this.totalReviews,
      priceMinimum: priceMinimum ?? this.priceMinimum,
      emoji: emoji ?? this.emoji,
      emojiColor: emojiColor ?? this.emojiColor,
      isVerification: isVerification ?? this.isVerification,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'category': category
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'summaryRating': summaryRating,
      'distance': distance,
      'totalReviews': totalReviews,
      'priceMinimum': priceMinimum,
      'emoji': emoji,
      'emojiColor': emojiColor,
      'isVerification': isVerification,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static ServiceModel fromJson(Map<String, Object?> json) {
    return ServiceModel(
      id: json['id'] == null ? null : json['id'] as String,
      serviceName: json['serviceName'] == null
          ? null
          : json['serviceName'] as String,
      category: json['category'] == null
          ? null
          : (json['category'] as List)
                .map<Category>(
                  (data) => Category.fromJson(data as Map<String, Object?>),
                )
                .toList(),
      summaryRating: json['summaryRating'] == null
          ? null
          : json['summaryRating'] as String,
      distance: json['distance'] == null ? null : json['distance'] as String,
      totalReviews: json['totalReviews'] == null
          ? null
          : json['totalReviews'] as int,
      priceMinimum: json['priceMinimum'] == null
          ? null
          : json['priceMinimum'] as String,
      emoji: json['emoji'] == null ? null : json['emoji'] as String,
      emojiColor: json['emojiColor'] == null
          ? null
          : json['emojiColor'] as String,
      isVerification: json['isVerification'] == null
          ? null
          : json['isVerification'] as String,
      createdAt: json['createdAt'] == null ? null : json['createdAt'] as String,
      updatedAt: json['updatedAt'] == null ? null : json['updatedAt'] as String,
    );
  }

  ServiceEntity toEntity() => ServiceEntity(
    id: id,
    serviceName: serviceName,
    category: category
        ?.map((e) => ServiceCategoryEntity(id: e.id, catDesc: e.catDesc))
        .toList(),
    summaryRating: summaryRating == null
        ? null
        : double.tryParse(summaryRating!),
    distance: distance,
    totalReviews: totalReviews,
    priceMinimum: priceMinimum,
    emoji: emoji,
    emojiColor: emojiColor,
    isVerification: isVerification,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  @override
  String toString() {
    return '''ServiceModel(
                id:$id,
serviceName:$serviceName,
category:${category.toString()},
summaryRating:$summaryRating,
distance:$distance,
totalReviews:$totalReviews,
priceMinimum:$priceMinimum,
emoji:$emoji,
emojiColor:$emojiColor,
isVerification:$isVerification,
createdAt:$createdAt,
updatedAt:$updatedAt
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceModel &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.serviceName == serviceName &&
        other.category == category &&
        other.summaryRating == summaryRating &&
        other.distance == distance &&
        other.totalReviews == totalReviews &&
        other.priceMinimum == priceMinimum &&
        other.emoji == emoji &&
        other.emojiColor == emojiColor &&
        other.isVerification == isVerification &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      serviceName,
      category,
      summaryRating,
      distance,
      totalReviews,
      priceMinimum,
      emoji,
      emojiColor,
      isVerification,
      createdAt,
      updatedAt,
    );
  }
}

class Category {
  final String? id;
  final String? catDesc;
  const Category({this.id, this.catDesc});
  Category copyWith({String? id, String? catDesc}) {
    return Category(id: id ?? this.id, catDesc: catDesc ?? this.catDesc);
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'catDesc': catDesc};
  }

  static Category fromJson(Map<String, Object?> json) {
    return Category(
      id: json['id'] == null ? null : json['id'] as String,
      catDesc: json['catDesc'] == null ? null : json['catDesc'] as String,
    );
  }

  @override
  String toString() {
    return '''Category(
                id:$id,
catDesc:$catDesc
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Category &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.catDesc == catDesc;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, catDesc);
  }
}
