import { Container } from 'inversify';
import { OfferRepository } from './domain/repositories/offer-repository.interface';
import { OfferRepositoryImpl } from './data/repositories/offer-repository.impl';
import { GetOffersUseCase } from './domain/usecases/get-offers.usecase';
import { CreateOfferUseCase } from './domain/usecases/create-offer.usecase';
import { OfferController } from './presentation/controllers/offer.controller';

const container = new Container();

// Repositories
container.bind<OfferRepository>('OfferRepository').to(OfferRepositoryImpl);

// Use Cases
container.bind<GetOffersUseCase>(GetOffersUseCase).toSelf();
container.bind<CreateOfferUseCase>(CreateOfferUseCase).toSelf();

// Controllers
container.bind<OfferController>(OfferController).toSelf();

export { container };