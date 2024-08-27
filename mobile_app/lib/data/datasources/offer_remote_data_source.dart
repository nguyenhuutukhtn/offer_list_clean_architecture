import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/error/exceptions.dart';
import 'package:mobile_app/domain/entities/offer.dart';
import '../models/offer_model.dart';

abstract class OfferRemoteDataSource {
  Future<List<OfferModel>> getOffers();
  Future<OfferModel> createOffer(OfferModel offer);
  Future<void> purchaseOffer(Offer offer, String userId);
}

class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  OfferRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<List<OfferModel>> getOffers() async {
    final response = await client.get(
      Uri.parse('http://localhost:3000/api/offers'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> offersJson = json.decode(response.body);
      return offersJson.map((json) => OfferModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<OfferModel> createOffer(OfferModel offer) async {
    final response = await client.post(
      Uri.parse('http://localhost:3000/api/offers'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(offer.toJson()),
    );

    if (response.statusCode == 201) {
      return OfferModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> purchaseOffer(Offer offer, String userId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/offers/${offer.id}/purchase'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'offerId': offer.id,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      throw ValidationException(json.decode(response.body)['message']);
    } else if (response.statusCode == 404) {
      throw NotFoundException('Offer not found');
    } else {
      throw ServerException();
    }
  }
}