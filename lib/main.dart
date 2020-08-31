import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_india/service/auth.dart';
import 'package:flutter_india/service/provider_widget.dart';
import 'package:flutter_india/service/sign_up.dart';
import 'package:flutter_india/service/firs_wiev.dart';
import 'package:flutter_india/service/userInfo.dart';
import 'package:flutter_india/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_india/DataScreen.dart';
import 'create_mark.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          '/userInfo' : (BuildContext context) => UserInformation()
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
    databaseService.getData().then((val) {
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
  final firestoreInstance = Firestore.instance;

  String  usernameF, hName, place, district, phone, whatsApp, date, imageUrl;
  void _onPressed() async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    firestoreInstance.collection("User").document(firebaseUser.email).get().then((value){
      setState(() {
     place = value.data["Place"];
     usernameF = value.data["Name"];
     hName = value.data["House Name"];
     district = value.data["District"];
     phone = value.data["Phone Number"];
     whatsApp = value.data["WhatsApp"];
     date = value.data["Date of Birth"];
     imageUrl = value.data["Image Url"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Notification'),
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
            _onPressed();
            _key.currentState.openDrawer();
          },
        ),
      ),
      drawer: _buildDrawer(),
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
                      description: snapshot
                          .data.documents[index].data["Description"],
                      title: snapshot.data.documents[index].data["Title"],
                      quizId: snapshot.data.documents[index].data["Id"],
                    );
                  });
            },
          ),
        ),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.add),
       onPressed: () {
         Navigator.push(context, MaterialPageRoute(
           builder: (context) => CreateQuiz(),
         ));
       },
     ),
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
          child: SingleChildScrollView(
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
                    backgroundImage: imageUrl!=null ? NetworkImage(imageUrl) : NetworkImage("https://www.publicdomainpictures.net/pictures/270000/velka/avatar-people-person-business-.jpg"),
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  "$usernameF",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 30.0),
                _buildRow(Icons.home,  "House Name: $hName",),
                _buildDivider(),
                _buildRow(Icons.place, "Place: $place",),
                _buildDivider(),
                _buildRow(Icons.place, "District: $district",),
                _buildDivider(),
                _buildRow(Icons.phone_android, "Phone: $phone",),
                _buildDivider(),
                _buildRow(Icons.phone, "WhatsApp: $whatsApp",),
                _buildDivider(),
                _buildRow(Icons.date_range, "Date of Birth: $date"),
                _buildDivider(),
              ],
            ),
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
      child: SingleChildScrollView( child: Row(children: [
        Icon(
          icon,
          color: active,
        ),
        SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
      ]),
      )
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
              builder: (context) => DateScreen(id: quizId),
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
