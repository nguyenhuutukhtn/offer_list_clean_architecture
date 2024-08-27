import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/offer_remote_data_source.dart';
import 'data/repositories/offer_repository_impl.dart';
import 'domain/repositories/offer_repository.dart';
import 'domain/usecases/get_offers.dart';
import 'domain/usecases/create_offer.dart';
import 'presentation/bloc/offer_bloc.dart';

final sl = GetIt.instance;

void init() {
  // BLoC
  sl.registerFactory(
    () => OfferBloc(
      getOffers: sl(),
      createOffer: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetOffers(sl()));
  sl.registerLazySingleton(() => CreateOffer(sl()));

  // Repository
  sl.registerLazySingleton<OfferRepository>(
    () => OfferRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<OfferRemoteDataSource>(
    () => OfferRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}