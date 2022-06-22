

import 'dart:math';
import 'dart:ui';



import 'package:fluttersnakehazi/snake/snake.dart';

import 'cell.dart';
import 'eatable/apple.dart';

class Field{
  late Snake snake;
  late Apple apple;
  List<List<Cell>> field = List.empty(growable: true);
  Canvas canvas;
  Paint paint1;
  Paint paint2;
  int columnNumber;
  int rowNumber;
  Size cellSize;
  int drawCallNum = 0;
  Field({
    required Canvas canvas,
    required Paint paint1,
    required Paint paint2,
    required int columnNumber,
    required int rowNumber,
    required Size cellSize
  }):
  canvas = canvas,
  paint1 = paint1,
  paint2 = paint2,
  columnNumber = columnNumber,
  rowNumber = rowNumber,
  cellSize = cellSize
  {
    snake = Snake(fieldWidth: columnNumber, fieldHeight: rowNumber, cellSize: cellSize);
    apple = Apple(posX: 0, posY: 0, cellSize: cellSize );
    setPosition();
    for(int column = 0; column < columnNumber; column++){
      field.add(List.empty(growable: true));
      for(int row = 0; row < rowNumber; row++){
        if( (column+row) % 2 == 0 ) {
          field[column].add(Cell(
              canvas: canvas,
              paint: paint1,
              posX: column,
              posY: row,
              size: cellSize
          ));
        } else {
          field[column].add(Cell(
              canvas: canvas,
              paint: paint2,
              posX: column,
              posY: row,
              size: cellSize
          ));
        }
      }
    }
  }

  void draw() {
    drawCallNum++;
    snake.move();
    for (int column = 0; column < columnNumber; column++) {
      for (int row = 0; row < rowNumber; row++) {
        field[column][row]
            .draw(drawable: snake.getBodypart(column: column, row: row));

        if (snake.head.posX == apple.posX && snake.head.posY == apple.posY) {
          setPosition();
          snake.incrementSize();
        }
        // if(column == apple.posX && row == apple.posY) {
        //   field[column][row].draw(drawable: apple);
        // }
      }
    }
    apple.draw(canvas: canvas);
  }

  void update({
    required Canvas canvas,
    required Paint paint1,
    required Paint paint2,
    required int columnNumber,
    required int rowNumber,
    required Size cellSize,
  }) {
    bool changed = this.columnNumber != columnNumber || this.rowNumber != rowNumber || cellSize.height != cellSize.height || cellSize.width != cellSize.width;

    this.canvas = canvas;
    this.paint1 = paint1;
    this.paint2 = paint2;
    this.columnNumber = columnNumber;
    this.rowNumber = rowNumber;
    this.cellSize = cellSize;

    field = List.empty(growable: true);


    for(int column = 0; column < columnNumber; column++){
      field.add(List.empty(growable: true));
      for(int row = 0; row < rowNumber; row++){
        if( (column+row) % 2 == 0 ) {
          field[column].add(Cell(
              canvas: canvas,
              paint: paint1,
              posX: column,
              posY: row,
              size: cellSize
          ));
        } else {
          field[column].add(Cell(
              canvas: canvas,
              paint: paint2,
              posX: column,
              posY: row,
              size: cellSize
          ));
        }
      }
    }
    snake.upDate(fieldWidth: columnNumber, fieldHeight: rowNumber, cellSize: cellSize);

    if(changed){
      setPosition();
    }

    apple.upDate(cellSize: cellSize);


  }

  void setPosition(){
    int xp = Random().nextInt(columnNumber);
    int yp = Random().nextInt(rowNumber);
    while(snake.getBodypart(column: yp, row: xp) != null){
      xp = Random().nextInt(columnNumber);
      yp = Random().nextInt(rowNumber);
    }
    apple.newPoint(posX: xp, posY: yp);

    apple.upDate(cellSize: cellSize);
  }

}