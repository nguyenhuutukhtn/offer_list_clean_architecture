import mongoose, { Document, Schema } from 'mongoose';
import { PurchaseHistory } from '../../domain/entities/purchase_history.entity';

export interface PurchaseHistoryDocument extends Document, Omit<PurchaseHistory, 'id' | 'offerId'> {
  _id: mongoose.Types.ObjectId;
  offerId: mongoose.Types.ObjectId;
}

const purchaseHistorySchema = new Schema<PurchaseHistoryDocument>({
  userId: { type: String, required: true },
  offerId: { type: Schema.Types.ObjectId, ref: 'Offer', required: true },
  purchaseDate: { type: Date, default: Date.now },
});

export const PurchaseHistoryModel = mongoose.model<PurchaseHistoryDocument>('PurchaseHistory', purchaseHistorySchema);