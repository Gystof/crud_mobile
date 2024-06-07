import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectapps/providers/auth_provider.dart';
import 'package:projectapps/providers/theme_provider.dart';
import 'package:projectapps/models/user.dart';
import 'package:projectapps/database/database_helper.dart';
import 'package:projectapps/screens/profile_screen.dart';
import 'package:projectapps/screens/user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Пользователи'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<User>>(
        stream: DatabaseHelper.instance.watchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Нет пользователей'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.position),
                  trailing: authProvider.isAdmin
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteUser(user.id),
                        )
                      : null,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => UserDetailScreen(user: user)),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: authProvider.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  void _deleteUser(String id) async {
    await DatabaseHelper.instance.deleteUser(id);
  }
}
