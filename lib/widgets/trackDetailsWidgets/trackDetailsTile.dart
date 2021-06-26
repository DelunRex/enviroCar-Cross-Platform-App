import 'package:flutter/material.dart';

import '../../constants.dart';

class TrackDetailsTile extends StatelessWidget {
  final String title;
  final String details;
  final IconData iconData;

  TrackDetailsTile({@required this.title, @required this.details, @required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        dense: true,
        title: Text(
          title,
          style: TextStyle(
              color: kGreyColor.withOpacity(0.8),
              fontWeight: FontWeight.w600
          ),
        ),
        leading: Icon(
          iconData,
          color: kSpringColor,
        ),
        trailing: Container(
          width: 140,
          child: Text(
            details,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: kGreyColor.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}