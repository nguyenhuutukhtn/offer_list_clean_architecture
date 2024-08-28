import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/utils/snackbar_util.dart';
import 'package:mobile_app/presentation/bloc/offer_event.dart';
import 'package:mobile_app/presentation/bloc/offer_state.dart';
import 'package:mobile_app/presentation/pages/offer_details_page.dart';
import '../../core/services/auth_service.dart';
import '../bloc/offer_bloc.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_form.dart';
import '../widgets/app_drawer.dart';

class OfferListingPage extends StatefulWidget {
  @override
  State<OfferListingPage> createState() => _OfferListingPageState();
}

class _OfferListingPageState extends State<OfferListingPage> {
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    authService = RepositoryProvider.of<AuthService>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Special Offers',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<OfferBloc>(context).add(GetOffersEvent());
            },
          ),
        ],
      ),
      drawer: AppDrawer(authService: authService),
      body: BlocConsumer<OfferBloc, OfferState>(
        listener: (context, state) {
          if (state is OfferError) {
            SnackbarUtil.showErrorSnackbar(context, state.message);
          } else if (state is OfferCreated || state is OfferUpdated) {
            SnackbarUtil.showSuccessSnackbar(
                context, 'Offer saved successfully');
          } else if (state is OfferDeleted) {
            SnackbarUtil.showSuccessSnackbar(
                context, 'Offer deleted successfully');
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    // Mobile layout
                    return ListView.builder(
                      itemCount: state.offers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: OfferCard(
                            offer: state.offers[index],
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OfferDetailsPage(
                                            offer: state.offers[index],
                                          )));
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    // Web/tablet layout
                    return GridView.builder(
                      padding: EdgeInsets.all(16),
                      
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth > 900 ? 3 : 2,
                        childAspectRatio: constraints.maxWidth > 900 ? 2.2 : 1.4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: state.offers.length,
                      
                      itemBuilder: (context, index) {
                        return OfferCard(
                          offer: state.offers[index],
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OfferDetailsPage(
                                          offer: state.offers[index],
                                        )));
                          },
                        );
                      },
                    );
                  }
                },
              ),
            );
          } else if (state is OfferError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong.',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14, color: Colors.red),
                    textAlign: TextAlign.center,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOfferForm(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showOfferForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
