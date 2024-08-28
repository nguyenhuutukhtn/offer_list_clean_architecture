import { GetOffersUseCase } from '../../../src/domain/usecases/get-offers.usecase';
import { OfferRepository } from '../../../src/domain/repositories/offer-repository.interface';
import { Offer } from '../../../src/domain/entities/offer.entity';

describe('GetOffersUseCase', () => {
  let getOffersUseCase: GetOffersUseCase;
  let mockOfferRepository: jest.Mocked<OfferRepository>;

  beforeEach(() => {
    mockOfferRepository = {
      getOffers: jest.fn(),
      createOffer: jest.fn(),
      updateOffer: jest.fn(),
      deleteOffer: jest.fn(),
    };
    getOffersUseCase = new GetOffersUseCase(mockOfferRepository);
  });

  it('should get offers from the repository', async () => {
    const mockOffers: Offer[] = [
      new Offer('1', 'Test Offer', 'Test Description', 10, 100, 90),
    ];
    mockOfferRepository.getOffers.mockResolvedValue(mockOffers);

    const result = await getOffersUseCase.execute();

    expect(result).toEqual(mockOffers);
    expect(mockOfferRepository.getOffers).toHaveBeenCalled();
  });
});