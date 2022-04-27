import 'package:flutter/material.dart';

void doneAlert(BuildContext context) {
  Navigator.pop(context);
  showDialog(
      context: context,
      builder: (_) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Icon(Icons.cloud_done_rounded, size: 35),
          ),
        );
      });
}
