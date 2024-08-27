import 'package:dartz/dartz.dart';
import '../entities/purchase_history.dart';
import '../../core/error/failures.dart';

abstract class PurchaseRepository {
  Future<Either<Failure, List<PurchaseHistory>>> getPurchaseHistory(String userId);
}