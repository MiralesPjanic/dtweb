import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview/responsible_file/responsible_file.dart';
import 'package:webview/theme_this_time_not_usable/fonts.dart';

class InternetNotAvailablePage extends StatelessWidget {
  const InternetNotAvailablePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: SizeConfig.blockVertical * 13,
          child: Image.asset("assets/images/home_page_images/no-signal.png"),
        ),
        Text(
          "Ooops!".tr(),
          style: Fonts.ooops,
        ),
        Text(
          "No Internet Connection Found".tr(),
          style: Fonts.networkMessage,
        ),
        Text(
          "Check Your Connection".tr(),
          style: Fonts.networkMessage,
        )
      ],
    );
  }
}
