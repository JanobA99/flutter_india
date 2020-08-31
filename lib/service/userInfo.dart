import 'package:flutter/material.dart';
import 'package:flutter_india/service/auth.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter_india/service//database.dart';
import 'package:firebase_auth/firebase_auth.dart';



class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final formKey = GlobalKey<FormState>();
  String  _username, _hName, _place, _district, _phone, _whatsApp, _date, _email;
  final primaryColor = const Color(0xFF75A2EA);
  DatabaseService databaseService = new DatabaseService();
  File _image;
  String finalDate='';


  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      finalDate = DateFormat('yyyy-MM-dd').format(order);
      _date=finalDate;
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2130),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return  Scaffold(
      body: Container(
        color: primaryColor,
        height: _height,
        width: _width,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: buildInPuts(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  List<Widget> buildInPuts() {
    List<Widget> textField = [];
textField.add(Center(
  child: FutureBuilder(
    future: FirebaseAuth.instance.currentUser(),
    builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
      if (snapshot.hasData) {
        _email=snapshot.data.email;
        print(_email);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Email: ${snapshot.data.email}', style: TextStyle(color: Colors.white),),
          ],
        );
      }
      else {
        return Text('title31');
      }
    },
  ),
),);
    textField.add(SizedBox(
      height: 8.0,
    ));
    //if were the sign up state and name
        textField.add(TextFormField(
        validator: NameValidator.validate,
        style: TextStyle(
          fontSize: 22.0,
        ),
        decoration: buildSignUpInputDecoration("Name"),
        onChanged: (value) => {_username = value,},
      ));
      textField.add(SizedBox(
        height: 8.0,
      ));
      textField.add(TextFormField(
        validator: NameValidator.validate,
        style: TextStyle(
          fontSize: 22.0,
        ),
        decoration: buildSignUpInputDecoration("House Name"),
        onChanged: (value) => _hName = value,
      ));
      textField.add(SizedBox(
        height: 8.0,
      ));
      textField.add(TextFormField(
        validator: NameValidator.validate,
        style: TextStyle(
          fontSize: 22.0,
        ),
        decoration: buildSignUpInputDecoration("Place"),
        onChanged: (value) => _place = value,
      ));
      textField.add(SizedBox(
        height: 8.0,
      ));
      textField.add(TextFormField(
        validator: NameValidator.validate,
        style: TextStyle(
          fontSize: 22.0,
        ),
        decoration: buildSignUpInputDecoration("District"),
        onChanged: (value) => _district = value,
      ));
      textField.add(SizedBox(
        height: 8.0,
      ));
      textField.add(TextFormField(
        validator: NameValidator.validate,
        style: TextStyle(
          fontSize: 22.0,
        ),
        decoration: buildSignUpInputDecoration("Phone Number"),
        onChanged: (value) => _phone = value,
      ));
      textField.add(SizedBox(
        height: 8.0,
      ));
      textField.add(TextFormField(
        validator: NameValidator.validate,
        style: TextStyle(
          fontSize: 22.0,
        ),
        decoration: buildSignUpInputDecoration("Whatsapp No"),
        onChanged: (value) => _whatsApp = value,
      ));
      textField.add(SizedBox(
        height: 8.0,
      ));
      textField.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                onPressed: callDatePicker,
                color: Colors.white,
                child:
                new Text(
                    'Date of Birth', style: TextStyle(color: Colors.black)),
              ),
              Text(finalDate),
              RaisedButton(
                  color: Colors.white,
                  child: Text('Upload Image'),
                  onPressed: () async {
                    var image = await ImagePickerGC.pickImage(
                      imageQuality: 70,
                      maxHeight: 1280,
                      maxWidth: 866,
                      context: context,
                      source: ImgSource.Both,
                      cameraIcon: Icon(
                        Icons.camera,
                        color: Colors.red,
                      ),
                    );
                    setState(() {
                      _image = image;
                    });
                  }
              ),
            ],));
      textField.add(SizedBox(
        height: 8.0,
      ));
    textField.add(Container(
      child: _image != null
          ?
      CircleAvatar(backgroundImage: FileImage(_image), maxRadius: 30,)
          : Container(),
    ));
    textField.add(SizedBox(
      height: 8.0,
    ));
    textField.add(RaisedButton(
      child: Text("Confirm"),
      onPressed: ()  async {
        print(_username);
        print(_phone);
        print(_email);
        final form = formKey.currentState;
        if (form.validate())  {
          Map<String, String> infoMap = {
            "Name": _username,
            "House Name" : _hName,
            "Place": _place,
            "District": _district,
            "Phone Number": _phone,
            "WhatsApp": _whatsApp,
            "Date of Birth": _date,
          };
          await databaseService.addInfoData(infoMap, _email);
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
    ));
    // add email & password
    return textField;
  }

InputDecoration buildSignUpInputDecoration(String hint) {
  return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
      const EdgeInsets.only(left: 14.0, bottom: 1.0, top: 1.0));
}
}

