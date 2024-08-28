import { inject, injectable } from 'inversify';
import { ValidationError } from '../../core/errors/app-error';
import { UseCase } from '../../core/interfaces/use-case.interface';
import { Offer } from '../entities/offer.entity';
import { OfferRepository } from '../repositories/offer-repository.interface';

@injectable()

export class UpdateOfferUseCase implements UseCase<Offer, Offer> {
  constructor(@inject('OfferRepository') private offerRepository: OfferRepository) {}

  async execute(offer: Offer): Promise<Offer> {
    this.validateOffer(offer);
    return this.offerRepository.updateOffer(offer);
  }

  private validateOffer(offer: Offer): void {
    if (!offer.title) {
      throw new ValidationError('Title is required');
    }
    if (!offer.description) {
      throw new ValidationError('Description is required');
    }
    if (offer.discountPercentage < 0 || offer.discountPercentage > 100) {
      throw new ValidationError('Discount percentage must be between 0 and 100');
    }
    if (offer.originalPrice <= 0) {
      throw new ValidationError('Original price must be greater than 0');
    }
    if (offer.discountedPrice <= 0 || offer.discountedPrice >= offer.originalPrice) {
      throw new ValidationError('Discounted price must be greater than 0 and less than the original price');
    }
  }
}
