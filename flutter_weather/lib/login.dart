import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String errorMessage = "";

  void login(BuildContext context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: usernameController.text, password: passwordController.text)
        .then((UserCredential userCredential) =>
            Navigator.pushNamed(context, "/map"))
        .catchError((error) {
      print("Failed: $error");
      setState(() {
        errorMessage =
            error.toString().substring(error.toString().indexOf("]") + 2);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: weatherAppBar(
            context: context,
            title: "Log In",
            image: SvgPicture.asset("weather1.svg",
                semanticsLabel: 'Weather logo', height: 200)),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(30),
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
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
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter username",
                      contentPadding: EdgeInsets.only(left: 16, right: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    onFieldSubmitted: (value) => login(context),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 5),
                      child: Text(
                        "Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter password",
                      contentPadding: EdgeInsets.only(left: 16, right: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    obscureText: true,
                    onFieldSubmitted: (value) => login(context),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 5),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      )),
                  Container(
                      margin: const EdgeInsets.only(top: 32),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
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
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ))),
                ],
              ),
            ),
          ),
        ));
  }
}
