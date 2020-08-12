import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(6),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        direction: Axis.horizontal,
        verticalDirection: VerticalDirection.down,
        children: [
          Center(
            child: Text(
              'Podaci preuzeti s javnog dostupnog API-ja Nacionalnog stožera',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Center(
            child: Text(
              'Copyright © Goran Alković, 2020',
            ),
          )
        ],
      ),
    );
  }
}
