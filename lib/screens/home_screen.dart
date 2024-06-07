import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectapps/providers/auth_provider.dart';
import 'package:projectapps/providers/theme_provider.dart';
import 'package:projectapps/screens/request_form_screen.dart';
import 'package:projectapps/screens/request_detail_screen.dart';
import 'package:projectapps/screens/user_list_screen.dart';
import 'package:projectapps/models/request.dart';
import 'package:projectapps/database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('СИБИНТЕК'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pushReplacementNamed('/auth');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Request>>(
              stream: DatabaseHelper.instance.watchAllRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Нет заявок'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final request = snapshot.data![index];
                      return ListTile(
                        title: Text(request.title),
                        subtitle: Text(request.fullName),
                        trailing: authProvider.isAdmin
                            ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteRequest(request.id),
                        )
                            : null,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RequestDetailScreen(request: request),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RequestFormScreen()),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Заявки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Пользователи',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => UserListScreen()),
            );
          }
        },
      ),
    );
  }

  void _deleteRequest(String id) async {
    await DatabaseHelper.instance.deleteRequest(id);
  }
}