import 'package:flutter/material.dart';

class LegendItem extends StatelessWidget {
  const LegendItem({
    Key key,
    @required this.color,
    @required this.title,
    this.currentValue,
  }) : super(key: key);

  final double currentValue;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 14,
            width: 14,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
          ),
          SizedBox(width: 8),
          if (currentValue == null)
            Text(title)
          else
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title),
                  Text(
                    '${(currentValue * 100).toStringAsFixed(2)}%',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
