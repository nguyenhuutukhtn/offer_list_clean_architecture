import { inject, injectable } from 'inversify';
import { UseCase } from '../../core/interfaces/use-case.interface';
import { Offer } from '../entities/offer.entity';
import { OfferRepository } from '../repositories/offer-repository.interface';

@injectable()
export class GetOffersUseCase implements UseCase<void, Offer[]> {
  constructor(
    @inject('OfferRepository') private offerRepository: OfferRepository
  ) {}

  async execute(): Promise<Offer[]> {
    return this.offerRepository.getOffers();
  }
}