import { inject, injectable } from 'inversify';
import { UseCase } from '../../core/interfaces/use-case.interface';
import { OfferRepository } from '../repositories/offer-repository.interface';

@injectable()

export class DeleteOfferUseCase implements UseCase<string, void> {
  constructor(@inject('OfferRepository') private offerRepository: OfferRepository) {}

  async execute(offerId: string): Promise<void> {
    return this.offerRepository.deleteOffer(offerId);
  }
}