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

void alert(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'The name of the book is already in use !!',
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
        );
      });
}
