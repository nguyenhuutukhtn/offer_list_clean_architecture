import 'package:equatable/equatable.dart';
import 'offer.dart';

class PurchaseHistory extends Equatable {
  final String id;
  final String userId;
  final Offer offer;
  final DateTime purchaseDate;

  PurchaseHistory({
    required this.id,
    required this.userId,
    required this.offer,
    required this.purchaseDate,
  });

  @override
  List<Object> get props => [id, userId, offer, purchaseDate];
}