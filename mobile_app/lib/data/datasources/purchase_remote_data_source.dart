import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/services/auth_service.dart';
import '../../core/error/exceptions.dart';
import '../models/purchase_history_model.dart';

abstract class PurchaseRemoteDataSource {
  Future<List<PurchaseHistoryModel>> getPurchaseHistory(String userId);
}

class PurchaseRemoteDataSourceImpl implements PurchaseRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final AuthService authService;

  PurchaseRemoteDataSourceImpl({required this.client, required this.baseUrl, required this.authService, });

  Future<Map<String, String>> _getHeaders() async {
    final token = await authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<PurchaseHistoryModel>> getPurchaseHistory(String userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/purchases/$userId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> purchaseHistoryJson = json.decode(response.body);
      return purchaseHistoryJson.map((json) => PurchaseHistoryModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }
}