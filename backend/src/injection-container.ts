import 'reflect-metadata';
import { Container } from 'inversify';
import { OfferRepository } from './domain/repositories/offer-repository.interface';
import { OfferRepositoryImpl } from './data/repositories/offer-repository.impl';
import { GetOffersUseCase } from './domain/usecases/get-offers.usecase';
import { CreateOfferUseCase } from './domain/usecases/create-offer.usecase';
import { UpdateOfferUseCase } from './domain/usecases/update-offer.usecase';
import { DeleteOfferUseCase } from './domain/usecases/delete-offer.usecase';
import { OfferController } from './presentation/controllers/offer.controller';
import { PurchaseController } from './presentation/controllers/purchase.controller';
import { PurchaseOfferUseCase } from './domain/usecases/purchase_offer.usecase';
import { GetPurchaseHistoryUseCase } from './domain/usecases/get_purchase_history.usecase';
import { PurchaseHistoryRepository } from './domain/repositories/purchase-history-repository.interface';
import { PurchaseHistoryRepositoryImpl } from './data/repositories/purchase-history-repository.impl';

const container = new Container();

// Repositories
container.bind<OfferRepository>('OfferRepository').to(OfferRepositoryImpl);
container.bind<PurchaseHistoryRepository>('PurchaseHistoryRepository').to(PurchaseHistoryRepositoryImpl);

// Use Cases
container.bind<GetOffersUseCase>(GetOffersUseCase).toSelf();
container.bind<CreateOfferUseCase>(CreateOfferUseCase).toSelf();
container.bind<UpdateOfferUseCase>(UpdateOfferUseCase).toSelf();
container.bind<DeleteOfferUseCase>(DeleteOfferUseCase).toSelf();
container.bind<PurchaseOfferUseCase>(PurchaseOfferUseCase).toSelf();
container.bind<GetPurchaseHistoryUseCase>(GetPurchaseHistoryUseCase).toSelf();

// Controllers
container.bind<OfferController>(OfferController).toSelf();
container.bind<PurchaseController>(PurchaseController).toSelf();

export { container };