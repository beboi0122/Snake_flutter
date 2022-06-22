

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersnakehazi/highscorepage.dart';

import 'field.dart';

class Game extends StatefulWidget{
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

Field? field = null;



class _GameState extends State<Game>{
  final _repaint = ValueNotifier<int>(0);
  late MyPaint paint;
  late int score = 30;
  late Timer gameTimer;

  @override
  void initState(){
    field = null;
    paint = MyPaint(repaint: _repaint);
    gameTimer = Timer.periodic(Duration(milliseconds: 250), (timer) async {
      if(field != null){
        if(field!.snake.head.dead){
          timer.cancel();
          Navigator.pop(context);
          HighScores.pushHighScoresData(score);
        }
      }
      if(score != field!.snake.length){
        setState((){
          score = field!.snake.length*10;
        });
      }
      _repaint.value++;
    });

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size.width > mq.size.height ? mq.size.height : mq.size.width;
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      color: Colors.amber,
      home: CupertinoPageScaffold(
        child: SafeArea(
            child:  RawKeyboardListener(
              autofocus: true,
              focusNode: FocusNode(),
              onKey: (event){
                if(event.isKeyPressed(LogicalKeyboardKey.keyW) || event.isKeyPressed(LogicalKeyboardKey.arrowUp)){
                  field?.snake.lookUp();
                }
                if(event.isKeyPressed(LogicalKeyboardKey.keyS) || event.isKeyPressed(LogicalKeyboardKey.arrowDown)){
                  field?.snake.lookDown();
                }
                if(event.isKeyPressed(LogicalKeyboardKey.keyA) || event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
                  field?.snake.lookLeft();
                }
                if(event.isKeyPressed(LogicalKeyboardKey.keyD) || event.isKeyPressed(LogicalKeyboardKey.arrowRight)){
                  field?.snake.lookRight();
                }
              },
              child: GestureDetector(
                onHorizontalDragUpdate: (deat){
                  if(deat.delta.dx > 0){
                    field?.snake.lookRight();
                  }
                  if(deat.delta.dx < 0){
                    field?.snake.lookLeft();
                  }
                },
                onVerticalDragUpdate: (deat){
                  if(deat.delta.dy > 0){
                    field?.snake.lookDown();
                  }
                  if(deat.delta.dy < 0){
                    field?.snake.lookUp();
                  }
                },
                child: Column(
                  children:[
                    Container(
                      color: Colors.white,
                      width: mq.size.width,
                      height: mq.size.height*0.06,
                      child:
                        Row(
                          children:  [
                            Container(
                              height: mq.size.height/2,
                              width: mq.size.width/2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                Text(
                                  "Press Q to quit to Main menu",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                        ]
                              ),
                            ),
                            Container(
                              height: mq.size.height/2,
                              width: mq.size.width/2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Text(
                                    "Score: $score",
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ]),
                            ),
                        ]),
                    ),
                    Container(
                    width: mq.size.width,
                    height: mq.size.height*0.91,
                    child: CustomPaint(
                              size: mq.size,
                              painter: paint,
                            ),
                  ),
                ]),
              ),
            )
            )
        ),
    );
  }

  @override
  void dispose(){
    gameTimer.cancel();
    HighScores.pushHighScoresData(score);
    super.dispose();
  }

}



class MyPaint extends CustomPainter{
  MyPaint({required Listenable repaint}): super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color.fromRGBO(255, 153, 0, 1)
      ..style = PaintingStyle.fill;
    var paint2 = Paint()
      ..color = const Color.fromRGBO(255, 225, 170, 1)
      ..style = PaintingStyle.fill;

    int columnNumber = size.width ~/ 30;
    int rowNumber = size.height ~/ 30;
    Size cellSize = Size(size.width/columnNumber, size.height/rowNumber);

    fieldMaker(
        canvas: canvas,
        paint1: paint1,
        paint2: paint2,
        columnNumber: columnNumber,
        rowNumber: rowNumber,
        cellSize: cellSize
    );

    field?.draw();

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void fieldMaker({
  required Canvas canvas,
  required Paint paint1,
  required Paint paint2,
  required int columnNumber,
  required int rowNumber,
  required Size cellSize
}){
  if(field == null) {
    field = Field(
        canvas: canvas,
        paint1: paint1,
        paint2: paint2,
        columnNumber: columnNumber,
        rowNumber: rowNumber,
        cellSize: cellSize
    );
  }else{
    field?.update(
        canvas: canvas,
        paint1: paint1,
        paint2: paint2,
        columnNumber: columnNumber,
        rowNumber: rowNumber,
        cellSize: cellSize
    );

  }
}