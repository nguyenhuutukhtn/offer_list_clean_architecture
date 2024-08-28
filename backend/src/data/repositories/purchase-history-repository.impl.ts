import mongoose from 'mongoose';
import { PurchaseHistoryRepository } from '../../domain/repositories/purchase-history-repository.interface';
import { PurchaseHistoryModel, PurchaseHistoryDocument } from '../models/purchase-history.model';
import { PurchaseHistory } from '../../domain/entities/purchase_history.entity';
import { injectable } from 'inversify';
import { Offer } from '../../domain/entities/offer.entity';

@injectable()

export class PurchaseHistoryRepositoryImpl implements PurchaseHistoryRepository {
  async getPurchaseHistory(userId: string): Promise<PurchaseHistory[]> {
    const purchaseHistories = await PurchaseHistoryModel.find({ userId }).populate('offerId');
    return purchaseHistories.map(this.toDomainEntity);
  }

  async createPurchaseHistory(purchaseHistory: Omit<PurchaseHistory, 'id'>): Promise<PurchaseHistory> {
    const newPurchaseHistory = new PurchaseHistoryModel({
      ...purchaseHistory,
      offerId: purchaseHistory.offer.id
    });
    const savedPurchaseHistory = await newPurchaseHistory.save();
    await savedPurchaseHistory.populate('offerId');
    return this.toDomainEntity(savedPurchaseHistory);
  }

  private toDomainEntity(doc: PurchaseHistoryDocument & { offerId: any }): PurchaseHistory {
    const offer = doc.offerId; // This will be the populated Offer document
    return new PurchaseHistory(
      doc._id.toString(),
      doc.userId,
      new Offer(
        offer._id.toString(),
        offer.title,
        offer.description,
        offer.discountPercentage,
        offer.originalPrice,
        offer.discountedPrice
      ),
      doc.purchaseDate
    );
  }
}