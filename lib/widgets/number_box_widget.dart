import 'package:flutter/material.dart';
import 'package:minesweeper/models/app_colors.dart';

class NumberBox extends StatelessWidget {
  final child;
  bool revealed;
  bool checkFlag;
  final function;
  final longPress;

  NumberBox({
    this.child,
    required this.revealed,
    required this.checkFlag,
    this.function,
    this.longPress,
  });

  Color GetColor(int number) {
    if (number == 1) return Colors.red;
    if (number == 2) return Colors.blue;
    if (number == 3) return Colors.green;
    if (number == 4) return Colors.deepPurpleAccent;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    String number =
        revealed ? (child.toString() == '0' ? '' : child.toString()) : '';
    Color color = GetColor(child);

    return GestureDetector(
      onTap: function,
      onLongPress: longPress,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: revealed ? AppColors.showBoxColor : AppColors.hideBoxColor,
          child: Center(
            child: checkFlag
                ? Image.asset("assets/flag.png")
                : Text(
                    number,
                    style: TextStyle(color: color, fontSize: 18),
                  ),
          ),
        ),
      ),
    );
  }
}
