import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_india/service/auth.dart';
import 'package:flutter_india/service/provider_widget.dart';
import 'package:flutter_india/service/sign_up.dart';
import 'package:flutter_india/service/firs_wiev.dart';
import 'package:flutter_india/service/userInfo.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeController(),
          '/signUp': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signIn),
          '/anonymouslySignIn': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.anonymous),
          '/convertUser': (BuildContext context) => SignUpView(
                authFormType: AuthFormType.convert,
              ),
          '/userInfo' : (BuildContext context) => UserInfo()
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    final indicator = (context, AsyncSnapshot<String> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        final bool signedIn = snapshot.hasData;
        return signedIn ? Home()  : FirstWiev();
      }
      return CircularProgressIndicator();
    };
    return StreamBuilder<String>(
        stream: auth.onAuthStateChanged, builder: indicator);
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () async {
              try {
                AuthService auth = Provider.of(context).auth;
                await auth.signOut();
                Navigator.of(context).pushReplacementNamed('/home');
                print("Signed Out");
              } catch (e) {
                print('Eror: $e');
              }
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}

