import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final String value;
  final Widget child;
  final Color color;

  Badge({
    @required this.value,
    @required this.child,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color != null? color:Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(
              minHeight: 16,
              minWidth: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
