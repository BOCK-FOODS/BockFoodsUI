import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  static const routeName = '/account';
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          ListTile(leading: Icon(Icons.person), title: Text('Profile')),
          ListTile(leading: Icon(Icons.list), title: Text('Orders')),
          ListTile(leading: Icon(Icons.payment), title: Text('Payments')),
          ListTile(leading: Icon(Icons.help), title: Text('Help & Support')),
        ],
      ),
    );
  }
}
