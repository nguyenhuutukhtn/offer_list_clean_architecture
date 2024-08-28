import 'package:dartz/dartz.dart';
import 'package:mobile_app/data/datasources/purchase_remote_data_source.dart';
import '../../domain/entities/purchase_history.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PurchaseRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PurchaseHistory>>> getPurchaseHistory(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final purchaseHistory = await remoteDataSource.getPurchaseHistory(userId);
        return Right(purchaseHistory);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}