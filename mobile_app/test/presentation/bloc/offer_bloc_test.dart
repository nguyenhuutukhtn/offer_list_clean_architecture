import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mobile_app/core/error/failures.dart';
import 'package:mobile_app/core/usecases/usecase.dart';
import 'package:mobile_app/domain/entities/offer.dart';
import 'package:mobile_app/domain/usecases/get_offers.dart';
import 'package:mobile_app/domain/usecases/create_offer.dart';
import 'package:mobile_app/domain/usecases/update_offer.dart';
import 'package:mobile_app/domain/usecases/delete_offer.dart';
import 'package:mobile_app/presentation/bloc/offer_bloc.dart';
import 'package:mobile_app/presentation/bloc/offer_event.dart';
import 'package:mobile_app/presentation/bloc/offer_state.dart';

// Generate mock classes
@GenerateMocks([GetOffers, CreateOffer, UpdateOffer, DeleteOffer])
import 'offer_bloc_test.mocks.dart';

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

  tearDown(() {
    bloc.close();
  });

  test('initial state should be OfferInitial', () {
    expect(bloc.state, equals(OfferInitial()));
  });

  group('GetOffersEvent', () {
    final tOffers = [Offer(id: '1', title: 'Test Offer', description: 'Test Description', discountPercentage: 10, originalPrice: 100, discountedPrice: 90)];

    blocTest<OfferBloc, OfferState>(
      'emits [OfferLoading, OfferLoaded] when GetOffersEvent is added and successful',
      build: () {
        when(mockGetOffers(any)).thenAnswer((_) async => Right(tOffers));
        return bloc;
      },
      act: (bloc) => bloc.add(GetOffersEvent()),
      expect: () => [
        OfferLoading(),
        OfferLoaded(tOffers),
      ],
    );

    blocTest<OfferBloc, OfferState>(
      'emits [OfferLoading, OfferError] when GetOffersEvent is added and unsuccessful',
      build: () {
        when(mockGetOffers(any)).thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetOffersEvent()),
      expect: () => [
        OfferLoading(),
        OfferError('Server failure. Please try again later.'),
      ],
    );
  });

  // Add more tests for other events (CreateOfferEvent, UpdateOfferEvent, DeleteOfferEvent)
}