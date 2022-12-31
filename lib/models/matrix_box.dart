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
    [4, 5],
    [3, 2],
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
    print("${row} ${col} ${squares[row][col][1]}");
    squares[row][col][1] = true;
    print("${row} ${col} ${squares[row]}");
  }
}
