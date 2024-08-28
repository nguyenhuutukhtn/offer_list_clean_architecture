import mongoose from 'mongoose';
import { PurchaseHistoryRepository } from '../../domain/repositories/purchase-history-repository.interface';
import { PurchaseHistoryModel, PurchaseHistoryDocument } from '../models/purchase-history.model';
import { PurchaseHistory } from '../../domain/entities/purchase_history.entity';
import { injectable } from 'inversify';

@injectable()

export class PurchaseHistoryRepositoryImpl implements PurchaseHistoryRepository {
  async getPurchaseHistory(userId: string): Promise<PurchaseHistory[]> {
    const purchaseHistories = await PurchaseHistoryModel.find({ userId }).populate('offerId');
    return purchaseHistories.map(this.toDomainEntity);
  }

  async createPurchaseHistory(purchaseHistory: Omit<PurchaseHistory, 'id'>): Promise<PurchaseHistory> {
    const newPurchaseHistory = new PurchaseHistoryModel({
      ...purchaseHistory,
      offerId: new mongoose.Types.ObjectId(purchaseHistory.offerId)
    });
    const savedPurchaseHistory = await newPurchaseHistory.save();
    return this.toDomainEntity(savedPurchaseHistory);
  }

  private toDomainEntity(doc: PurchaseHistoryDocument): PurchaseHistory {
    return new PurchaseHistory(
      doc._id.toString(),
      doc.userId,
      doc.offerId.toString(),
      doc.purchaseDate
    );
  }
}