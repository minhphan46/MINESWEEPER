import 'package:flutter/material.dart';
import 'package:minesweeper/models/app_colors.dart';
import 'package:minesweeper/models/matrix_box.dart';
import 'package:minesweeper/widgets/bomb.dart';
import 'package:minesweeper/widgets/number_box_widget.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  // variables
  static int numOfEachRow = 9;
  int numOfSquares = numOfEachRow * numOfEachRow;
  MatrixBox matrix = MatrixBox(numOfEachRow: 10);
  // [number of bombs around, reverled = true / false]
  var squareStatus = [];
  final List<int> bombLocation = [
    4,
    5,
    40,
    61,
  ];
  bool bombsRevealed = false;
  @override
  void initState() {
    // initially, each square has 0 bombs around, and is not revealed
    // for (int i = 0; i < numOfSquares; i++) {
    //   squareStatus.add([0, false]);
    // }
    //matrix.initSquare();
    //matrix.display();
    super.initState();
    //scanBombs();
  }

  void restartGame() {
    setState(() {
      bombsRevealed = false;
      for (int i = 0; i < numOfSquares; i++) {
        squareStatus[i][1] = false;
      }
    });
  }

  void revealBoxNumbers(int index) {
    // reveal current box if it is a number: 1,2,3 ...
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][0] = true;
      });
    }
    // if current box is 0
    else if (squareStatus[index][0] == 0) {
      // reveal current box, and the 8 surrounding boxes, unless you're on a wall
      setState(() {
        // reveal current box
        squareStatus[index][1] = true;
        // reveal left box (unless we are currently on the left wall)
        if (index & numOfEachRow != 0) {
          // if next  box isn't revealed yet and it is a 0, then recurse
          if (squareStatus[index - 1][0] == 0 &&
              squareStatus[index - 1][1] == false) {
            revealBoxNumbers(index - 1);
          }
          // reveal left box
          squareStatus[index - 1][1] = true;
        }
      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numOfSquares; i++) {
      // there are no bombs around initially
      int numberOfBombsAround = 0;

      // check each square to see if it has  bombs surrounding it, there are 8 surrounding boxes to check
      // check square to the left, unless it is in the first column
      if (bombLocation.contains(i - 1) && i % numOfEachRow != 0)
        numberOfBombsAround++;

      // check square to the top left, unless it is in the first column or first row
      if (bombLocation.contains(i - 1 - numOfEachRow) &&
          i % numOfEachRow != 0 &&
          i >= numOfEachRow) numberOfBombsAround++;
      // check square to the top, unless it is in the first row
      if (bombLocation.contains(i - numOfEachRow) && i >= numOfEachRow)
        numberOfBombsAround++;
      // check square to the top right, unless it is in the first row or last column
      if (bombLocation.contains(i + 1 - numOfEachRow) &&
          i % numOfEachRow != numOfEachRow - 1 &&
          i >= numOfEachRow) numberOfBombsAround++;
      // check square to the right, unless it is in the last column
      if (bombLocation.contains(i + 1) && i % numOfEachRow != numOfEachRow - 1)
        numberOfBombsAround++;
      // check square to the bottom right, unless it is in the last column or last row
      if (bombLocation.contains(i + 1 + numOfEachRow) &&
          i % numOfEachRow != numOfEachRow - 1 &&
          i >= numOfSquares - numOfEachRow) numberOfBombsAround++;
      // check square to the bottom, unless it is in the last row
      if (bombLocation.contains(i + numOfEachRow) &&
          i < numOfSquares - numOfEachRow) numberOfBombsAround++;
      // check square to the bottom left, unless it is in the last row or first column
      if (bombLocation.contains(i - 1 + numOfEachRow) &&
          i % numOfEachRow != 0 &&
          i < numOfSquares - numOfEachRow) numberOfBombsAround++;

      // add total number of bombs  around to square status
      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void playerLose() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: Center(
              child: Text(
            'YOU LOST!',
            style: TextStyle(color: Colors.white),
          )),
          actions: [
            MaterialButton(
              color: Colors.grey,
              onPressed: () {
                restartGame();
                Navigator.of(context).pop();
              },
              child: Icon(Icons.refresh),
            )
          ],
        );
      },
    );
  }

  void playerWon() {}
  void checkWinner() {
    // check how many boxes yet to reveal
    int unrevealedBoxes = 0;
    for (int i = 0; i < numOfSquares; i++) {
      if (squareStatus[i][1] = false) {
        unrevealedBoxes++;
      }
    }
    if (unrevealedBoxes == bombLocation.length) {
      playerWon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BackroundColor,
      body: Column(
        children: [
          // game stats and menu
          Container(
            height: 150,
            color: AppColors.appbarColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // display number of bombs
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '6',
                      style: TextStyle(fontSize: 40),
                    ),
                    Text('B O M B'),
                  ],
                ),

                // BUTTON to refresh the game
                Card(
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 40,
                  ),
                  color: Colors.grey[700],
                ),
                // display time taken
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '0',
                      style: TextStyle(fontSize: 40),
                    ),
                    Text('T I M E'),
                  ],
                )
              ],
            ),
          ),
          // grid
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: matrix.numOfSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: matrix.numOfEachRow),
              itemBuilder: (context, index) {
                int row = (index / matrix.numOfEachRow).toInt();
                int col = index % matrix.numOfEachRow;
                if (matrix.isBomb(row, col)) {
                  return Bomb(
                    revealed: true,
                    function: () {
                      // player tapped the bomb, so player loses
                      setState(() {
                        bombsRevealed = true;
                      });
                      playerLose();
                    },
                  );
                } else {
                  return NumberBox(
                    child: matrix.Squares[row][col][0],
                    revealed: matrix.squares[row][col][1],
                    function: () {
                      // revearl current box
                      setState(() {
                        matrix.revealBoxNumbers(row, col);
                      });
                      //revealBoxNumbers(index);
                      //checkWinner();
                    },
                  );
                }
              },
            ),
          )
          // branding
        ],
      ),
    );
  }
}
