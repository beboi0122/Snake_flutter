import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersnakehazi/authentication/auth_service.dart';
import 'package:provider/provider.dart';

class RegPage extends StatelessWidget{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);
    double height = mq.size.height;
    double width = mq.size.width;
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(width*0.03),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/title.png',
                    width: width*0.8,
                  ),
                  Padding(padding: EdgeInsets.all(0.05*height)),
                  CupertinoTextField(
                    controller: usernameController,
                    placeholder: "Username",
                  ),
                  Padding(padding: EdgeInsets.all(height*0.01)),
                  CupertinoTextField(
                    controller: emailController,
                    placeholder: "Email",
                  ),
                  Padding(padding: EdgeInsets.all(height*0.01)),
                  CupertinoTextField(
                    obscureText: true,
                    controller: passController,
                    placeholder: "Password",
                  ),
                  Padding(padding: EdgeInsets.all(height*0.01)),
                  SizedBox(
                    width: width*0.6,
                    child: CupertinoButton.filled(
                        child: const Text("Register"),
                        onPressed: (){
                          context.read<AuthService>().reg(
                              email: emailController.text.trim(),
                              password: passController.text.trim()
                          ).then((value) async {
                            User? user = FirebaseAuth.instance.currentUser;

                            await FirebaseFirestore.instance.collection("users").doc(user?.uid).set({
                              'uid' : user?.uid,
                              'username' : usernameController.text.trim(),
                              'email' : emailController.text.trim(),
                              'password' : passController.text.trim()
                            });
                            Navigator.pop(context);
                          });
                        }
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(height*0.01)),
                  SizedBox(
                    width: width*0.6,
                    child: CupertinoButton(
                        child: const Text("Cancel"),
                        onPressed: (){
                          Navigator.pop(context);
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}