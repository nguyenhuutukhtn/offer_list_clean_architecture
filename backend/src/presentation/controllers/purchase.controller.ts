import { Request, Response } from 'express';
import { ValidationError, NotFoundError } from '../../core/errors/app-error';
import { OfferModel } from '../../data/models/offer.model';
import { PurchaseOfferUseCase } from '../../domain/usecases/purchase_offer.usecase';
import { GetPurchaseHistoryUseCase } from '../../domain/usecases/get_purchase_history.usecase';
import { injectable } from 'inversify';

@injectable()

export class PurchaseController {
  constructor(
    private purchaseOfferUseCase: PurchaseOfferUseCase,
    private getPurchaseHistoryUseCase: GetPurchaseHistoryUseCase
  ) {}

  async purchaseOffer(req: Request, res: Response): Promise<void> {
    try {
      const { userId, offerId } = req.body;

      if (!userId || !offerId) {
        throw new ValidationError('User ID and Offer ID are required');
      }

      const offer = await OfferModel.findById(offerId);
      if (!offer) {
        throw new NotFoundError('Offer not found');
      }

      await this.purchaseOfferUseCase.execute({ userId, offerId });

      res.status(200).json({ message: 'Offer purchased successfully' });
    } catch (error) {
      if (error instanceof ValidationError) {
        res.status(400).json({ message: error.message });
      } else if (error instanceof NotFoundError) {
        res.status(404).json({ message: error.message });
      } else {
        console.error('Unexpected error:', error);
        res.status(500).json({ message: 'An unexpected error occurred' });
      }
    }
  }

  async getPurchaseHistory(req: Request, res: Response): Promise<void> {
    try {
      const { userId } = req.params;

      if (!userId) {
        throw new ValidationError('User ID is required');
      }

      const purchaseHistory = await this.getPurchaseHistoryUseCase.execute(userId);

      res.status(200).json(purchaseHistory);
    } catch (error) {
      if (error instanceof ValidationError) {
        res.status(400).json({ message: error.message });
      } else {
        console.error('Unexpected error:', error);
        res.status(500).json({ message: 'An unexpected error occurred' });
      }
    }
  }
}