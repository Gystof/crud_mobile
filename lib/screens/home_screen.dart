import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectapps/models/request.dart';
import 'package:projectapps/database/database_helper.dart';
import 'package:projectapps/providers/theme_provider.dart';
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

  void _removeRequest(int index) {
    setState(() {
      final removedRequest = _requestList.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
            (context, animation) => _buildItem(removedRequest, animation),
      );
    });
  }

  Widget _buildItem(Request request, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title: Text(request.title),
        subtitle: Text('${request.fullName}\n${request.startDate.toLocal().toString().split(' ')[0]} - ${request.endDate.toLocal().toString().split(' ')[0]}'),
        isThreeLine: true,
        onTap: () async {
          await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => RequestFormScreen(request: request),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
          onPressed: () async {
            await DatabaseHelper.instance.deleteRequest(request.id);
            _removeRequest(_requestList.indexOf(request));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Заявки'),
        actions: [
          Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Request>>(
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newRequest = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => RequestFormScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
    );
  }
}