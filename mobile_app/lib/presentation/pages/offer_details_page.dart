import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/presentation/bloc/offer_event.dart';
import '../../domain/entities/offer.dart';
import '../bloc/offer_bloc.dart';
import '../bloc/purchase_bloc.dart';
import '../widgets/offer_form.dart';

class OfferDetailsPage extends StatelessWidget {
  final Offer offer;

  const OfferDetailsPage({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(offer.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditOfferForm(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(offer.description),
            SizedBox(height: 16),
            Text('Original Price: \$${offer.originalPrice}'),
            Text('Discounted Price: \$${offer.discountedPrice}'),
            Text('Discount: ${offer.discountPercentage}%'),
            SizedBox(height: 32),
            BlocConsumer<PurchaseBloc, PurchaseState>(
              listener: (context, state) {
                if (state is PurchaseSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Purchase successful!')),
                  );
                } else if (state is PurchaseFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Purchase failed:')),
                  );
                }
              },
              builder: (context, state) {
                if (state is PurchaseLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  child: Text('Buy Now'),
                  onPressed: () => _showBuyNowDialog(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditOfferForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: OfferForm(offer: offer),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Offer'),
          content: Text('Are you sure you want to delete this offer?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                BlocProvider.of<OfferBloc>(context).add(DeleteOfferEvent(offer.id));
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to the listing page
              },
            ),
          ],
        );
      },
    );
  }

  void _showBuyNowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Purchase'),
          content: Text('Are you sure you want to buy this offer?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Buy'),
              onPressed: () {
                Navigator.of(context).pop();
                String userId = 'current_user_id';
                BlocProvider.of<PurchaseBloc>(context).add(PurchaseOfferEvent(offer, userId));
              },
            ),
          ],
        );
      },
    );
  }
}