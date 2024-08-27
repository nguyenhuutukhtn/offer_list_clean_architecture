import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/usecases/usecase.dart';
import 'package:mobile_app/domain/entities/offer.dart';
import 'package:mobile_app/domain/repositories/offer_repository.dart';
import 'package:mobile_app/domain/usecases/get_offers.dart';
import 'package:mockito/mockito.dart';

class MockOfferRepository extends Mock implements OfferRepository {}

void main() {
  late GetOffers usecase;
  late MockOfferRepository mockOfferRepository;

  setUp(() {
    mockOfferRepository = MockOfferRepository();
    usecase = GetOffers(mockOfferRepository);
  });

  final tOffers = [
    Offer(id: '1', title: 'Test Offer', description: 'Test Description', discountPercentage: 10, originalPrice: 100, discountedPrice: 90),
  ];

  test(
    'should get offers from the repository',
    () async {
      // arrange
      when(mockOfferRepository.getOffers())
          .thenAnswer((_) async => Right(tOffers));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tOffers));
      verify(mockOfferRepository.getOffers());
      verifyNoMoreInteractions(mockOfferRepository);
    },
  );
}