import '../../domain/entities/offer.dart';

class OfferModel extends Offer {
  OfferModel({
    required String id,
    required String title,
    required String description,
    required double discountPercentage,
    required double originalPrice,
    required double discountedPrice,
  }) : super(
          id: id,
          title: title,
          description: description,
          discountPercentage: discountPercentage,
          originalPrice: originalPrice,
          discountedPrice: discountedPrice,
        );

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      discountPercentage: json['discountPercentage'].toDouble(),
      originalPrice: json['originalPrice'].toDouble(),
      discountedPrice: json['discountedPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'discountPercentage': discountPercentage,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
    };
  }
}