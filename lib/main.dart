import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_india/service/auth.dart';
import 'package:flutter_india/service/provider_widget.dart';
import 'package:flutter_india/service/sign_up.dart';
import 'package:flutter_india/service/firs_wiev.dart';
import 'package:flutter_india/service/userInfo.dart';
import 'package:flutter_india/service/database.dart';


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
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  @override
  void initState() {
    databaseService.getQuizData().then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Ligh Drawer Navigation'),
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _key.currentState.openDrawer();
          },
        ),
      ),
      drawer: _buildDrawer(),
      body: Container(),
    );
  }
  _buildDrawer() {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
          child: StreamBuilder(
                stream: quizStream,
                builder: (context, snapshot) {
    return snapshot.data == null
    ? Container()
        : SingleChildScrollView(
    child: Column(
    children: <Widget>[
    Container(
    alignment: Alignment.centerRight,
    child: IconButton(
    icon: Icon(
    Icons.power_settings_new,
    color: active,
    ),
    onPressed: () {
    Navigator.pop(context);
    },
    ),
    ),
    Container(
    height: 90,
    alignment: Alignment.center,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
    colors: [Colors.orange, Colors.deepOrange])),
    child: CircleAvatar(
    radius: 40,
    backgroundImage: imageF!=null ? FileImage(imageF) : NetworkImage("https://www.publicdomainpictures.net/pictures/270000/velka/avatar-people-person-business-.jpg"),
    ),
    ),
    SizedBox(height: 5.0),
    Text(
      "House Name: ${snapshot.data.documents[9].data["House Name"]}",
    style: TextStyle(
    color: Colors.black,
    fontSize: 18.0,
    fontWeight: FontWeight.w600),
    ),
    SizedBox(height: 30.0),
    _buildRow(Icons.home,  "House Name: ${snapshot.data.documents[9].data["House Name"]}"),
    _buildDivider(),
    _buildRow(Icons.place, "Place: ${snapshot.data.documents[9].data["House Name"]}"),
    _buildDivider(),
    _buildRow(Icons.place, "District: ${snapshot.data.documents[9].data["House Name"]}"),
    _buildDivider(),
    _buildRow(Icons.phone_android, "Phone Number: ${snapshot.data.documents[9].data["House Name"]}"),
    _buildDivider(),
    _buildRow(Icons.phone, "WhatsApp: ${snapshot.data.documents[9].data["House Name"]}"),
    _buildDivider(),
    _buildRow(Icons.date_range, "Date of Birth: ${snapshot.data.documents[9].data["House Name"]}"),
    _buildDivider(),
    ],
    ),
    );
    }
          )
        ),
      ),
    ));
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: [
        Icon(
          icon,
          color: active,
        ),
        SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
        Spacer(),
        if (showBadge)
          Material(
            color: Colors.deepOrange,
            elevation: 5.0,
            shadowColor: Colors.red,
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                "10+",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
      ]),
    );
  }
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width-40, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height/2);
    path.quadraticBezierTo(
        size.width, size.height - (size.height / 4), size.width-40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}