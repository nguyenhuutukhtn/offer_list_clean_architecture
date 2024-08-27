import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/usecases/usecase.dart';
import '../../domain/usecases/get_offers.dart';
import '../../domain/usecases/create_offer.dart';
import '../../domain/usecases/update_offer.dart';
import '../../domain/usecases/delete_offer.dart';
import '../../core/error/failures.dart';
import 'offer_event.dart';
import 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  final GetOffers getOffers;
  final CreateOffer createOffer;
  final UpdateOffer updateOffer;
  final DeleteOffer deleteOffer;

  OfferBloc({
    required this.getOffers,
    required this.createOffer,
    required this.updateOffer,
    required this.deleteOffer,
  }) : super(OfferInitial()) {
    on<GetOffersEvent>(_onGetOffers);
    on<CreateOfferEvent>(_onCreateOffer);
    on<UpdateOfferEvent>(_onUpdateOffer);
    on<DeleteOfferEvent>(_onDeleteOffer);
  }

  void _onGetOffers(GetOffersEvent event, Emitter<OfferState> emit) async {
    emit(OfferLoading());
    final failureOrOffers = await getOffers(NoParams());
    emit(failureOrOffers.fold(
      (failure) => OfferError(_mapFailureToMessage(failure)),
      (offers) => OfferLoaded(offers),
    ));
  }

  void _onCreateOffer(CreateOfferEvent event, Emitter<OfferState> emit) async {
    emit(OfferLoading());
    final failureOrOffer = await createOffer(CreateOfferParams(event.offer));
    emit(failureOrOffer.fold(
      (failure) => OfferError(_mapFailureToMessage(failure)),
      (offer) => OfferCreated(offer),
    ));
  }

  void _onUpdateOffer(UpdateOfferEvent event, Emitter<OfferState> emit) async {
    emit(OfferLoading());
    final failureOrOffer = await updateOffer(UpdateOfferParams(event.offer));
    emit(failureOrOffer.fold(
      (failure) => OfferError(_mapFailureToMessage(failure)),
      (offer) => OfferUpdated(offer),
    ));
  }

  void _onDeleteOffer(DeleteOfferEvent event, Emitter<OfferState> emit) async {
    emit(OfferLoading());
    final failureOrVoid = await deleteOffer(event.offerId);
    emit(failureOrVoid.fold(
      (failure) => OfferError(_mapFailureToMessage(failure)),
      (_) => OfferDeleted(),
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server failure. Please try again later.';
      case NetworkFailure:
        return 'Network failure. Please check your internet connection.';
      case ValidationFailure:
        return (failure as ValidationFailure).message;
      case AuthenticationFailure:
        return 'Authentication failure. Please log in again.';
      case CacheFailure:
        return 'Cache failure. Please restart the app.';
      default:
        return 'Unexpected error. Please try again.';
    }
  }
}