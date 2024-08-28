import { UseCase } from '../../core/interfaces/use-case.interface';
import { OfferRepository } from '../repositories/offer-repository.interface';
import { PurchaseHistoryRepository } from '../repositories/purchase-history-repository.interface';
import { NotFoundError } from '../../core/errors/app-error';
import { inject, injectable } from 'inversify';

export interface PurchaseOfferParams {
  userId: string;
  offerId: string;
}

@injectable()

export class PurchaseOfferUseCase implements UseCase<PurchaseOfferParams, void> {
  constructor(
    @inject('OfferRepository')  private offerRepository: OfferRepository,
    @inject('PurchaseHistoryRepository')  private purchaseHistoryRepository: PurchaseHistoryRepository
  ) {}

  async execute(params: PurchaseOfferParams): Promise<void> {
    const offer = await this.offerRepository.getOfferById(params.offerId);
    if (!offer) {
      throw new NotFoundError('Offer not found');
    }

    await this.purchaseHistoryRepository.createPurchaseHistory({
      userId: params.userId,
      offerId: params.offerId,
      purchaseDate: new Date(),
    });
  }
}