import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectapps/models/request.dart';
import 'package:projectapps/providers/auth_provider.dart';
import 'package:projectapps/screens/request_form_screen.dart';

class RequestDetailScreen extends StatelessWidget {
  final Request request;

  RequestDetailScreen({required this.request});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали заявки'),
        actions: [
          if (authProvider.isAdmin)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          RequestFormScreen(request: request)),
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
              'Тип заявления:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(request.title),
            SizedBox(height: 16),
            Text(
              'ФИО:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(request.fullName),
            SizedBox(height: 16),
            Text(
              'Должность:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(request.position),
            SizedBox(height: 16),
            Text(
              'Табельный №:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(request.employeeNumber),
            SizedBox(height: 16),
            Text(
              'Наименование подразделения:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(request.department),
            SizedBox(height: 16),
            Text(
              'Дата начала:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(request.startDate.toLocal().toString().split(' ')[0]),
            SizedBox(height: 16),
            Text(
              'Дата окончания:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(request.endDate.toLocal().toString().split(' ')[0]),
          ],
        ),
      ),
    );
  }
}
