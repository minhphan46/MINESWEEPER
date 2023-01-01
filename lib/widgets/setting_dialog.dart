import 'package:flutter/material.dart';

import '../models/app_colors.dart';
import '../models/matrix_box.dart';

class SettingDialog extends StatefulWidget {
  MatrixBox matrix;
  Function createNewSquare;
  int cols = 0;
  int bombs = 0;
  SettingDialog(this.matrix, this.createNewSquare) {
    cols = matrix.numOfCol;
    bombs = matrix.numberOfBoms;
  }

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.diaLogBackroundColor,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'SETTING',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Columns: ",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (widget.cols > 4) widget.cols--;
                    if (widget.bombs > (widget.cols * widget.cols - 10))
                      widget.bombs = (widget.cols * widget.cols - 10);
                  });
                },
                icon: const Icon(
                  Icons.do_disturb_on_outlined,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              Text(
                "${widget.cols}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (widget.cols < 15) widget.cols++;
                  });
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Bombs:    ",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (widget.bombs > 3) widget.bombs--;
                  });
                },
                icon: const Icon(
                  Icons.do_disturb_on_outlined,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.bombs.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    int max = widget.cols * widget.cols;
                    if (widget.bombs < max - 10) widget.bombs++;
                  });
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        MaterialButton(
          color: AppColors.backroundButtonColor,
          onPressed: () {
            widget.createNewSquare(widget.cols, widget.bombs);
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.done,
            color: AppColors.IconColor,
          ),
        )
      ],
    );
  }
}
