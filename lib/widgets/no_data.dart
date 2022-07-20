import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview/utils/colors.dart';

class NoData extends StatelessWidget {
  final String? message;
  const NoData({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/no_data.png',
          height: 250,
        ),
        Text(
          message!.toString(),
          style: GoogleFonts.puritan(
              fontSize: 26, fontStyle: FontStyle.normal, color: colorPrimary),
        )
      ],
    ));
  }
}
