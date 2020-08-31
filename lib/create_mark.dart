import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_india/main.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_india/service/database.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';


class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String title, description, id;
  DatabaseService databaseService = new DatabaseService();
  bool _isLoading = false;

  final TextEditingController _controller =
  TextEditingController(text: '');

  createQuizOnline() async {
    description=_controller.text;
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      id = randomAlphaNumeric(16);

      Map<String, String> quizMap = {
        "Id": id,
        "Title": title,
        "Description": description
      };

      await databaseService.addMarkData(quizMap, id).then((value) {
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
                              val.isEmpty ? "Enter Notification Title" : null,
                          decoration: InputDecoration(
                              hoverColor: Colors.white,
                              hintText: " Title",
                              hintStyle: TextStyle(color: Colors.white)),
                          onChanged: (val) {
                            title = val;
                          },
                        ),),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 17,
                        ),
                       Container(
                         color: Colors.lightBlue,
                         child:AutoSizeTextField(
                           decoration: InputDecoration(
                               hoverColor: Colors.white,
                               hintText: " Description",
                               hintStyle: TextStyle(color: Colors.white)),
                          controller: _controller,
                          style: TextStyle(fontSize: 20),
                          maxLines: 10,
                        ),),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 7,
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
