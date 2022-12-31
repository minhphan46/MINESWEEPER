import 'package:flutter/material.dart';

class MatrixBox {
  // variables
  int numOfEachRow = 9;
  late int numOfSquares;
  List squares = []; // list of squares

  List get Squares => squares;
  List get BombLocations => bombLocations;
  final List<List<int>> bombLocations = [
    [0, 1],
    [3, 2],
    [4, 5],
    [4, 6],
  ];

  MatrixBox({required this.numOfEachRow}) {
    numOfSquares = numOfEachRow * numOfEachRow;
    squares = List.generate(
      numOfEachRow,
      (i) => List.generate(
        numOfEachRow,
        (j) => [0, false],
        growable: false,
      ),
      growable: false,
    );
  }

  void initSquare() {
    squares = List.generate(
      numOfEachRow,
      (i) => List.generate(
        numOfEachRow,
        (j) => [0, false],
        growable: false,
      ),
      growable: false,
    );
  }

  void display() {
    for (int i = 0; i < numOfEachRow; i++) {
      for (int j = 0; j < numOfEachRow; j++) {
        squares[i][j] = [0, false];
        print("moi o: ${squares[i][j][0]}");
      }
    }
  }

  bool isBomb(int row, int col) {
    bool check = false;
    bombLocations.forEach((eachRow) {
      if (eachRow[0] == row && eachRow[1] == col) check = true;
    });
    return check;
  }

  void revealBoxNumbers(int row, int col) {
    squares[row][col][1] = true;
  }

  void scanBombs() {
    for (int row = 0; row < numOfEachRow; row++) {
      for (int col = 0; col < numOfEachRow; col++) {
        // get number of the bombs around
        int numberOfBombsAround = 0;

        // check 8 surrounding boxes to check
        // check left, unless first row
        if (isBomb(row, col - 1) && col - 1 != 0) numberOfBombsAround++;
        // check top left, unless first col and first row
        if (isBomb(row - 1, col - 1) && col - 1 != 0 && row - 1 != 0)
          numberOfBombsAround++;
        // check top, unless first row
        if (isBomb(row - 1, col) && row - 1 != 0) numberOfBombsAround++;
        // check top right, unless first col and last row
        if (isBomb(row - 1, col + 1) && row - 1 != 0 && col + 1 != numOfEachRow)
          numberOfBombsAround++;
        // check right, unless last row
        if (isBomb(row, col + 1) && col + 1 != numOfEachRow)
          numberOfBombsAround++;
        // check bottom right, unless last col and last row
        if (isBomb(row + 1, col + 1) &&
            row + 1 != numOfEachRow &&
            col + 1 != numOfEachRow) numberOfBombsAround++;
        // check bottom, unless last row
        if (isBomb(row + 1, col) && row - 1 != numOfEachRow)
          numberOfBombsAround++;
        // check bottom left, unless first col and last row
        if (isBomb(row + 1, col - 1) && row + 1 != numOfEachRow && col - 1 != 0)
          numberOfBombsAround++;

        squares[row][col][0] = numberOfBombsAround;
      }
    }
  }
}
