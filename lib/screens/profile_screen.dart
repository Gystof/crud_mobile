import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:projectapps/models/user.dart';
import 'package:projectapps/database/database_helper.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  ProfileScreen({this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = Uuid();

  late String _name;
  late String _email;
  late String _position;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _name = widget.user!.name;
      _email = widget.user!.email;
      _position = widget.user!.position;
    } else {
      _name = '';
      _email = '';
      _position = '';
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newUser = User(
        id: widget.user?.id ?? _uuid.v4(),
        name: _name,
        email: _email,
        position: _position,
      );

      if (widget.user == null) {
        await DatabaseHelper.instance.createUser(newUser);
      } else {
        await DatabaseHelper.instance.updateUser(newUser);
      }

      Navigator.of(context).pop(newUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Создать пользователя' : 'Редактировать пользователя'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Имя'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите имя';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Электронная почта'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите электронную почту';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                initialValue: _position,
                decoration: InputDecoration(labelText: 'Должность'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите должность';
                  }
                  return null;
                },
                onSaved: (value) {
                  _position = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}