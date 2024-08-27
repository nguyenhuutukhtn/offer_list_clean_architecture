import 'package:dartz/dartz.dart';
import '../repositories/offer_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class DeleteOffer implements UseCase<void, String> {
  final OfferRepository repository;

  DeleteOffer(this.repository);

  @override
  Future<Either<Failure, void>> call(String offerId) async {
    return await repository.deleteOffer(offerId);
  }
}