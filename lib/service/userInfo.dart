import 'package:flutter/material.dart';
import 'package:flutter_india/main.dart';
import 'package:flutter_india/service/auth.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter_india/service//database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
  File imageF;
 String  usernameF, hName, place, district, phone, whatsApp, date, emailF;
Map<String, String> infoMap;
class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final formKey = GlobalKey<FormState>();
  final primaryColor = const Color(0xFF75A2EA);
  DatabaseService databaseService = new DatabaseService();
  String finalDate='';


  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      finalDate = DateFormat('yyyy-MM-dd').format(order);
      date=finalDate;
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
        emailF=snapshot.data.email;
        print(emailF);
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
       onSaved: (value) => usernameF=value,
        onChanged: (value) => {
          usernameF = value,},
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
        onChanged: (value) => hName = value,
        onSaved: (value) => usernameF=value,
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
        onChanged: (value) => place = value,
        onSaved: (value) => usernameF=value,
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
        onChanged: (value) => district = value,
        onSaved: (value) => usernameF=value,
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
        onChanged: (value) => phone = value,
        onSaved: (value) => usernameF=value,
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
        onChanged: (value) => whatsApp = value,
        onSaved: (value) => usernameF=value,
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
                      imageQuality: 40,
                      maxHeight: 800,
                      maxWidth: 400,
                      context: context,
                      source: ImgSource.Both,
                      cameraIcon: Icon(
                        Icons.camera,
                        color: Colors.red,
                      ),
                    );
                    setState(() {
                      imageF = image;
                    });
                  }
              ),
            ],));
      textField.add(SizedBox(
        height: 8.0,
      ));
    textField.add(Container(
      child: imageF != null
          ?
      CircleAvatar(backgroundImage: FileImage(imageF), maxRadius: 30,)
          : Container(child: Text("No image"),),
    ));
    textField.add(SizedBox(
      height: 8.0,
    ));
    textField.add(
      ProgressButton(
        defaultWidget: const Text('Confirm'),
        progressWidget: const CircularProgressIndicator(),
        width: 196,
        height: 40,
        onPressed: () async {
          final form = formKey.currentState;
          if (imageF != null) {
            if (form.validate()) {
              StorageReference firebaseStorageRef = FirebaseStorage.instance
                  .ref()
                  .child("blogListImage")
                  .child("${randomAlphaNumeric(9)}.png");
              final StorageUploadTask task = firebaseStorageRef.putFile(
                  imageF);

              var downloadUrl = await (await task.onComplete).ref
                  .getDownloadURL();
              print("this is url $downloadUrl");
              infoMap = {
                "Name": usernameF,
                "House Name": hName,
                "Place": place,
                "District": district,
                "Phone Number": phone,
                "WhatsApp": whatsApp,
                "Date of Birth": date,
                "Image Url": downloadUrl,
              };
              await databaseService.addInfoData(infoMap, emailF).then((value) {

              });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home() ));
            }
          }
        }
      )
      );
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

