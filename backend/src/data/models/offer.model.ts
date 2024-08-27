import { Schema, model } from 'mongoose';
import { Offer } from '../../domain/entities/offer.entity';

const offerSchema = new Schema<Offer>({
  title: { type: String, required: true },
  description: { type: String, required: true },
  discountPercentage: { type: Number, required: true },
  originalPrice: { type: Number, required: true },
  discountedPrice: { type: Number, required: true },
});

export const OfferModel = model<Offer>('Offer', offerSchema);