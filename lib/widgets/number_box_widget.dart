import 'package:flutter/material.dart';
import 'package:minesweeper/models/app_colors.dart';

class NumberBox extends StatelessWidget {
  final child;
  bool revealed;
  final function;

  NumberBox({this.child, required this.revealed, this.function});

  Color GetColor(int number) {
    if (number == 1) return Colors.red;
    if (number == 2) return Colors.blue;
    if (number == 3) return Colors.green;
    if (number == 4) return Colors.yellow;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    String number =
        revealed ? (child.toString() == '0' ? '' : child.toString()) : '';
    Color color = GetColor(child);

    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: revealed ? AppColors.showBoxColor : AppColors.hideBoxColor,
          child: Center(
            child: Text(
              number,
              style: TextStyle(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
