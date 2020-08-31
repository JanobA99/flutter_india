import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_india/service/database.dart';
import 'package:flutter_india/DateEntry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DateScreen extends StatefulWidget {
  final String id;

  const DateScreen({Key key, this.id,}) : super(key: key);
  @override
  _DateScreenState createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  final firestoreInstance = Firestore.instance;

  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();
  String  name, number, dob, mark1, mark2, mark3, mark4;
  @override
  void initState() {
    firestoreInstance
        .collection("Mark")
        .document(widget.id)
        .collection("Data")
        .getDocuments()
        .then((querySnapshot) {
    querySnapshot.documents.forEach((result) {
      name=result.data["mark2"];
      number=result.data["mark2"];
      dob=result.data["mark2"];
      mark1=result.data["mark2"];
      mark2=result.data["mark2"];
      mark3=result.data["mark2"];
      mark4=result.data["mark2"];
    });});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: StreamBuilder(
          stream: quizStream,
          builder: (context, snapshot) {
            return snapshot.data == null
                ? Container()
                : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Tile(
                    description: name,
                    title: number,
                    quizId: dob,
                  );
                });
          },
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final String title;
  final String description;
  final String quizId;
  Tile(
      {@required this.title,
        @required this.description,
        @required this.quizId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DateEntry(id: quizId,),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8, top: 8),
        height: 150,
        child: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.blue),
                alignment: Alignment.center,
                child: SingleChildScrollView(child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                )
            )
          ],
        ),
      ),
    );
  }
}

