import { Router } from 'express';
import { OfferController } from '../controllers/offer.controller';
import { PurchaseController } from '../controllers/purchase.controller';
import { authMiddleware } from '../../middleware/auth.middleware';

export const offerRouter = (offerController: OfferController, purchaseController: PurchaseController) => {
  const router = Router();

  router.get('/', offerController.getOffers.bind(offerController));
  router.post('/', authMiddleware, offerController.createOffer.bind(offerController));
  router.put('/:id', authMiddleware, offerController.updateOffer.bind(offerController));
  router.delete('/:id', authMiddleware, offerController.deleteOffer.bind(offerController));
  router.post('/:id/purchase', authMiddleware, purchaseController.purchaseOffer.bind(purchaseController));
  router.get('/history/:userId', authMiddleware, purchaseController.getPurchaseHistory.bind(purchaseController));

  return router;
};