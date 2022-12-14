import 'package:flutter/material.dart';

PreferredSizeWidget weatherAppBar(
    {required BuildContext context, required String title, Widget? image}) {
  double size = (image == null ? 100 : 300);
  return PreferredSize(
      preferredSize: Size.fromHeight(size),
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (image != null)
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: image,
                ),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ))
            ],
          )));
}
