import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersnakehazi/highscorepage.dart';
import 'package:provider/provider.dart';

import 'authentication/auth_service.dart';
import 'authentication/signeInPage.dart';
import 'firebase_options.dart';
import 'game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<AuthService>().authStateChange,
            initialData: null,
          )
        ],
        child: const CupertinoApp(
          debugShowCheckedModeBanner: false,
          home: AuthenticatorWrapper(),
        )
    );
    //return CupertinoApp(home: SigeneInPage());
  }
}

class AuthenticatorWrapper extends StatelessWidget{
  const AuthenticatorWrapper({
    Key? key,
  }): super(key: key);
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if(firebaseUser != null){
      return MainMenuPage();
    }
    return SigeneInPage();
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/title.png',
                    width: width*0.8,
                  ),
                  Padding(padding: EdgeInsets.all(0.05*height)),
                  SizedBox(
                    width: width*0.6,
                    child: CupertinoButton.filled(
                      child: const Text("Star Game"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const Game()
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(0.01*height)),
                  SizedBox(
                    width: 0.6*width,
                    child: CupertinoButton.filled(
                      child: const Text("High Scores"),
                      onPressed: ()  {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const HighScorePage(),
                            ),
                        );
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(0.01*height)),
                  SizedBox(
                    width: 0.6*width,
                    child: CupertinoButton.filled(
                      child: const Text("Sign out"),
                      onPressed: () {
                        context.read<AuthService>().signeOut();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}

class MyUser{
  static MyUser? _myUser = null;
  String uid;
  final String username;
  final String email;
  final String password;

  MyUser({this.uid = '', required this.email, required this.password, required this.username});

  static MyUser fromJson(Map<String, dynamic> json) => MyUser(
      uid: json['uid'],
      email: json['email'],
      password: json['password'],
      username: json['username']
  );

  static Stream<QuerySnapshot> get users{
   return FirebaseFirestore.instance.collection('users').snapshots();
  }

  static Future<MyUser?> getMyUser() async{
    if(_myUser == null) {
      await for (QuerySnapshot value in MyUser.users) {
        for (var user in value.docs) {
          var userdata = MyUser.fromJson(user.data() as Map<String, dynamic>);
          User? LogedInUser = await FirebaseAuth.instance.currentUser;
          if (userdata.uid == LogedInUser?.uid.toString()) {
            _myUser = userdata;
            return _myUser;
          }
        }
      }
    }else{
      return _myUser;
    }
  }

}