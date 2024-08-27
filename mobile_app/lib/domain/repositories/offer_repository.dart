import 'package:dartz/dartz.dart';
import '../entities/offer.dart';
import '../../core/error/failures.dart';

abstract class OfferRepository {
  Future<Either<Failure, List<Offer>>> getOffers();
  Future<Either<Failure, Offer>> createOffer(Offer offer);
 Future<Either<Failure, Offer>> updateOffer(Offer offer);
  Future<Either<Failure, void>> deleteOffer(String offerId);
   Future<Either<Failure, void>> purchaseOffer(Offer offer, String userId);
}