import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class FirebaseFirestoreRepository {
  final _fi = FirebaseFirestore.instance;
  final userCollection = "Users";

  Future<List<UserModel>> getAllUsers() async {
    return await _fi.collection(userCollection).get().then((value) {
      return value.docs.map((e) {
        final data = e.data();
        data.putIfAbsent('fId', () => e.id);
        return UserModel.fromDatabase(data);
      }).toList();
    });
  }

  Stream<List<UserModel>> getAllUsersAsStream() {
    return _fi.collection(userCollection).snapshots().map((value) {
      return value.docs.map((e) {
        final data = e.data();
        data.putIfAbsent('fId', () => e.id);
        return UserModel.fromDatabase(data);
      }).toList();
    });
  }

  Future<UserModel?> getUserDetails(String id) async {
    final queryResult = await _fi.collection(userCollection).doc(id).get().then((value) {
      final data = value.data();
      if (data != null) {
        data.putIfAbsent('fId', () => value.id);
        return UserModel.fromDatabase(data);
      } else {
        return null;
      }
    });
    return queryResult;
  }

  Stream<UserModel?> getUserDetailsInStream(String id) {
    final queryResult = _fi.collection(userCollection).doc(id).snapshots().map((value) {
      final data = value.data();
      if (data != null) {
        data.putIfAbsent('fId', () => value.id);
        return UserModel.fromDatabase(data);
      } else {
        return null;
      }
    });
    return queryResult;
  }

  Future<void> storeUser(UserModel userModel) async {
    return await _fi.collection(userCollection).doc(userModel.id).set(userModel.toDatabase());
  }

  Future<void> updateUser(UserModel userModel, {String? id}) async {
    return await _fi.collection(userCollection).doc(id).update(userModel.toDatabase());
  }

  Future<void> deleteUser({String? id}) async {
    return await _fi.collection(userCollection).doc(id).delete();
  }
}
