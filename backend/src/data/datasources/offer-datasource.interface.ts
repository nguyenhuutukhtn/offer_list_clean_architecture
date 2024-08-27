import { Offer } from '../../domain/entities/offer.entity';

export interface OfferDataSource {
  getOffers(): Promise<Offer[]>;
  createOffer(offer: Offer): Promise<Offer>;
  updateOffer(offer: Offer): Promise<Offer>;
  deleteOffer(offerId: string): Promise<void>;
}