import 'package:flutter/material.dart';

class NumberBox extends StatelessWidget {
  final child;
  bool revealed;
  final function;

  NumberBox({this.child, required this.revealed, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: revealed ? Colors.grey[300] : Colors.grey[400],
          child: Center(
            child: Text(
              revealed ? child.toString() : '',
            ),
          ),
        ),
      ),
    );
  }
}
