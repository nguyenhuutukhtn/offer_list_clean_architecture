import 'package:dartz/dartz.dart';
import 'package:mobile_app/core/network/network_info.dart';
import 'package:mobile_app/data/datasources/offer_local_data_source.dart';
import 'package:mobile_app/data/models/offer_model.dart';
import '../../domain/entities/offer.dart';
import '../../domain/repositories/offer_repository.dart';
import '../datasources/offer_remote_data_source.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';


class OfferRepositoryImpl implements OfferRepository {
  final OfferRemoteDataSource remoteDataSource;
  // final OfferLocalDataSource localDataSource;
  final NetworkInfo networkInfo;


  OfferRepositoryImpl({
    required this.remoteDataSource,
    // required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Offer>>> getOffers() async {
    if (await _isConnected()) {
      try {
        final remoteOffers = await remoteDataSource.getOffers();
        // localDataSource.cacheOffers(remoteOffers);
        return Right(remoteOffers);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // try {
      //   final localOffers = await localDataSource.getCachedOffers();
      //   return Right(localOffers);
      // } on CacheException {
      //   return Left(CacheFailure());
      // }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Offer>> createOffer(Offer offer) async {
    if (await _isConnected()) {
      try {
        // Convert Offer to OfferModel
        final offerModel = OfferModel(
          id: offer.id,
          title: offer.title,
          description: offer.description,
          discountPercentage: offer.discountPercentage,
          originalPrice: offer.originalPrice,
          discountedPrice: offer.discountedPrice,
        );
        
        final remoteOffer = await remoteDataSource.createOffer(offerModel);
        return Right(remoteOffer);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Offer>> updateOffer(Offer offer) async {
    if (await _isConnected()) {
      try {
        
        final offerModel = OfferModel(
          id: offer.id,
          title: offer.title,
          description: offer.description,
          discountPercentage: offer.discountPercentage,
          originalPrice: offer.originalPrice,
          discountedPrice: offer.discountedPrice,
        );
        final updatedOffer = await remoteDataSource.updateOffer(offerModel);
        return Right(updatedOffer);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteOffer(String offerId) async {
    if (await _isConnected()) {
      try {
        await remoteDataSource.deleteOffer(offerId);
        return Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> purchaseOffer(Offer offer, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.purchaseOffer(offer, userId);
        return Right(null);
      } on ServerException {
        return Left(ServerFailure());
      } on PurchaseException {
        return Left(PurchaseFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  

  Future<bool> _isConnected() async {
    return await networkInfo.isConnected;
  }
}