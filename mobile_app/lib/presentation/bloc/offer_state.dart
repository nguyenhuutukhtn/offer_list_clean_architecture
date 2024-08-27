import 'package:equatable/equatable.dart';
import '../../domain/entities/offer.dart';

abstract class OfferState extends Equatable {
  const OfferState();
  
  @override
  List<Object> get props => [];
}

class OfferInitial extends OfferState {}

class OfferLoading extends OfferState {}

class OfferLoaded extends OfferState {
  final List<Offer> offers;

  const OfferLoaded(this.offers);

  @override
  List<Object> get props => [offers];
}

class OfferError extends OfferState {
  final String message;

  const OfferError(this.message);

  @override
  List<Object> get props => [message];
}

class OfferCreated extends OfferState {
  final Offer offer;

  const OfferCreated(this.offer);

  @override
  List<Object> get props => [offer];
}

class OfferUpdated extends OfferState {
  final Offer offer;

  const OfferUpdated(this.offer);

  @override
  List<Object> get props => [offer];
}

class OfferDeleted extends OfferState {}