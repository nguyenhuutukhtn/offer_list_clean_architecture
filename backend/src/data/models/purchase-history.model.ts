import mongoose, { Document, Schema } from 'mongoose';

export interface PurchaseHistory extends Document {
  userId: string;
  offerId: string;
  purchaseDate: Date;
}

const PurchaseHistorySchema: Schema = new Schema({
  userId: { type: String, required: true },
  offerId: { type: Schema.Types.ObjectId, ref: 'Offer', required: true },
  purchaseDate: { type: Date, default: Date.now },
});

export default mongoose.model<PurchaseHistory>('PurchaseHistory', PurchaseHistorySchema);