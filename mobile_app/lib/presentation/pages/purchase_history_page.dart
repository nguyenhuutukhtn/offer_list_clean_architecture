import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/purchase_history_bloc.dart';
import '../../domain/entities/purchase_history.dart';
import 'package:intl/intl.dart';

class PurchaseHistoryPage extends StatelessWidget {
  final String userId;

  const PurchaseHistoryPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase History'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => PurchaseHistoryBloc(
          getPurchaseHistory: RepositoryProvider.of(context),
        )..add(GetPurchaseHistoryEvent(userId)),
        child: BlocBuilder<PurchaseHistoryBloc, PurchaseHistoryState>(
          builder: (context, state) {
            if (state is PurchaseHistoryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PurchaseHistoryLoaded) {
              return state.purchaseHistory.isEmpty
                  ? _buildEmptyState()
                  : _buildPurchaseList(state.purchaseHistory, context);
            } else if (state is PurchaseHistoryError) {
              return _buildErrorState(state.message);
            }
            return _buildEmptyState();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No purchase history available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Error loading purchase history',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseList(List<PurchaseHistory> purchaseHistory, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<PurchaseHistoryBloc>(context).add(GetPurchaseHistoryEvent(userId));
      },
      child: ListView.builder(
        itemCount: purchaseHistory.length,
        itemBuilder: (context, index) {
          return PurchaseHistoryItem(purchaseHistory: purchaseHistory[index]);
        },
      ),
    );
  }
}

class PurchaseHistoryItem extends StatelessWidget {
  final PurchaseHistory purchaseHistory;

  const PurchaseHistoryItem({Key? key, required this.purchaseHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          purchaseHistory.offer.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Purchased on ${DateFormat('MMM dd, yyyy').format(purchaseHistory.purchaseDate)}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          '\$${purchaseHistory.offer.discountedPrice.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offer Details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(purchaseHistory.offer.description),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Original Price:'),
                    Text(
                      '\$${purchaseHistory.offer.originalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount:'),
                    Text(
                      '${purchaseHistory.offer.discountPercentage.toStringAsFixed(0)}%',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('You Saved:'),
                    Text(
                      '\$${(purchaseHistory.offer.originalPrice - purchaseHistory.offer.discountedPrice).toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}