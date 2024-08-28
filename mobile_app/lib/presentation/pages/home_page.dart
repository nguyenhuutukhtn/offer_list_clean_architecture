import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication_bloc.dart';
import 'login_page.dart';
import 'offer_listing_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthenticationBloc>().add(LoginWithTokenEvent());
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is Authenticated) {
          return OfferListingPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}