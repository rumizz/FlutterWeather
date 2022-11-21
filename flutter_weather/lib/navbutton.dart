import 'package:flutter/material.dart';

Widget navButton(
    {required BuildContext context,
    required String text,
    required String route}) {
  return Container(
      margin: const EdgeInsets.all(30),
      child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 20, right: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100))),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    text,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ))
            ],
          )));
}
