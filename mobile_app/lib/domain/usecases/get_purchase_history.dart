import 'package:dartz/dartz.dart';
import '../entities/purchase_history.dart';
import '../repositories/purchase_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class GetPurchaseHistory implements UseCase<List<PurchaseHistory>, String> {
  final PurchaseRepository repository;

  GetPurchaseHistory(this.repository);

  @override
  Future<Either<Failure, List<PurchaseHistory>>> call(String userId) async {
    return await repository.getPurchaseHistory(userId);
  }
}