import 'package:flutter/material.dart';

class TitledCard extends StatelessWidget {
  const TitledCard(
      {Key key, @required this.title, @required this.child, this.rightOfTitle})
      : super(key: key);

  final String title;
  final Widget child;
  final Widget rightOfTitle;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4.0),
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (rightOfTitle != null) rightOfTitle,
              ],
            ),
          ),
          SizedBox(height: 8),
          child
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 700,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}
