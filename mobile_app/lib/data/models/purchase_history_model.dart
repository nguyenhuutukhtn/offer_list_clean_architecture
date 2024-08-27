import '../../domain/entities/purchase_history.dart';
import 'offer_model.dart';

class PurchaseHistoryModel extends PurchaseHistory {
  PurchaseHistoryModel({
    required String id,
    required String userId,
    required OfferModel offer,
    required DateTime purchaseDate,
  }) : super(
          id: id,
          userId: userId,
          offer: offer,
          purchaseDate: purchaseDate,
        );

  factory PurchaseHistoryModel.fromJson(Map<String, dynamic> json) {
    return PurchaseHistoryModel(
      id: json['id'],
      userId: json['userId'],
      offer: OfferModel.fromJson(json['offer']),
      purchaseDate: DateTime.parse(json['purchaseDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'offer': (offer as OfferModel).toJson(),
      'purchaseDate': purchaseDate.toIso8601String(),
    };
  }
}