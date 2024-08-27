import { UseCase } from '../../core/interfaces/use-case.interface';
import { OfferRepository } from '../repositories/offer-repository.interface';

export class DeleteOfferUseCase implements UseCase<string, void> {
  constructor(private offerRepository: OfferRepository) {}

  async execute(offerId: string): Promise<void> {
    return this.offerRepository.deleteOffer(offerId);
  }
}