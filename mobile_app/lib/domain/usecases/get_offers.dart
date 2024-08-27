import 'package:dartz/dartz.dart';
import '../entities/offer.dart';
import '../repositories/offer_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class GetOffers implements UseCase<List<Offer>, NoParams> {
  final OfferRepository repository;

  GetOffers(this.repository);

  @override
  Future<Either<Failure, List<Offer>>> call(NoParams params) async {
    return await repository.getOffers();
  }
}