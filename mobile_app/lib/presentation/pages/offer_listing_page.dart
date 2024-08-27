import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/presentation/bloc/offer_event.dart';
import 'package:mobile_app/presentation/bloc/offer_state.dart';
import '../bloc/offer_bloc.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_form.dart';
import '../widgets/app_drawer.dart';
import '../../core/services/auth_service.dart';

class OfferListingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Special Offers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showOfferForm(context);
            },
          ),
        ],
      ),
      drawer: AppDrawer(authService: authService),
      body: BlocConsumer<OfferBloc, OfferState>(
        listener: (context, state) {
          if (state is OfferError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is OfferCreated || state is OfferUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Offer saved successfully')),
            );
          } else if (state is OfferDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Offer deleted successfully')),
            );
          }
        },
        builder: (context, state) {
          if (state is OfferInitial) {
            BlocProvider.of<OfferBloc>(context).add(GetOffersEvent());
            return Center(child: CircularProgressIndicator());
          } else if (state is OfferLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is OfferLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<OfferBloc>(context).add(GetOffersEvent());
              },
              child: ListView.builder(
                itemCount: state.offers.length,
                itemBuilder: (context, index) {
                  return OfferCard(
                    offer: state.offers[index],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/offer_details',
                        arguments: state.offers[index],
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is OfferError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Oops! Something went wrong.',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<OfferBloc>(context).add(GetOffersEvent());
                    },
                    child: Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('No offers available'));
        },
      ),
    );
  }

  void _showOfferForm(BuildContext context) {
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
              child: OfferForm(),
            ),
          ),
        );
      },
    );
  }
}