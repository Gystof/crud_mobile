import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectapps/models/request.dart';
import 'package:projectapps/database/database_helper.dart';
import 'package:projectapps/providers/theme_provider.dart';
import 'package:projectapps/screens/user_list_screen.dart';
import 'request_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Request> _requestList = [];
  late Future<List<Request>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = _refreshRequests();
  }

  Future<List<Request>> _refreshRequests() async {
    final requests = await DatabaseHelper.instance.readAllRequests();
    setState(() {
      _requestList = requests;
    });
    return requests;
  }

  void _addRequest(Request request) {
    setState(() {
      _requestList.insert(0, request);
      _listKey.currentState?.insertItem(0);
    });
  }

  void _removeRequest(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить заявку'),
        content: Text('Вы уверены, что хотите удалить эту заявку?'),
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
      final removedRequest = _requestList.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildItem(removedRequest, animation),
      );
      await DatabaseHelper.instance.deleteRequest(removedRequest.id);
    }
  }

  Widget _buildItem(Request request, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          title: Text(
            request.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ФИО: ${request.fullName}'),
              Text('Должность: ${request.position}'),
              Text('Табельный №: ${request.employeeNumber}'),
              Text('Подразделение: ${request.department}'),
              Text(
                  'Период: ${request.startDate.toLocal().toString().split(' ')[0]} - ${request.endDate.toLocal().toString().split(' ')[0]}'),
            ],
          ),
          isThreeLine: true,
          onTap: () async {
            await Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    RequestFormScreen(request: request),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
            _refreshRequests();
          },
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _removeRequest(_requestList.indexOf(request)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('СИБИНТЕК'),
          actions: [
            Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Заявки'),
              Tab(text: 'Пользователи'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<Request>>(
              future: _requestsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Нет заявок'));
                } else {
                  return AnimatedList(
                    key: _listKey,
                    initialItemCount: _requestList.length,
                    itemBuilder: (context, index, animation) {
                      return _buildItem(_requestList[index], animation);
                    },
                  );
                }
              },
            ),
            UserListScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final newRequest = await Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    RequestFormScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
            if (newRequest != null) {
              _addRequest(newRequest);
            }
          },
        ),
      ),
    );
  }
}
