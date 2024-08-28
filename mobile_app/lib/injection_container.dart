import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/core/database/database_helper.dart';
import 'core/network/network_info.dart';
import 'core/services/auth_service.dart';
import 'data/datasources/offer_remote_data_source.dart';
import 'data/datasources/offer_local_data_source.dart';
import 'data/datasources/purchase_remote_data_source.dart';
import 'data/repositories/offer_repository_impl.dart';
import 'data/repositories/purchase_repository_impl.dart';
import 'domain/repositories/offer_repository.dart';
import 'domain/repositories/purchase_repository.dart';
import 'domain/usecases/get_offers.dart';
import 'domain/usecases/create_offer.dart';
import 'domain/usecases/update_offer.dart';
import 'domain/usecases/delete_offer.dart';
import 'domain/usecases/purchase_offer.dart';
import 'domain/usecases/get_purchase_history.dart';
import 'presentation/bloc/offer_bloc.dart';
import 'presentation/bloc/purchase_bloc.dart';
import 'presentation/bloc/purchase_history_bloc.dart';
import 'presentation/bloc/authentication_bloc.dart';

final sl = GetIt.instance;

const BASE_DOMAIN = const String.fromEnvironment("domain", defaultValue: "");


Future<void> init() async {
  // Use cases
  sl.registerLazySingleton(() => GetOffers(sl()));
  sl.registerLazySingleton(() => CreateOffer(sl()));
  sl.registerLazySingleton(() => UpdateOffer(sl()));
  sl.registerLazySingleton(() => DeleteOffer(sl()));
  sl.registerLazySingleton(() => PurchaseOffer(sl()));
  sl.registerLazySingleton(() => GetPurchaseHistory(sl()));

  // BLoCs
  sl.registerFactory(() => OfferBloc(
        getOffers: sl(),
        createOffer: sl(),
        updateOffer: sl(),
        deleteOffer: sl(),
      ));
  sl.registerFactory(() => PurchaseBloc(purchaseOffer: sl()));
  sl.registerFactory(() => PurchaseHistoryBloc(getPurchaseHistory: sl()));
  sl.registerFactory(() => AuthenticationBloc(authService: sl()));

  // Repositories
  sl.registerLazySingleton<OfferRepository>(
    () => OfferRepositoryImpl(
      remoteDataSource: sl(),
      // localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<PurchaseRepository>(
    () => PurchaseRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<OfferRemoteDataSource>(
    () => OfferRemoteDataSourceImpl(
        client: sl(), authService: sl(), baseUrl: BASE_DOMAIN),
  );
  // sl.registerLazySingleton<OfferLocalDataSource>(
  //   () => OfferLocalDataSourceImpl(databaseHelper: sl()),
  // );
  sl.registerLazySingleton<PurchaseRemoteDataSource>(
    () => PurchaseRemoteDataSourceImpl(
        client: sl(), authService: sl(), baseUrl: BASE_DOMAIN),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => AuthService(sl()));
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
