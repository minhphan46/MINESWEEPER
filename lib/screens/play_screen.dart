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
  // matrix of squares
  MatrixBox matrix = MatrixBox(numOfEachRow: 10);
  @override
  void initState() {
    matrix.resetSquares();
    //matrix.display();
    super.initState();
  }

  void playerLose() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: const Center(
              child: Text(
            'YOU LOST!',
            style: TextStyle(color: Colors.white),
          )),
          actions: [
            MaterialButton(
              color: Colors.grey,
              onPressed: () {
                setState(() {
                  matrix.resetSquares();
                });
                Navigator.of(context).pop();
              },
              child: Icon(Icons.refresh),
            )
          ],
        );
      },
    );
  }

  void playerWon() {
    if (matrix.checkWinner()) {
      // show dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: const Center(
                child: Text(
              'YOU WIN!',
              style: TextStyle(color: Colors.white),
            )),
            actions: [
              MaterialButton(
                color: Colors.grey,
                onPressed: () {
                  setState(() {
                    matrix.resetSquares();
                  });
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.refresh),
              )
            ],
          );
        },
      );
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
                    revealed: matrix.bombsRevealed,
                    function: () {
                      // player tapped the bomb, so player loses
                      setState(() {
                        matrix.bombsRevealed = true;
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
                        playerWon();
                      });
                      // check winner
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
