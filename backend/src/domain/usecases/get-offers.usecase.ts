import { UseCase } from '../../core/interfaces/use-case.interface';
import { Offer } from '../entities/offer.entity';
import { OfferRepository } from '../repositories/offer-repository.interface';

export class GetOffersUseCase implements UseCase<void, Offer[]> {
  constructor(private offerRepository: OfferRepository) {}

  async execute(): Promise<Offer[]> {
    return this.offerRepository.getOffers();
  }
}