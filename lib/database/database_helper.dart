import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectapps/models/request.dart';
import 'package:projectapps/models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Request>> watchAllRequests() {
    return _db.collection('requests').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Request.fromJson(doc.data())).toList());
  }

  Future<void> createRequest(Request request) async {
    await _db.collection('requests').doc(request.id).set(request.toJson());
  }

  Future<void> updateRequest(Request request) async {
    await _db.collection('requests').doc(request.id).update(request.toJson());
  }

  Future<void> deleteRequest(String id) async {
    await _db.collection('requests').doc(id).delete();
  }

  Stream<List<User>> watchAllUsers() {
    return _db.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
  }

  Future<void> createUser(User user) async {
    await _db.collection('users').doc(user.id).set(user.toJson());
  }

  Future<void> updateUser(User user) async {
    await _db.collection('users').doc(user.id).update(user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _db.collection('users').doc(id).delete();
  }

  Future<List<User>> readAllUsers() async {
    final snapshot = await _db.collection('users').get();
    return snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
  }
}
