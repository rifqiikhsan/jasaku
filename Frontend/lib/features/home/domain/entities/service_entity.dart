class ServiceCategoryEntity {
  final String? id;
  final String? catDesc;

  const ServiceCategoryEntity({this.id, this.catDesc});
}

class ServiceEntity {
  final String? id;
  final String? serviceName;
  final List<ServiceCategoryEntity>? category;
  final double? summaryRating;
  final String? distance;
  final int? totalReviews;
  final String? priceMinimum;
  final String? emoji;
  final String? emojiColor;
  final String? isVerification;
  final String? createdAt;
  final String? updatedAt;

  const ServiceEntity({
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
}
