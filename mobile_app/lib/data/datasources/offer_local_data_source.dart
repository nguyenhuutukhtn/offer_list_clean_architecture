import 'package:sqflite/sqflite.dart';
import '../models/offer_model.dart';

abstract class OfferLocalDataSource {
  Future<List<OfferModel>> getCachedOffers();
  Future<void> cacheOffers(List<OfferModel> offers);
}

class OfferLocalDataSourceImpl implements OfferLocalDataSource {
  final Database database;

  OfferLocalDataSourceImpl({required this.database});

  @override
  Future<List<OfferModel>> getCachedOffers() async {
    final List<Map<String, dynamic>> maps = await database.query('offers');
    return List.generate(maps.length, (i) {
      return OfferModel.fromJson(maps[i]);
    });
  }

  @override
  Future<void> cacheOffers(List<OfferModel> offers) async {
    await database.transaction((txn) async {
      await txn.delete('offers');
      for (var offer in offers) {
        await txn.insert('offers', offer.toJson());
      }
    });
  }
}