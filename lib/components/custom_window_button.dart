import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../styles.dart';
import 'window_buttons.dart';

class _CustomWindowButton extends WindowButton {
  _CustomWindowButton({
    Key key,
    VoidCallback onPressed,
    IconData icon,
  }) : super(
          key: key,
          colors: buttonColors,
          animate: true,
          iconBuilder: (buttonContext) => Container(
            transform: Matrix4.translationValues(0, -5, 0),
            child: Icon(
              icon,
              color: buttonContext.iconColor,
              size: 20,
            ),
          ),
          onPressed: onPressed,
        );
}

class CustomWindowButton extends StatelessWidget {
  final Key key;
  final VoidCallback onPressed;
  final IconData icon;

  CustomWindowButton({
    this.key,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (!Platform.isWindows) {
      return Container(
        transform: Matrix4.translationValues(0, -4, 0),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: buttonColors.iconNormal,
          iconSize: 20,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: _CustomWindowButton(
        icon: icon,
        key: key,
        onPressed: onPressed,
      ),
    );
  }
}
