import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_india/main.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_india/service/database.dart';


class DateEntry extends StatefulWidget {
  final String id;

  const DateEntry({Key key, this.id}) : super(key: key);
  @override
  _DateEntryState createState() => _DateEntryState();
}

class _DateEntryState extends State<DateEntry> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String name, number, id, date, mark1, mark2, mark3, mark4;
  DatabaseService databaseService = new DatabaseService();
  bool _isLoading = false;

  createQuizOnline() async {
    setState(() {
      _isLoading = true;
    });

    id = randomAlphaNumeric(16);

    Map<String, String> quizMap = {
      "Id": id,
      "Name": name,
      "Number": number,
      "mark1": mark1,
      "Date of Birth": date,
      "mark2": mark2,
      "mark3h": mark3,
      "mark4": mark4,
    };

    await databaseService.addData2(quizMap, widget.id, id).then((value) {
      setState(() {
        _isLoading = false;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification adding page"),
      ),
      key: _scaffoldKey,
      body: _isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height/18,
                ),
                Container(
                  color: Colors.lightBlue,
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    validator: (val) =>
                    val.isEmpty ? "Enter Name" : null,
                    decoration: InputDecoration(
                        hoverColor: Colors.white,
                        hintText: " Name",
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (val) {
                      name = val;
                    },
                  ),),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 67,
                ),
                Container(
                  color: Colors.lightBlue,
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    validator: (val) =>
                    val.isEmpty ? "Enter Number" : null,
                    decoration: InputDecoration(
                        hoverColor: Colors.white,
                        hintText: " Number",
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (val) {
                      number = val;
                    },
                  ),),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 67,
                ),
                Container(
                  color: Colors.lightBlue,
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    validator: (val) =>
                    val.isEmpty ? "Enter Date of Birth" : null,
                    decoration: InputDecoration(
                        hoverColor: Colors.white,
                        hintText: " Date of Birth",
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (val) {
                      date = val;
                    },
                  ),),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 67,
                ),
                Container(
                  color: Colors.lightBlue,
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    validator: (val) =>
                    val.isEmpty ? "Enter Mark 1" : null,
                    decoration: InputDecoration(
                        hoverColor: Colors.white,
                        hintText: " Mark 1",
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (val) {
                      mark1 = val;
                    },
                  ),),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 67,
                ),
                Container(
                  color: Colors.lightBlue,
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    validator: (val) =>
                    val.isEmpty ? "Enter Mark 2" : null,
                    decoration: InputDecoration(
                        hoverColor: Colors.white,
                        hintText: " Mark 2",
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (val) {
                      mark2 = val;
                    },
                  ),),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 67,
                ),
                Container(
                  color: Colors.lightBlue,
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    validator: (val) =>
                    val.isEmpty ? "Enter Mark 3" : null,
                    decoration: InputDecoration(
                        hoverColor: Colors.white,
                        hintText: " Mark 3",
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (val) {
                      mark3 = val;
                    },
                  ),),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 67,
                ),
                Container(
                  color: Colors.lightBlue,
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    validator: (val) =>
                    val.isEmpty ? "Enter Mark 4" : null,
                    decoration: InputDecoration(
                        hoverColor: Colors.white,
                        hintText: " Mark 4",
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (val) {
                      mark4 = val;
                    },
                  ),),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 67,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 17,
                ),
                GestureDetector(
                    onTap: () {
                      createQuizOnline();
                    },
                    child: blueButton(
                        context: context, label: "Submit")),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget blueButton({BuildContext context, String label, buttonWidth}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(30)),
      alignment: Alignment.center,
      width: buttonWidth != null
          ? buttonWidth
          : MediaQuery.of(context).size.width - 48,
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
