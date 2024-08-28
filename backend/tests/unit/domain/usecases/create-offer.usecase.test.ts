import { jest } from '@jest/globals';
import { CreateOfferUseCase } from '../../../../src/domain/usecases/create-offer.usecase';
import { OfferRepository } from '../../../../src/domain/repositories/offer-repository.interface';
import { Offer } from '../../../../src/domain/entities/offer.entity';
import { ValidationError } from '../../../../src/core/errors/app-error';
import { beforeEach, describe } from 'node:test';

describe('CreateOfferUseCase', () => {
  let createOfferUseCase: CreateOfferUseCase;
  let mockOfferRepository: jest.Mocked<OfferRepository>;

  beforeEach(() => {
    mockOfferRepository = {
      getOffers: jest.fn(),
      createOffer: jest.fn(),
      updateOffer: jest.fn(),
      deleteOffer: jest.fn(),
      getOfferById: jest.fn(),
    };
    createOfferUseCase = new CreateOfferUseCase(mockOfferRepository);
  });

  it('should create an offer when input is valid', async () => {
    const offer = new Offer('', 'Test Offer', 'Test Description', 10, 100, 90);
    mockOfferRepository.createOffer.mockResolvedValue({ ...offer, id: '1' });

    const result = await createOfferUseCase.execute(offer);

    expect(result).toEqual({ ...offer, id: '1' });
    expect(mockOfferRepository.createOffer).toHaveBeenCalledWith(offer);
  });

  it('should throw ValidationError when title is empty', async () => {
    const offer = new Offer('', '', 'Test Description', 10, 100, 90);

    await expect(createOfferUseCase.execute(offer)).rejects.toThrow(ValidationError);
    expect(mockOfferRepository.createOffer).not.toHaveBeenCalled();
  });

  // Add more tests for other validation cases
});