import 'package:flutter/material.dart';
import 'package:minesweeper/models/app_colors.dart';

class Bomb extends StatelessWidget {
  bool revealed;
  bool checkFlag;
  final function;
  final longPress;

  Bomb({
    required this.revealed,
    required this.checkFlag,
    this.function,
    this.longPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      onLongPress: longPress,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: revealed ? AppColors.bombColor : AppColors.hideBoxColor,
          child: checkFlag
              ? Image.asset("assets/flag.png")
              : (revealed ? Image.asset("assets/bomb.png") : null),
        ),
      ),
    );
  }
}
