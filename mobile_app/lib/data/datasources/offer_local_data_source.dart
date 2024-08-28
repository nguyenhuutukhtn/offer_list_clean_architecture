// import 'package:mobile_app/core/database/database_helper.dart';
// import 'package:mobile_app/core/error/exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import '../models/offer_model.dart';

// abstract class OfferLocalDataSource {
//   Future<List<OfferModel>> getCachedOffers();
//   Future<void> cacheOffers(List<OfferModel> offers);
// }

// class OfferLocalDataSourceImpl implements OfferLocalDataSource {
//   final DatabaseHelper databaseHelper;

//   OfferLocalDataSourceImpl({required this.databaseHelper});

//   @override
//   Future<List<OfferModel>> getCachedOffers() async {
//     try {
//       final db = await databaseHelper.database;
//       final maps = await db.query('offers');
//       return List.generate(maps.length, (i) => OfferModel.fromJson(maps[i]));
//     } catch (e) {
//       throw CacheException();
//     }
//   }

//   @override
//   Future<void> cacheOffers(List<OfferModel> offers) async {
//     try {
//       final db = await databaseHelper.database;
//       await db.transaction((txn) async {
//         await txn.delete('offers');
//         for (var offer in offers) {
//           await txn.insert('offers', offer.toJson());
//         }
//       });
//     } catch (e) {
//       throw CacheException();
//     }
//   }
// }