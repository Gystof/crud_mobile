import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:projectapps/models/request.dart';
import 'package:projectapps/models/user.dart';
import 'package:projectapps/database/database_helper.dart';

class RequestFormScreen extends StatefulWidget {
  final Request? request;

  RequestFormScreen({this.request});

  @override
  _RequestFormScreenState createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = Uuid();

  late String _title;
  late String _fullName;
  late String _position;
  late String _employeeNumber;
  late String _department;
  late DateTime _startDate;
  late DateTime _endDate;
  late Future<List<User>> _usersFuture;
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    _usersFuture = DatabaseHelper.instance.readAllUsers();
    if (widget.request != null) {
      _title = widget.request!.title;
      _fullName = widget.request!.fullName;
      _position = widget.request!.position;
      _employeeNumber = widget.request!.employeeNumber;
      _department = widget.request!.department;
      _startDate = widget.request!.startDate;
      _endDate = widget.request!.endDate;
    } else {
      _title = '';
      _fullName = '';
      _position = '';
      _employeeNumber = '';
      _department = '';
      _startDate = DateTime.now();
      _endDate = DateTime.now();
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newRequest = Request(
        id: widget.request?.id ?? _uuid.v4(),
        title: _title,
        fullName: _fullName,
        position: _position,
        employeeNumber: _employeeNumber,
        department: _department,
        startDate: _startDate,
        endDate: _endDate,
      );

      if (widget.request == null) {
        await DatabaseHelper.instance.createRequest(newRequest);
      } else {
        await DatabaseHelper.instance.updateRequest(newRequest);
      }

      Navigator.of(context).pop(newRequest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.request == null ? 'Создать заявку' : 'Редактировать заявку'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Название заявки'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название заявки';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              FutureBuilder<List<User>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Нет пользователей'));
                  } else {
                    return DropdownButtonFormField<User>(
                      decoration:
                          InputDecoration(labelText: 'Выберите пользователя'),
                      items: snapshot.data!.map((user) {
                        return DropdownMenuItem<User>(
                          value: user,
                          child: Text(user.name),
                        );
                      }).toList(),
                      onChanged: (user) {
                        setState(() {
                          _selectedUser = user;
                          _fullName = user!.name;
                          _position = user.position;
                          _employeeNumber = user.id;
                          _department = user.position;
                        });
                      },
                      value: _selectedUser,
                    );
                  }
                },
              ),
              if (_selectedUser == null)
                TextFormField(
                  initialValue: _fullName,
                  decoration: InputDecoration(labelText: 'ФИО'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите ФИО';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _fullName = value!;
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
              TextFormField(
                initialValue: _employeeNumber,
                decoration: InputDecoration(labelText: 'Табельный №'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите табельный номер';
                  }
                  return null;
                },
                onSaved: (value) {
                  _employeeNumber = value!;
                },
              ),
              TextFormField(
                initialValue: _department,
                decoration:
                    InputDecoration(labelText: 'Наименование подразделения'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите наименование подразделения';
                  }
                  return null;
                },
                onSaved: (value) {
                  _department = value!;
                },
              ),
              ListTile(
                title:
                    Text("Дата начала: ${_startDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title:
                    Text("Дата окончания: ${_endDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
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
