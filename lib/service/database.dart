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

  Future<void> addMarkData(Map quizData, String id) async {
    await Firestore.instance
        .collection("Mark")
        .document(id)
        .setData(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addData2(Map quizData, String id, String id2) async {
    await Firestore.instance
        .collection("Mark")
        .document(id)
         .collection("Data")
        .document(id2)
        .setData(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getData() async {
    return  Firestore.instance.collection("Mark").snapshots();
  }

  getData2() async {
    return  Firestore.instance.collection("Mark").snapshots();
  }
}
