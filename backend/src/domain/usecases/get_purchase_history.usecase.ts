import { inject, injectable } from 'inversify';
import { UseCase } from '../../core/interfaces/use-case.interface';
import { PurchaseHistory } from '../entities/purchase_history.entity';
import { PurchaseHistoryRepository } from '../repositories/purchase-history-repository.interface';

@injectable()

export class GetPurchaseHistoryUseCase implements UseCase<string, PurchaseHistory[]> {
  constructor(@inject('PurchaseHistoryRepository') private purchaseHistoryRepository: PurchaseHistoryRepository) {}

  async execute(userId: string): Promise<PurchaseHistory[]> {
    return this.purchaseHistoryRepository.getPurchaseHistory(userId);
  }
}