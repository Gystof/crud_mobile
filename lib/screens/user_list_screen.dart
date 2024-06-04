import 'package:flutter/material.dart';
import 'package:projectapps/models/user.dart';
import 'package:projectapps/database/database_helper.dart';
import 'profile_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _refreshUsers();
  }

  Future<List<User>> _refreshUsers() async {
    final users = await DatabaseHelper.instance.readAllUsers();
    return users;
  }

  void _deleteUser(String id) async {
    await DatabaseHelper.instance.deleteUser(id);
    setState(() {
      _usersFuture = _refreshUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список пользователей'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newUser = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: null),
                ),
              );
              if (newUser != null) {
                setState(() {
                  _usersFuture = _refreshUsers();
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
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
                  subtitle: Text(user.email),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: user),
                      ),
                    );
                    setState(() {
                      _usersFuture = _refreshUsers();
                    });
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Удалить пользователя'),
                          content: Text('Вы уверены, что хотите удалить этого пользователя?'),
                          actions: [
                            TextButton(
                              child: Text('Отмена'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: Text('Удалить'),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        _deleteUser(user.id);
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}