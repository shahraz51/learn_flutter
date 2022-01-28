import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  Badge({required this.child, required this.value});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(1.1, -2),
      children: [
        child,
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.red,
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
