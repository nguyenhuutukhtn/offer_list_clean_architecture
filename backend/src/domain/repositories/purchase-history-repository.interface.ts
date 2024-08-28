import { PurchaseHistory } from "../entities/purchase_history.entity";

export interface PurchaseHistoryRepository {
  getPurchaseHistory(userId: string): Promise<PurchaseHistory[]>;
  createPurchaseHistory(purchaseHistory: Omit<PurchaseHistory, 'id'>): Promise<PurchaseHistory>;
}