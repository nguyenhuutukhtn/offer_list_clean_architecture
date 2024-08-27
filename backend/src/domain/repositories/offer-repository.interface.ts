import { Offer } from '../entities/offer.entity';

export interface OfferRepository {
  getOffers(): Promise<Offer[]>;
  createOffer(offer: Offer): Promise<Offer>;
  updateOffer(offer: Offer): Promise<Offer>;
  deleteOffer(offerId: string): Promise<void>;
}