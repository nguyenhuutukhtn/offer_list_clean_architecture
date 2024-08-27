import 'package:dartz/dartz.dart';
import '../entities/offer.dart';
import '../repositories/offer_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class CreateOffer implements UseCase<Offer, CreateOfferParams> {
  final OfferRepository repository;

  CreateOffer(this.repository);

  @override
  Future<Either<Failure, Offer>> call(CreateOfferParams params) async {
    if (params.offer.title.isEmpty) {
      return Left(ValidationFailure('Title cannot be empty'));
    }
    if (params.offer.description.isEmpty) {
      return Left(ValidationFailure('Description cannot be empty'));
    }
    if (params.offer.discountPercentage < 0 || params.offer.discountPercentage > 100) {
      return Left(ValidationFailure('Discount percentage must be between 0 and 100'));
    }
    if (params.offer.originalPrice <= 0) {
      return Left(ValidationFailure('Original price must be greater than 0'));
    }
    if (params.offer.discountedPrice <= 0 || params.offer.discountedPrice >= params.offer.originalPrice) {
      return Left(ValidationFailure('Discounted price must be greater than 0 and less than the original price'));
    }

    return await repository.createOffer(params.offer);
  }
}

class CreateOfferParams {
  final Offer offer;

  CreateOfferParams(this.offer);
}