import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failures.dart';
import 'package:mobile_app/domain/entities/offer.dart';
import 'package:mobile_app/domain/repositories/offer_repository.dart';
import 'package:mobile_app/domain/usecases/create_offer.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockOfferRepository extends Mock implements OfferRepository {}

void main() {
  late CreateOffer usecase;
  late MockOfferRepository mockOfferRepository;

  setUp(() {
    mockOfferRepository = MockOfferRepository();
    usecase = CreateOffer(mockOfferRepository);
  });

  final tOffer = Offer(
    id: '1',
    title: 'Test Offer',
    description: 'Test Description',
    discountPercentage: 10,
    originalPrice: 100,
    discountedPrice: 90,
  );

  test(
    'should create the offer when the input is valid',
    () async {
      // arrange
      when(mockOfferRepository.createOffer(any))
          .thenAnswer((_) async => Right(tOffer));
      // act
      final result = await usecase(CreateOfferParams(tOffer));
      // assert
      expect(result, Right(tOffer));
      verify(mockOfferRepository.createOffer(tOffer));
      verifyNoMoreInteractions(mockOfferRepository);
    },
  );

  test(
    'should return a ValidationFailure when the title is empty',
    () async {
      // arrange
      final invalidOffer = tOffer.copyWith(title: '');
      // act
      final result = await usecase(CreateOfferParams(invalidOffer));
      // assert
      expect(result, Left(ValidationFailure('Title cannot be empty')));
      verifyZeroInteractions(mockOfferRepository);
    },
  );

  // Add more tests for other validation cases
}