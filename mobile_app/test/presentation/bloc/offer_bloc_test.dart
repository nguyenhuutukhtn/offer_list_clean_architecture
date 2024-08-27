import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failures.dart';
import 'package:mobile_app/domain/entities/offer.dart';
import 'package:mobile_app/domain/usecases/create_offer.dart';
import 'package:mobile_app/domain/usecases/delete_offer.dart';
import 'package:mobile_app/domain/usecases/get_offers.dart';
import 'package:mobile_app/domain/usecases/update_offer.dart';
import 'package:mobile_app/presentation/bloc/offer_bloc.dart';
import 'package:mobile_app/presentation/bloc/offer_event.dart';
import 'package:mobile_app/presentation/bloc/offer_state.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';

class MockGetOffers extends Mock implements GetOffers {}
class MockCreateOffer extends Mock implements CreateOffer {}
class MockUpdateOffer extends Mock implements UpdateOffer {}
class MockDeleteOffer extends Mock implements DeleteOffer {}

void main() {
  late OfferBloc bloc;
  late MockGetOffers mockGetOffers;
  late MockCreateOffer mockCreateOffer;
  late MockUpdateOffer mockUpdateOffer;
  late MockDeleteOffer mockDeleteOffer;

  setUp(() {
    mockGetOffers = MockGetOffers();
    mockCreateOffer = MockCreateOffer();
    mockUpdateOffer = MockUpdateOffer();
    mockDeleteOffer = MockDeleteOffer();

    bloc = OfferBloc(
      getOffers: mockGetOffers,
      createOffer: mockCreateOffer,
      updateOffer: mockUpdateOffer,
      deleteOffer: mockDeleteOffer,
    );
  });

  final tOffer = Offer(
    id: '1',
    title: 'Test Offer',
    description: 'Test Description',
    discountPercentage: 10,
    originalPrice: 100,
    discountedPrice: 90,
  );

  group('GetOffersEvent', () {
    test('initial state is OfferInitial', () {
      expect(bloc.state, OfferInitial());
    });

    blocTest<OfferBloc, OfferState>(
      'emits [OfferLoading, OfferLoaded] when GetOffersEvent is added and successful',
      build: () {
        when(mockGetOffers(any)).thenAnswer((_) async => Right([tOffer]));
        return bloc;
      },
      act: (bloc) => bloc.add(GetOffersEvent()),
      expect: () => [
        OfferLoading(),
        OfferLoaded([tOffer]),
      ],
    );

    blocTest<OfferBloc, OfferState>(
      'emits [OfferLoading, OfferError] when GetOffersEvent is added and fails',
      build: () {
        when(mockGetOffers(any)).thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetOffersEvent()),
      expect: () => [
        OfferLoading(),
        OfferError('Server failure'),
      ],
    );
  });

  // Add similar tests for CreateOfferEvent, UpdateOfferEvent, and DeleteOfferEvent
}