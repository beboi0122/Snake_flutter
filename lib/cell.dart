
import 'dart:ui';

import 'eatable/apple.dart';
import 'eatable/drawable.dart';

class Cell{
  Canvas canvas;
  Paint paint;
  int posX;
  int posY;
  Size size;
  Cell({
    required Canvas canvas,
    required Paint paint,
    required int posX,
    required int posY,
    required Size size}):
        canvas = canvas,
        paint = paint,
        posX = posX,
        posY =posY,
        size = size;

  void draw({required Drawable? drawable}){
    canvas.drawRect(Offset(posX * size.width, posY * size.height) & size, paint);
    if(drawable != null){
      if(drawable is Apple){
      }
      drawable.draw(canvas: canvas);
    }

  }

}