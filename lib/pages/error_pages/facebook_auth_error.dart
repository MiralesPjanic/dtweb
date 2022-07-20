import 'package:flutter/material.dart';

class FacebookAuthError extends StatefulWidget {
  const FacebookAuthError({Key? key}) : super(key: key);

  @override
  _FacebookAuthErrorState createState() => _FacebookAuthErrorState();
}

class _FacebookAuthErrorState extends State<FacebookAuthError> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Please try again",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
