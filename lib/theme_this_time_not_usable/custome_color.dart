import 'package:flutter/material.dart';

class CustomeColor {
//Color in Int

  static const _bottomNavigationBarBackgroundColorInt = 0xFFFFFFFF;
  static const _bottomNavigationBarSelectedItemColorInt = 0xFFFFFFFF;
  static const _bottomNavigationBarUnselectedItemColorInt = 0xFF000000;

//int to Color Converted

  static const bottomNavigationBarBackgroundColor =
      Color(_bottomNavigationBarBackgroundColorInt);
  static const bottomNavigationBarSelectedItemColor =
      Color(_bottomNavigationBarSelectedItemColorInt);
  static const bottomNavigationBarUnselectedItemColor =
      Color(_bottomNavigationBarUnselectedItemColorInt);
}
