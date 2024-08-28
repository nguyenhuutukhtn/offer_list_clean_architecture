import { OfferController } from '../../../src/presentation/controllers/offer.controller';
import { GetOffersUseCase } from '../../../src/domain/usecases/get-offers.usecase';
import { CreateOfferUseCase } from '../../../src/domain/usecases/create-offer.usecase';
import { UpdateOfferUseCase } from '../../../src/domain/usecases/update-offer.usecase';
import { DeleteOfferUseCase } from '../../../src/domain/usecases/delete-offer.usecase';
import { Offer } from '../../../src/domain/entities/offer.entity';
import { Request, Response } from 'express';

describe('OfferController', () => {
  let offerController: OfferController;
  let mockGetOffersUseCase: jest.Mocked<GetOffersUseCase>;
  let mockCreateOfferUseCase: jest.Mocked<CreateOfferUseCase>;
  let mockUpdateOfferUseCase: jest.Mocked<UpdateOfferUseCase>;
  let mockDeleteOfferUseCase: jest.Mocked<DeleteOfferUseCase>;

  beforeEach(() => {
    mockGetOffersUseCase = { execute: jest.fn() } as any;
    mockCreateOfferUseCase = { execute: jest.fn() } as any;
    mockUpdateOfferUseCase = { execute: jest.fn() } as any;
    mockDeleteOfferUseCase = { execute: jest.fn() } as any;

    offerController = new OfferController(
      mockGetOffersUseCase,
      mockCreateOfferUseCase,
      mockUpdateOfferUseCase,
      mockDeleteOfferUseCase
    );
  });

  describe('getOffers', () => {
    it('should return offers', async () => {
      const mockOffers = [new Offer('1', 'Test Offer', 'Test Description', 10, 100, 90)];
      mockGetOffersUseCase.execute.mockResolvedValue(mockOffers);

      const mockReq = {} as Request;
      const mockRes = {
        json: jest.fn(),
        status: jest.fn().mockReturnThis(),
      } as unknown as Response;

      await offerController.getOffers(mockReq, mockRes);

      expect(mockRes.json).toHaveBeenCalledWith(mockOffers);
    });

    // Add more tests for other controller methods
  });
});