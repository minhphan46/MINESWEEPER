import 'package:flutter/material.dart';
import 'package:minesweeper/models/app_colors.dart';

class Bomb extends StatelessWidget {
  bool revealed;
  final function;

  Bomb({required this.revealed, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: revealed ? AppColors.bomBColor : AppColors.hideBoxColor,
        ),
      ),
    );
  }
}
