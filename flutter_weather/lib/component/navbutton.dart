import 'package:flutter/material.dart';
import 'package:flutter_weather/weather/route_notifier.dart';
import 'package:provider/provider.dart';

Widget navButton(
    {required BuildContext context,
    required String text,
    required String route}) {
  return Container(
      margin: const EdgeInsets.all(30),
      constraints: const BoxConstraints(maxWidth: 800),
      child: ElevatedButton(
          onPressed: () {
            context.read<RouteNotifier>().setRoute(route);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
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
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          )));
}
