import 'dart:ui';

import '../eatable/drawable.dart';

class Body implements Drawable{
  Body? bodyAfore;
  double posX;
  double posY;
  Size cellSize;
  Paint paint = Paint()
    ..color = const Color.fromRGBO(50, 255, 0, 1)
    ..style = PaintingStyle.fill;
  Body({
    Body? bodyAfore,
    required double posX,
    required double posY,
    required Size cellSize,
  }):
        bodyAfore = bodyAfore,
        posX = posX,
        posY = posY,
        cellSize = cellSize;

  void move(){
    posX = bodyAfore!.posX;
    posY = bodyAfore!.posY;
  }

  @override
  void draw({required Canvas canvas}) {
    //canvas.drawCircle(Offset(posX, posY), 15, paint);
    canvas.drawOval(Rect.fromLTWH(posX*cellSize.width, posY*cellSize.height, cellSize.width, cellSize.height), paint);
  }

  void upDate({required int fieldWidth, required int fieldHeight, required Size cellSize}){
    this.cellSize = cellSize;
  }


}