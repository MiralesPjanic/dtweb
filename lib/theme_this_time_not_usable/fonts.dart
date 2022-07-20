import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview/utils/colors.dart';

import '../responsible_file/responsible_file.dart';

class Fonts {
  static final welcomeBack = GoogleFonts.rubik(
      fontSize: SizeConfig.textMultiplier * 3,
      fontWeight: FontWeight.w700,
      color: black);

  static final enterYourMobileNumberToLogin = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2,
      fontWeight: FontWeight.w400,
      color: dimGray);

  static final enterYourMobileNumber = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2 - 2,
      fontWeight: FontWeight.w400,
      color: nobel);

  static final login = GoogleFonts.rubik(
      fontSize: SizeConfig.textMultiplier * 2 + 2,
      fontWeight: FontWeight.w500, //medium
      color: white);

  static final or = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2 - 2,
      fontWeight: FontWeight.w400,
      color: nobel);

  static final googleAndFacebookButton = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2 - 2,
      fontWeight: FontWeight.w500,
      color: black);

  static final verifyPhoneNumber = GoogleFonts.rubik(
      fontSize: SizeConfig.textMultiplier * 3 + 2,
      fontWeight: FontWeight.w500, //midium
      color: black);

  static final weHaveSentCodeToYourNumber = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2 - 2,
      fontWeight: FontWeight.w400, //regular
      color: dimGray);

  static final mobileNumber = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2 - 1,
      fontWeight: FontWeight.w500, //midium
      color: dimGray);

  static final otpBox = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2 + 3,
      fontWeight: FontWeight.w500,
      color: black);

  static final codeExpireSoon = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2 - 2,
      fontWeight: FontWeight.w400,
      color: dimGray);

  static final time = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2 - 2,
      fontWeight: FontWeight.w400,
      color: red);

  static final confirm = Fonts.login;

  static final resend = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2 - 2,
      fontWeight: FontWeight.w600,
      color: black);
  static final resendDisable = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2 - 2,
      fontWeight: FontWeight.w600,
      color: black.withOpacity(0.3));

  static final ooops = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 4,
      fontWeight: FontWeight.w800,
      color: black.withOpacity(0.3));

  static final networkMessage = GoogleFonts.poppins(
      fontSize: SizeConfig.textMultiplier * 2,
      fontWeight: FontWeight.w600,
      color: black.withOpacity(0.3));
}
