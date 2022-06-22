
import 'dart:ui';

import 'body.dart';
import 'direction.dart';
import 'head.dart';

class Snake{
  int fieldWidth;
  int fieldHeight;
  late Head head;
  List<Body> _snake = List<Body>.empty(growable: true);
  bool edge = false;
  int length = 3;
  Size cellSize;
  Snake({
    required int fieldWidth,
    required int fieldHeight,
    required Size cellSize
  }): fieldWidth = fieldWidth, fieldHeight = fieldHeight, cellSize = cellSize{
    head = Head(fieldWidth: fieldWidth, fieldHeight: fieldHeight, posX: 3, posY: 1, cellSize: cellSize);
    _snake.add(head);
    _snake.add( Body(bodyAfore: _snake[0], posX: 2, posY: 1, cellSize: cellSize));
    for(int i = 2; i < length; i++ ){
      _snake.add(Body(bodyAfore: _snake[i-1], posX: _snake[i-1].posX-1 , posY: _snake[i-1].posY, cellSize: cellSize));
    }
  }

  void incrementSize(){
    _snake.add(Body(bodyAfore: _snake[length-1], posX: _snake[length-1].posX, posY: _snake[length-1].posY, cellSize: cellSize));
    length++;
  }

  void lookRight(){
    if(head.lastMove != Direction.LEFT){
      head.looking = Direction.RIGHT;
    }
  }
  void lookLeft(){
    if(head.lastMove != Direction.RIGHT){
      head.looking = Direction.LEFT;
    }
  }
  void lookUp(){
    if(head.lastMove != Direction.DOWN){
      head.looking = Direction.UP;
    }
  }
  void lookDown(){
    if(head.lastMove != Direction.UP){
      head.looking = Direction.DOWN;
    }
  }


  void move(){
    if(edge) {
      if (!head.gonnaDie() && !head.dead) {
        for (int i = _snake.length - 1; i >= 0; i-- ) {
          _snake[i].move();
        }
      } else {
        head.dead = true;
      }
    }else if(!head.dead){
      for (int i = _snake.length - 1; i >= 0; i-- ) {
        _snake[i].move();
      }
    }

    for(int i = 1; i < length; i++){
      if(head.posX == _snake[i].posX && head.posY == _snake[i].posY) {
        head.dead = true;
      }
    }
  }



  Body? getBodypart({required int column, required int row}){
    for(Body body in _snake){
      if (body.posX == column && body.posY == row) {
        return body;
      }
    }
    return null;
  }

  void upDate({required int fieldWidth, required int fieldHeight, required Size cellSize}) {
    bool needNewSnake = this.fieldHeight != fieldHeight || this.fieldWidth != fieldWidth || this.cellSize.width != cellSize.width || this.cellSize.height != cellSize.height;
    this.fieldHeight = fieldHeight;
    this.fieldWidth = fieldWidth;
    this.cellSize = cellSize;
    for(Body body in _snake){
      body.upDate(fieldWidth: fieldWidth, fieldHeight: fieldHeight, cellSize: cellSize);
    }
    if(needNewSnake){
      _snake =  List<Body>.empty(growable: true);
      head = Head(fieldWidth: fieldWidth, fieldHeight: fieldHeight, posX: 3, posY: 1, cellSize: cellSize);
      _snake.add(head);
      _snake.add( Body(bodyAfore: _snake[0], posX: 2, posY: 1, cellSize: cellSize));
      for(int i = 2; i < length; i++ ){
        _snake.add(Body(bodyAfore: _snake[i-1], posX: _snake[i-1].posX-1 , posY: _snake[i-1].posY, cellSize: cellSize));
      }
      length = 3;
    }
  }

}