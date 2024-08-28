import { OfferRepository } from '../../domain/repositories/offer-repository.interface';
import { Offer } from '../../domain/entities/offer.entity';
import { OfferModel } from '../models/offer.model';
import { injectable } from 'inversify';

@injectable()

export class OfferRepositoryImpl implements OfferRepository {
  async getOffers(): Promise<Offer[]> {
    const offers = await OfferModel.find();
    return offers.map(offer => new Offer(
      offer._id.toString(),
      offer.title,
      offer.description,
      offer.discountPercentage,
      offer.originalPrice,
      offer.discountedPrice
    ));
  }

  async createOffer(offer: Offer): Promise<Offer> {
    const newOffer = new OfferModel(offer);
    const savedOffer = await newOffer.save();
    return new Offer(
      savedOffer._id.toString(),
      savedOffer.title,
      savedOffer.description,
      savedOffer.discountPercentage,
      savedOffer.originalPrice,
      savedOffer.discountedPrice
    );
  }

  async updateOffer(offer: Offer): Promise<Offer> {
    const updatedOffer = await OfferModel.findByIdAndUpdate(offer.id, offer, { new: true });
    if (!updatedOffer) {
      throw new Error('Offer not found');
    }
    return new Offer(
      updatedOffer._id.toString(),
      updatedOffer.title,
      updatedOffer.description,
      updatedOffer.discountPercentage,
      updatedOffer.originalPrice,
      updatedOffer.discountedPrice
    );
  }

  async deleteOffer(offerId: string): Promise<void> {
    const result = await OfferModel.findByIdAndDelete(offerId);
    if (!result) {
      throw new Error('Offer not found');
    }
  }

  async getOfferById(offerId: string): Promise<Offer | null> {
    const offer = await OfferModel
      .findById(offerId);
    if (!offer) {
      return null;
    }
    return new Offer(
      offer._id.toString(),
      offer.title,
      offer.description,
      offer.discountPercentage,
      offer.originalPrice,
      offer.discountedPrice
    );
  }
}