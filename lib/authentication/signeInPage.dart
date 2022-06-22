
import 'package:flutter/cupertino.dart';
import 'package:fluttersnakehazi/authentication/auth_service.dart';
import 'package:fluttersnakehazi/authentication/regPage.dart';
import 'package:provider/provider.dart';

class SigeneInPage extends StatelessWidget{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

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
                        child: Text("LogIn"),
                        onPressed: (){
                          context.read<AuthService>().singIn(
                              email: emailController.text.trim(),
                              password: passController.text.trim()
                          );
                        }
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(height*0.01)),
                  SizedBox(
                    width: width*0.6,
                    child: CupertinoButton(
                        child: const Text("Registration"),
                        onPressed: (){
                          Navigator.push(
                              context,
                            CupertinoPageRoute(
                                builder: (context) => RegPage()
                            ),
                          );
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