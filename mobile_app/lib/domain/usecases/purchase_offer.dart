import 'package:dartz/dartz.dart';
import '../entities/offer.dart';
import '../repositories/offer_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class PurchaseOffer implements UseCase<void, PurchaseOfferParams> {
  final OfferRepository repository;

  PurchaseOffer(this.repository);

  @override
  Future<Either<Failure, void>> call(PurchaseOfferParams params) async {
    return await repository.purchaseOffer(params.offer, params.userId);
  }
}

class PurchaseOfferParams {
  final Offer offer;
  final String userId;

  PurchaseOfferParams(this.offer, this.userId);
}