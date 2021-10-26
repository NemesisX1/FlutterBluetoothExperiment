import 'package:Bustooth/models/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Collection {
  static const String users = "users";
}

class FirestoreService {
  Future<QuerySnapshot> getCollection(String collection) async =>
      await FirebaseFirestore.instance.collection(collection).get();

  Stream<QuerySnapshot> getCollectionAsStream(String collection) =>
      FirebaseFirestore.instance.collection(collection).get().asStream();

  addModelToCollection(BaseModel model, String collection, {String? id}) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .set(model.toJson())
        .catchError((e) {
      print("$e");
    });
  }
}
