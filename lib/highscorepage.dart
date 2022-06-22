
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersnakehazi/main.dart';
import 'package:provider/provider.dart';

class HighScorePage extends StatefulWidget {
  const HighScorePage({Key? key}) : super(key: key);

  @override
  State<HighScorePage> createState() => _HighScorePageState();
}

class _HighScorePageState extends State<HighScorePage> {
  List<HighScores> list = List.empty(growable: true);
  @override
  void initState(){
      HighScores.getListOfAll().then((value) {
        setState((){
          list = value!;
          list.sort((e1, e2) {
            if(int.parse(e1.score) > int.parse(e2.score)){
              return -1;
            }
            if(int.parse(e1.score) < int.parse(e2.score)){
              return 1;
            }
            if(int.parse(e1.score) == int.parse(e2.score)){
              return 0;
            }
            return 0;
          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: ListView.builder(
            itemBuilder: (context, index){
              return HighScoreCardBuilder(
                  userName: list[index].username,
                  score: list[index].score,
              );
            },
            itemCount: list.length
        )
      );
  }
}

class HighScores{

  HighScores({required this.username, required this.score});

  String username;
  String score;


  static pushHighScoresData(int score) async{
    var user = await MyUser.getMyUser();

    await FirebaseFirestore.instance.collection("score").doc().set({
      'uid' : user?.uid.trim(),
      'username' : user?.username.trim(),
      'score' : score.toString().trim(),
    });
  }

  static HighScores fromJson(Map<String, dynamic> json) => HighScores(
      username: json['username'],
      score: json['score']
  );

  static Stream<QuerySnapshot> get scores{
    return FirebaseFirestore.instance.collection('score').snapshots();
  }

  static Future<List<HighScores>?> getListOfAll() async{
    await for (QuerySnapshot value in HighScores.scores) {
      List<HighScores> list = List.empty(growable: true);
      for (var score in value.docs) {
        var scoredata = HighScores.fromJson(score.data() as Map<String, dynamic>);
        list.add(scoredata);
      }
      return list;
    }
  }
}

class HighScoreCardBuilder extends StatelessWidget{

  const HighScoreCardBuilder({Key? key, required this.userName, required this.score});

  final String userName;
  final String score;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return SizedBox(
      height: 60,
      child: Card(
        color: Colors.amber,
        child: Row(
          children: [
            SizedBox(
              width: mq.size.width/2-50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: mq.size.width*0.05,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: mq.size.width/2-50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    score.toString(),
                    style: TextStyle(
                      fontSize: mq.size.width*0.05,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
