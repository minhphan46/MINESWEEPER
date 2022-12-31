import 'dart:math';

import 'package:flutter/material.dart';

class MatrixBox {
  // variables
  int numOfRow = 9;
  int numOfCol = 9;
  late int numOfSquares;
  int numberOfBoms = 6;
  // [number of bombs around, reverled = true / false]
  List squares = []; // list of squares

  List get Squares => squares;
  List get BombLocations => bombLocations;
  // list location of the bombs
  final List<List<int>> bombLocations = [];
  // revereal the bomb, if click the bomb, this true
  bool bombsRevealed = false;

  MatrixBox(
      {required this.numOfRow,
      required this.numOfCol,
      required this.numberOfBoms}) {
    numOfSquares = numOfRow * numOfCol;
    squares = List.generate(
      numOfRow,
      (i) => List.generate(
        numOfCol,
        (j) => [0, false],
        growable: false,
      ),
      growable: false,
    );
  }

  void initSquare() {
    resetSquares();
  }

  void resetSquares() {
    bombsRevealed = false;
    randomBomb();
    for (int i = 0; i < numOfRow; i++) {
      for (int j = 0; j < numOfCol; j++) {
        squares[i][j] = [0, false];
      }
    }
    scanBombs();
  }

  void randomBomb() {
    bombLocations.clear();
    for (int i = 0; i < numberOfBoms; i++) {
      int row = Random().nextInt(numOfRow);
      int col = Random().nextInt(numOfCol);
      if (!isBomb(row, col)) {
        bombLocations.add([row, col]);
      } else
        i--;
    }
  }

  void display() {
    for (int i = 0; i < numOfRow; i++) {
      for (int j = 0; j < numOfCol; j++) {
        squares[i][j] = [0, false];
        print("moi o: ${squares[i][j][0]}");
      }
    }
  }

  // check this box is the bomb?
  bool isBomb(int row, int col) {
    bool check = false;
    bombLocations.forEach((eachRow) {
      if (eachRow[0] == row && eachRow[1] == col) check = true;
    });
    return check;
  }

  // event when click the box
  void revealBoxNumbers(int row, int col) {
    // reveal current box if it is a number: 1,2,3 ...
    if (squares[row][col][0] != 0) {
      squares[row][col][1] = true;
    }
    // if current box is 0
    else if (squares[row][col][0] == 0) {
      // reveal current box, and the 8 surrounding boxes, unless you're on a wall
      squares[row][col][1] = true;
      // reveal left, unless fist col
      if (col > 0) {
        // if next box isn't revealed yet and it is a 0, then recurse
        if (squares[row][col - 1][1] == false) revealBoxNumbers(row, col - 1);
      }
      // reveal left, unless fist col
      if (col != 0) {
        // if next box isn't revealed yet and it is a 0, then recurse
        if (squares[row][col - 1][1] == false) revealBoxNumbers(row, col - 1);
      }
      // reveal top left, unless first col and first row
      if (col != 0 && row != 0) {
        if (squares[row - 1][col - 1][1] == false)
          revealBoxNumbers(row - 1, col - 1);
      }
      // check top, unless first row
      if (row != 0) {
        if (squares[row - 1][col][1] == false) revealBoxNumbers(row - 1, col);
      }
      // check top right, unless first col and last row
      if (row != 0 && col != numOfCol - 1) {
        if (squares[row - 1][col + 1][1] == false)
          revealBoxNumbers(row - 1, col + 1);
      }
      // check right, unless last row
      if (col != numOfCol - 1) {
        if (squares[row][col + 1][1] == false) revealBoxNumbers(row, col + 1);
      }
      // check bottom right, unless last col and last row
      if (row != numOfRow - 1 && col != numOfCol - 1) {
        if (squares[row + 1][col + 1][1] == false)
          revealBoxNumbers(row + 1, col + 1);
      }
      // check bottom, unless last row
      if (row != numOfRow - 1) {
        if (squares[row + 1][col][1] == false) revealBoxNumbers(row + 1, col);
      }
      // check bottom left, unless first col and last row
      if (col != 0 && row != numOfRow - 1) {
        if (squares[row + 1][col - 1][1] == false)
          revealBoxNumbers(row + 1, col - 1);
      }
    }
  }

  void scanBombs() {
    for (int row = 0; row < numOfRow; row++) {
      for (int col = 0; col < numOfCol; col++) {
        // get number of the bombs around
        int numberOfBombsAround = 0;

        // check 8 surrounding boxes to check
        // check left, unless first col
        if (isBomb(row, col - 1) && col - 1 >= 0) numberOfBombsAround++;
        // check top left, unless first col and first row
        if (isBomb(row - 1, col - 1) && col - 1 >= 0 && row - 1 >= 0)
          numberOfBombsAround++;
        // check top, unless first row
        if (isBomb(row - 1, col) && row - 1 >= 0) numberOfBombsAround++;
        // check top right, unless first col and last row
        if (isBomb(row - 1, col + 1) && row - 1 >= 0 && col + 1 < numOfRow)
          numberOfBombsAround++;
        // check right, unless last row
        if (isBomb(row, col + 1) && col + 1 < numOfCol) numberOfBombsAround++;
        // check bottom right, unless last col and last row
        if (isBomb(row + 1, col + 1) &&
            row + 1 < numOfRow &&
            col + 1 < numOfCol) numberOfBombsAround++;
        // check bottom, unless last row
        if (isBomb(row + 1, col) && row + 1 < numOfRow) numberOfBombsAround++;
        // check bottom left, unless first col and last row
        if (isBomb(row + 1, col - 1) && row + 1 < numOfRow && col - 1 >= 0)
          numberOfBombsAround++;

        squares[row][col][0] = numberOfBombsAround;
      }
    }
  }

  bool checkWinner() {
    // check how many boxes yet to reveal
    int unrevealedBoxes = 0;
    for (int i = 0; i < numOfRow; i++) {
      for (int j = 0; j < numOfCol; j++) {
        if (squares[i][j][1] == false) unrevealedBoxes++;
      }
    }
    if (unrevealedBoxes == bombLocations.length) return true;
    return false;
  }
}
