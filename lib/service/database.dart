import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addInfoData(Map quizData, String _email) async {
    await Firestore.instance
        .collection("User")
        .document(_email)
        .setData(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addMarkData(Map quizData, String quizId) async {
    await Firestore.instance
        .collection("Mark")
        .document(quizId)
        .setData(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addData(blogData) async {
    Firestore.instance.collection("blogs").add(blogData).catchError((e) {
      print(e);
    });
  }

  getData() async {
    return  Firestore.instance.collection("Mark").snapshots();
  }
}
