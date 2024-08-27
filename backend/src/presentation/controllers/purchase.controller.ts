import { Request, Response } from 'express';
import { PurchaseOffer } from '../usecases/purchase-offer';
import { ValidationError, NotFoundError } from '../errors/custom-errors';
import PurchaseHistory from '../models/purchase-history.model';
import Offer from '../models/offer.model';

export class PurchaseController {
  constructor(private purchaseOffer: PurchaseOffer) {}

  async purchaseOffer(req: Request, res: Response): Promise<void> {
    try {
      const { userId, offerId } = req.body;

      if (!userId || !offerId) {
        throw new ValidationError('User ID and Offer ID are required');
      }

      const offer = await Offer.findById(offerId);
      if (!offer) {
        throw new NotFoundError('Offer not found');
      }

      await this.purchaseOffer.execute(userId, offerId);

      // Store purchase history
      const purchaseHistory = new PurchaseHistory({
        userId,
        offerId,
      });
      await purchaseHistory.save();

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

      const purchaseHistory = await PurchaseHistory.find({ userId })
        .populate('offerId')
        .sort({ purchaseDate: -1 });

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