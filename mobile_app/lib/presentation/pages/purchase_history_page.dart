import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/purchase_history_bloc.dart';
import '../../domain/entities/purchase_history.dart';

class PurchaseHistoryPage extends StatelessWidget {
  final String userId;

  const PurchaseHistoryPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Purchase History')),
      body: BlocProvider(
        create: (context) => PurchaseHistoryBloc(
          getPurchaseHistory: RepositoryProvider.of(context),
        )..add(GetPurchaseHistoryEvent(userId)),
        child: BlocBuilder<PurchaseHistoryBloc, PurchaseHistoryState>(
          builder: (context, state) {
            if (state is PurchaseHistoryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PurchaseHistoryLoaded) {
              return ListView.builder(
                itemCount: state.purchaseHistory.length,
                itemBuilder: (context, index) {
                  return PurchaseHistoryItem(purchaseHistory: state.purchaseHistory[index]);
                },
              );
            } else if (state is PurchaseHistoryError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No purchase history available'));
          },
        ),
      ),
    );
  }
}

class PurchaseHistoryItem extends StatelessWidget {
  final PurchaseHistory purchaseHistory;

  const PurchaseHistoryItem({Key? key, required this.purchaseHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(purchaseHistory.offer.title),
      subtitle: Text('Purchased on ${purchaseHistory.purchaseDate.toLocal()}'),
      trailing: Text('\$${purchaseHistory.offer.discountedPrice}'),
    );
  }
}