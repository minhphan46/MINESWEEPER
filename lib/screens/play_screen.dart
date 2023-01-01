import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minesweeper/models/app_colors.dart';
import 'package:minesweeper/models/matrix_box.dart';
import 'package:minesweeper/widgets/bomb.dart';
import 'package:minesweeper/widgets/number_box_widget.dart';
import 'package:minesweeper/widgets/setting_dialog.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  // timer
  int timePlay = 0;
  Timer? _timer;

  void startTimer() {
    timePlay = 0;
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timePlay++;
      });
    });
  }

  // matrix of squares
  MatrixBox matrix = MatrixBox(numOfRow: 16, numOfCol: 10, numberOfBoms: 10);
  @override
  void initState() {
    matrix.resetSquares();
    startTimer();
    //matrix.display();
    super.initState();
  }

  void restartGame() {
    setState(() {
      startTimer();
      matrix.resetSquares();
    });
  }

  void playerLose() {
    _timer!.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.diaLogBackroundColor,
          title: const Center(
              child: Text(
            'YOU LOST!',
            style: TextStyle(color: Colors.white),
          )),
          actions: [
            MaterialButton(
              color: AppColors.backroundButtonColor,
              onPressed: () {
                restartGame();
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.refresh,
                color: AppColors.IconColor,
              ),
            )
          ],
        );
      },
    );
  }

  void playerWon() {
    if (matrix.checkWinner()) {
      // show dialog
      _timer!.cancel();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.diaLogBackroundColor,
            title: Center(
              child: Column(
                children: [
                  const Text(
                    'YOU WIN!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Your time: ${timePlay}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              MaterialButton(
                color: AppColors.backroundButtonColor,
                onPressed: () {
                  restartGame();
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.refresh,
                  color: AppColors.IconColor,
                ),
              )
            ],
          );
        },
      );
    }
  }

  void createNewSquare(int numofCols, int numOfBombs) {
    double width = MediaQuery.of(context).size.width;
    double heigth = MediaQuery.of(context).size.height -
        160 -
        MediaQuery.of(context).padding.top;
    double sizeBox = width / numofCols;
    int numOfRow = (heigth / sizeBox).toInt();
    matrix = MatrixBox(
      numOfRow: numOfRow,
      numOfCol: numofCols,
      numberOfBoms: numOfBombs,
    );
    restartGame();
  }

  void settingGame() {
    showDialog(
      context: context,
      builder: (context) {
        return SettingDialog(matrix, createNewSquare);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BackroundColor,
      body: Column(
        children: [
          // game stats and menu
          SizedBox(height: 20),
          Container(
            height: 100,
            color: AppColors.appbarColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // display time taken
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timePlay.toString(),
                      style: TextStyle(fontSize: 40),
                    ),
                    Text('T I M E'),
                  ],
                ),
                // BUTTON to refresh the game
                GestureDetector(
                  onTap: restartGame,
                  child: Card(
                    color: AppColors.backroundButtonColor,
                    child: Icon(
                      Icons.refresh,
                      color: AppColors.IconColor,
                      size: 40,
                    ),
                  ),
                ),
                // display number of bombs
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      matrix.BombLocations.length.toString(),
                      style: TextStyle(fontSize: 40),
                    ),
                    const Text('B O M B'),
                  ],
                ),
              ],
            ),
          ),
          // grid
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: matrix.numOfSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: matrix.numOfCol),
              itemBuilder: (context, index) {
                int row = (index / matrix.numOfCol).toInt();
                int col = index % matrix.numOfCol;
                //print("row = ${row} col = ${col} i = ${index}");
                if (matrix.isBomb(row, col)) {
                  return Bomb(
                    revealed: matrix.bombsRevealed,
                    checkFlag: matrix.squares[row][col][2],
                    function: () {
                      if (matrix.squares[row][col][2] == true) {
                        matrix.squares[row][col][2] = false;
                      } else {
                        // player tapped the bomb, so player loses
                        setState(() {
                          matrix.bombsRevealed = true;
                        });
                        playerLose();
                      }
                    },
                    longPress: () {
                      setState(() {
                        matrix.changeFlag(row, col);
                      });
                    },
                  );
                } else {
                  return NumberBox(
                    child: matrix.Squares[row][col][0],
                    revealed: matrix.squares[row][col][1],
                    checkFlag: matrix.squares[row][col][2],
                    function: () {
                      // revearl current box
                      setState(() {
                        matrix.revealBoxNumbers(row, col);
                        playerWon();
                      });
                    },
                    longPress: () {
                      setState(() {
                        matrix.changeFlag(row, col);
                      });
                    },
                  );
                }
              },
            ),
          ),
          // branding
          Container(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: settingGame,
                    icon: Icon(
                      Icons.settings,
                      color: AppColors.IconButtonColor,
                    ),
                  ),
                  Text(
                    "CREATED BY MINH PHAN",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.IconButtonColor,
                    ),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      null,
                      //Icons.schedule_outlined,
                      color: AppColors.IconButtonColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
