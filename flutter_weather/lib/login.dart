import 'package:flutter/material.dart';
import 'package:flutter_weather/appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: weatherAppBar(
          title: "Log In",
          image: SvgPicture.asset("weather1.svg",
              semanticsLabel: 'Weather logo', height: 200)),
      body: Container(
        margin: const EdgeInsets.all(30),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 5),
                  child: Text(
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Enter username",
                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 5),
                  child: Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Enter password",
                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
                obscureText: true,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/map');
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
