import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/services/auth_service.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/offer.dart';
import '../models/offer_model.dart';

abstract class OfferRemoteDataSource {
  Future<List<OfferModel>> getOffers();
  Future<OfferModel> createOffer(OfferModel offer);
  Future<OfferModel> updateOffer(OfferModel offer);
  Future<void> deleteOffer(String offerId);
  Future<void> purchaseOffer(Offer offer, String userId);
}

class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  final http.Client client;
  final String baseUrl;
   final AuthService authService;

  OfferRemoteDataSourceImpl( {required this.client, required this.baseUrl, required this.authService});

   Future<Map<String, String>> _getHeaders() async {
    final token = await authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<OfferModel>> getOffers() async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/offers'),
      headers: await _getHeaders(),
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
    print(offer.toJson());
    final response = await client.post(
      Uri.parse('$baseUrl/api/offers'),
      headers: await _getHeaders(),
      body: json.encode(offer.toJson()),
    );

    print(response.body);

    if (response.statusCode == 201) {
      return OfferModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<OfferModel> updateOffer(OfferModel offer) async {
    final response = await client.put(
      Uri.parse('$baseUrl/api/offers/${offer.id}'),
      headers: await _getHeaders(),
      body: json.encode(offer.toJson()),
    );

    if (response.statusCode == 200) {
      return OfferModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteOffer(String offerId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/api/offers/$offerId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw ServerException();
    }
  }

  @override
  Future<void> purchaseOffer(Offer offer, String userId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/offers/${offer.id}/purchase'),
      headers: await _getHeaders(),
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