import 'package:equatable/equatable.dart';
import '../../domain/entities/offer.dart';

abstract class OfferEvent extends Equatable {
  const OfferEvent();

  @override
  List<Object> get props => [];
}

class GetOffersEvent extends OfferEvent {}

class CreateOfferEvent extends OfferEvent {
  final Offer offer;

  const CreateOfferEvent(this.offer);

  @override
  List<Object> get props => [offer];
}

class UpdateOfferEvent extends OfferEvent {
  final Offer offer;

  const UpdateOfferEvent(this.offer);

  @override
  List<Object> get props => [offer];
}

class DeleteOfferEvent extends OfferEvent {
  final String offerId;

  const DeleteOfferEvent(this.offerId);

  @override
  List<Object> get props => [offerId];
}