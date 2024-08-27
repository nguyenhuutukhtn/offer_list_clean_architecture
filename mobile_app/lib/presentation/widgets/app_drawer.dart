import 'package:flutter/material.dart';
import '../pages/offer_listing_page.dart';
import '../pages/purchase_history_page.dart';
import '../../core/services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  final AuthService authService;

  const AppDrawer({Key? key, required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Offers'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OfferListingPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Purchase History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PurchaseHistoryPage(userId: authService.currentUser!.uid),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              await authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}