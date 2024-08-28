import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/services/auth_service.dart';
import 'package:mobile_app/domain/entities/offer.dart';
import 'package:mobile_app/domain/usecases/get_purchase_history.dart';
import 'package:mobile_app/presentation/bloc/authentication_bloc.dart';
import 'package:mobile_app/presentation/bloc/offer_bloc.dart';
import 'package:mobile_app/presentation/bloc/purchase_bloc.dart';
import 'package:mobile_app/presentation/bloc/purchase_history_bloc.dart';
import 'package:mobile_app/presentation/pages/login_page.dart';
import 'package:mobile_app/presentation/pages/offer_details_page.dart';
import 'package:mobile_app/presentation/pages/offer_listing_page.dart';
import 'package:mobile_app/presentation/pages/purchase_history_page.dart';
import 'injection_container.dart' as di;
import 'presentation/pages/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
         RepositoryProvider<AuthService>(
          create: (context) => di.sl<AuthService>(),
        ),
        RepositoryProvider<GetPurchaseHistory>(
          create: (context) => di.sl<GetPurchaseHistory>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<AuthenticationBloc>()),
          BlocProvider(create: (_) => di.sl<OfferBloc>()),
          BlocProvider(create: (_) => di.sl<PurchaseBloc>()),
          BlocProvider(create: (_) => di.sl<PurchaseHistoryBloc>()),
          
        ],
        child: MaterialApp(
          title: 'Offer App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(),
            '/login': (context) => LoginPage(),
            '/offers': (context) => OfferListingPage(),
            '/purchase_history': (context) => PurchaseHistoryPage(userId: RepositoryProvider.of<AuthService>(context).currentUser?.uid ?? ''),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/offer_details') {
              final args = settings.arguments as Offer;
              return MaterialPageRoute(
                builder: (context) => OfferDetailsPage(offer: args),
              );
            }
            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text('Route not found: ${settings.name}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}