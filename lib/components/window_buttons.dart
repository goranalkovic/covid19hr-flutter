import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: MinimizeWindowButton(
            colors: buttonColors,
            animate: true,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: MaximizeWindowButton(
            colors: buttonColors,
            animate: true,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: CloseWindowButton(
            colors: closeButtonColors,
            animate: true,
          ),
        ),
      ],
    );
  }
}
