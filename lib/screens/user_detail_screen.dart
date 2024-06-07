import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectapps/models/user.dart';
import 'package:projectapps/providers/auth_provider.dart';
import 'package:projectapps/screens/profile_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  UserDetailScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали пользователя'),
        actions: [
          if (authProvider.isAdmin)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: user)),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Имя:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(user.name),
            SizedBox(height: 16),
            Text(
              'Электронная почта:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(user.email),
            SizedBox(height: 16),
            Text(
              'Должность:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(user.position),
          ],
        ),
      ),
    );
  }
}
