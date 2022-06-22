import 'dart:ui';

import 'drawable.dart';

class Apple implements Drawable{
  bool eaten = false;
  late Rect rect;
  static Paint paint = Paint()
    ..color = const Color.fromRGBO(255, 0, 0, 1)
    ..style = PaintingStyle.fill;
  int posX;
  int posY;
  int drawcall = 0;
  Size cellSize;
  Apple({required int posX,
  required int posY,
  required Size cellSize}): posX = posX, posY = posY, cellSize = cellSize{
    rect = Rect.fromLTWH(posX*cellSize.width, posY*cellSize.height, cellSize.width, cellSize.height);
  }

  void newPoint({required int posX, required int posY}){
    this.posX = posX;
    this.posY = posY;
    rect = Rect.fromLTWH(posX*cellSize.width, posY*cellSize.height, cellSize.width, cellSize.height);
  }

  @override
  void draw({required Canvas canvas}) {
    canvas.drawOval(rect, paint);
  }

  void upDate({required Size cellSize}){
    this.cellSize = cellSize;
  }



}