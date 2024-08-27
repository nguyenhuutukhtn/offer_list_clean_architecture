import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failures.dart';
import 'package:mobile_app/domain/repositories/offer_repository.dart';
import 'package:mobile_app/domain/usecases/delete_offer.dart';
import 'package:mockito/mockito.dart';

class MockOfferRepository extends Mock implements OfferRepository {}

void main() {
  late DeleteOffer usecase;
  late MockOfferRepository mockOfferRepository;

  setUp(() {
    mockOfferRepository = MockOfferRepository();
    usecase = DeleteOffer(mockOfferRepository);
  });

  final tOfferId = '1';

  test(
    'should delete the offer when the id is valid',
    () async {
      // arrange
      when(mockOfferRepository.deleteOffer(any))
          .thenAnswer((_) async => Right(null));
      // act
      final result = await usecase(tOfferId);
      // assert
      expect(result, Right(null));
      verify(mockOfferRepository.deleteOffer(tOfferId));
      verifyNoMoreInteractions(mockOfferRepository);
    },
  );

  test(
    'should return a Failure when the repository call fails',
    () async {
      // arrange
      when(mockOfferRepository.deleteOffer(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // act
      final result = await usecase(tOfferId);
      // assert
      expect(result, Left(ServerFailure()));
      verify(mockOfferRepository.deleteOffer(tOfferId));
      verifyNoMoreInteractions(mockOfferRepository);
    },
  );
}