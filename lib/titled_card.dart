import 'package:flutter/material.dart';

class TitledCard extends StatelessWidget {
  const TitledCard(
      {Key key,
      this.title,
      @required this.child,
      this.rightOfTitle,
      this.maxWidth = 480})
      : super(key: key);

  final String title;
  final Widget child;
  final Widget rightOfTitle;
  final double maxWidth;
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      maxWidth: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Container(
                // color: Colors.lightGreen.withOpacity(0.3),
                margin: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: "DMSans",
                          ),
                    ),
                    if (rightOfTitle != null) rightOfTitle,
                  ],
                )),
          SizedBox(height: 8),
          child
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({Key key, @required this.child, this.maxWidth = 480})
      : super(key: key);

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 700,
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        // color: Colors.pink.withOpacity(0.2),
        // border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}
