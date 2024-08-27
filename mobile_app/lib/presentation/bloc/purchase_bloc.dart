import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/purchase_offer.dart';
import '../../domain/entities/offer.dart';
import '../../core/error/failures.dart';

// Events
abstract class PurchaseEvent extends Equatable {
  const PurchaseEvent();

  @override
  List<Object> get props => [];
}

class PurchaseOfferEvent extends PurchaseEvent {
  final Offer offer;
  final String userId;

  const PurchaseOfferEvent(this.offer, this.userId);

  @override
  List<Object> get props => [offer, userId];
}

// States
abstract class PurchaseState extends Equatable {
  const PurchaseState();
  
  @override
  List<Object> get props => [];
}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class PurchaseSuccess extends PurchaseState {}

class PurchaseFailure extends PurchaseState {
  final String message;

  const PurchaseFailure(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseOffer purchaseOffer;

  PurchaseBloc({required this.purchaseOffer}) : super(PurchaseInitial()) {
    on<PurchaseOfferEvent>(_onPurchaseOffer);
  }

  void _onPurchaseOffer(PurchaseOfferEvent event, Emitter<PurchaseState> emit) async {
    emit(PurchaseLoading());
    final result = await purchaseOffer(PurchaseOfferParams(event.offer, event.userId));
    emit(result.fold(
      (failure) => PurchaseFailure(_mapFailureToMessage(failure)),
      (_) => PurchaseSuccess(),
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Couldn\'t connect to the server. Please try again.';
      case NetworkFailure:
        return 'No internet connection. Please check your network settings.';
      case PurchaseFailure:
        return 'Failed to complete the purchase. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}