import 'package:jasaku/features/home/domain/entities/category_entity.dart';

class CategoryModel {
  final String? id;
  final String? catDesc;
  final String? catEmoji;
  final String? catColor;
  final String? createdAt;
  final String? updatedAt;
  const CategoryModel({
    this.id,
    this.catDesc,
    this.catEmoji,
    this.catColor,
    this.createdAt,
    this.updatedAt,
  });
  CategoryModel copyWith({
    String? id,
    String? catDesc,
    String? catEmoji,
    String? catColor,
    String? createdAt,
    String? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      catDesc: catDesc ?? this.catDesc,
      catEmoji: catEmoji ?? this.catEmoji,
      catColor: catColor ?? this.catColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'catDesc': catDesc,
      'catEmoji': catEmoji,
      'catColor': catColor,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static CategoryModel fromJson(Map<String, Object?> json) {
    return CategoryModel(
      id: json['id'] == null ? null : json['id'] as String,
      catDesc: json['catDesc'] == null ? null : json['catDesc'] as String,
      catEmoji: json['catEmoji'] == null ? null : json['catEmoji'] as String,
      catColor: json['catColor'] == null ? null : json['catColor'] as String,
      createdAt: json['createdAt'] == null ? null : json['createdAt'] as String,
      updatedAt: json['updatedAt'] == null ? null : json['updatedAt'] as String,
    );
  }

  CategoryEntity toEntity() => CategoryEntity(
    id: id,
    catDesc: catDesc,
    catEmoji: catEmoji,
    catColor: catColor,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  @override
  String toString() {
    return '''CategoryModel(
                id:$id,
catDesc:$catDesc,
catEmoji:$catEmoji,
catColor:$catColor,
createdAt:$createdAt,
updatedAt:$updatedAt
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryModel &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.catDesc == catDesc &&
        other.catEmoji == catEmoji &&
        other.catColor == catColor &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      catDesc,
      catEmoji,
      catColor,
      createdAt,
      updatedAt,
    );
  }
}
