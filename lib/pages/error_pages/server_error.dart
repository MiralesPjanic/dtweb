import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview/utils/colors.dart';

class ServerError extends StatefulWidget {
  const ServerError({Key? key}) : super(key: key);

  @override
  _ServerErrorState createState() => _ServerErrorState();
}

class _ServerErrorState extends State<ServerError> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/no_internet.png',
            height: 250,
          ),
          SizedBox(height: 30),
          Text(
            'There are server issue',
            style: GoogleFonts.puritan(
                fontSize: 26, fontStyle: FontStyle.normal, color: colorPrimary),
          ),
          SizedBox(height: 10),
          Text(
            'Checking the server and related issue',
            style: GoogleFonts.puritan(
                fontSize: 14, fontStyle: FontStyle.normal, color: colorAccent),
          ),
          SizedBox(height: 20),
          TextButton(
              child:
                  Text("Close".toUpperCase(), style: TextStyle(fontSize: 14)),
              style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(colorPrimary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: colorPrimary)))),
              onPressed: () => Navigator.pop(context)),
        ],
      )),
    );
  }
}
