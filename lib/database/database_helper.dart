import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/request.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseHelper._init();

  Future<void> createRequest(Request request) async {
    await _db.collection('requests').doc(request.id).set(request.toMap());
  }

  Future<List<Request>> readAllRequests() async {
    final snapshot = await _db.collection('requests').get();
    return snapshot.docs.map((doc) => Request.fromMap(doc.data())).toList();
  }

  Future<void> updateRequest(Request request) async {
    await _db.collection('requests').doc(request.id).update(request.toMap());
  }

  Future<void> deleteRequest(String id) async {
    await _db.collection('requests').doc(id).delete();
  }

  Future<void> createUser(User user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Future<List<User>> readAllUsers() async {
    final snapshot = await _db.collection('users').get();
    return snapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
  }

  Future<void> updateUser(User user) async {
    await _db.collection('users').doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String id) async {
    await _db.collection('users').doc(id).delete();
  }
}
