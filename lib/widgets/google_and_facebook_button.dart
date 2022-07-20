import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview/theme_this_time_not_usable/fonts.dart';

import '../responsible_file/responsible_file.dart';

class GoogleAndFacebookButton extends StatelessWidget {
  final String? iconImage;
  final String? iconTitle;

  const GoogleAndFacebookButton(
      {Key? key, required this.iconImage, required this.iconTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.blockVertical * 6 + 6,
      child: Ink(
        decoration: BoxDecoration(
            color: const Color(0xffF4F4F4),
            borderRadius: BorderRadius.circular(30.0)),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  iconImage.toString(),
                  height: SizeConfig.imageSizeMultiplier * 5,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(iconTitle.toString(),
                    style: Fonts.googleAndFacebookButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
