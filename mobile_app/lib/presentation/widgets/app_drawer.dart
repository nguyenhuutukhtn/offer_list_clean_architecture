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
      child: Column(
        children: <Widget>[
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildDrawerItem(
                  icon: Icons.local_offer,
                  title: 'Offers',
                  onTap: () => _navigateTo(context, OfferListingPage()),
                ),
                _buildDrawerItem(
                  icon: Icons.history,
                  title: 'Purchase History',
                  onTap: () => _navigateTo(context, PurchaseHistoryPage(userId: authService.currentUser!.uid)),
                ),
                Divider(),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    // Navigate to settings page
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help,
                  title: 'Help & Feedback',
                  onTap: () {
                    // Navigate to help page
                  },
                ),
              ],
            ),
          ),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/drawer_header_bg.jpg'), // Add a background image
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      currentAccountPicture: CircleAvatar(
        child: Icon(Icons.person, size: 48),
        // backgroundImage: AssetImage('assets/default_avatar.png'), // Add a default avatar image
      ),
      accountName: Text(
        authService.currentUser?.displayName ?? 'User',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      accountEmail: Text(
        authService.currentUser?.email ?? '',
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.exit_to_app),
            SizedBox(width: 8),
            Text('Logout'),
          ],
        ),
        onPressed: () async {
          await authService.signOut();
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}