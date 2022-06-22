
import 'package:flutter/cupertino.dart';

import '../eatable/drawable.dart';
import 'body.dart';
import 'direction.dart';

class Head extends Body implements Drawable{
  int fieldWidth;
  int fieldHeight;
  Direction looking = Direction.RIGHT;
  Direction lastMove = Direction.RIGHT;
  bool dead = false;

  @override
  Paint paint = Paint()
    ..color = const Color.fromRGBO(15, 80, 0, 1)
    ..style = PaintingStyle.fill;

  Head({
    required int fieldWidth,
    required int fieldHeight,
    required double posX,
    required double posY,
    required Size cellSize}): fieldWidth = fieldWidth, fieldHeight = fieldHeight, super(posX: posX, posY: posY, cellSize: cellSize);


  void moveRight(){
    if( posX + 1 == fieldWidth) {
      posX = 0;
    } else {
      posX++;
    }
  }
  void moveLeft(){
    if( posX == 0 ) {
      posX = fieldWidth - 1;
    } else {
      posX--;
    }
  }

  void moveUp(){
    if( posY == 0) {
      posY = fieldHeight - 1;
    } else {
      posY--;
    }
  }
  void moveDown(){
    if( posY + 1 == fieldHeight) {
      posY = 0;
    } else {
      posY++;
    }
  }

  @override
  void move() {
    switch(looking){
      case Direction.UP:
        moveUp();
        lastMove = Direction.UP;
        break;
      case Direction.DOWN:
        moveDown();
        lastMove = Direction.DOWN;
        break;
      case Direction.LEFT:
        moveLeft();
        lastMove = Direction.LEFT;
        break;
      case Direction.RIGHT:
        moveRight();
        lastMove = Direction.RIGHT;
        break;
    }
  }

  bool gonnaDie(){
    switch(looking){
      case Direction.UP:
        return posY == 0;
      case Direction.DOWN:
        return posY + 1 == fieldHeight;
      case Direction.LEFT:
        return posX == 0;
      case Direction.RIGHT:
        return posX + 1 == fieldWidth;
    }
  }


  @override
  void draw({required Canvas canvas}) {
    canvas.drawOval(Rect.fromLTWH(posX*cellSize.width, posY*cellSize.height, cellSize.width, cellSize.height), paint);
  }

  void upDate({required int fieldWidth, required int fieldHeight, required Size cellSize}){
    this.fieldWidth = fieldWidth;
    this.fieldHeight = fieldHeight;
    this.cellSize = cellSize;
  }

}