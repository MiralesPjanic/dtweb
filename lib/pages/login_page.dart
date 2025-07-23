import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:webview/pages/error_pages/facebook_auth_error.dart';
import 'package:webview/utils/adhelper.dart';
import 'package:webview/utils/colors.dart';
import 'package:webview/utils/sharedpre.dart';
import 'package:webview/pages/home_page.dart';
import 'package:webview/theme_this_time_not_usable/fonts.dart';
import 'package:webview/utils/utility.dart';
import '../provider/apiprovider.dart';
import '../responsible_file/responsible_file.dart';
import '../widgets/google_and_facebook_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import '../utils/html_shim.dart' if (dart.library.html) 'dart:html' show window;

enum LoginScreen { enterMobileNumber, enterOTPNumber }

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool wait = false;
  int start = 59;
  // ignore: prefer_typing_uninitialized_variables
  var phoneNumberCountryCode;

//------------------------Controller Variable--------------------------------------------------------------

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();

//------------------------Mobile Form Key Variable--------------------------------------------------------------

  final _formKey = GlobalKey<FormState>();

//-----------------------Firebase Authentication Variable--------------------------------------------------------------

  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationId = "";

//-----------------------Current Screen Enum Variable--------------------------------------------------------------

  LoginScreen currentState = LoginScreen.enterMobileNumber;

  @override
  void initState() {
    getId();
    super.initState();
  }

  getId() async {
    await AdHelper.getAds();
  }

// This class build Method-
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      body: currentState == LoginScreen.enterMobileNumber
          ? showMobile(context)
          : showOtp(context),
    );
  }

// Facebook SignIn Method

  Future<UserCredential> signInWithFacebook() async {
    OAuthCredential? facebookAuthCredential;
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Create a credential from the access token

      facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      //  idToken: googleSignInAuthentication.idToken,
      return await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
    } catch (e) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FacebookAuthError()));
    }
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential!);
  }

// Phone Authentication Method---

  void signInWithPhoneAuthCred(AuthCredential phoneAuthCredential) async {
    try {
      final authCred = await auth.signInWithCredential(phoneAuthCredential);

      if (authCred.user != null) {
        // Login Api
        login(authCred.user?.phoneNumber, authCred.user?.phoneNumber, 1);
      }
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Some Error Occured. Try Again Later')));
    }
  }

// Google Signin Method-----------

  Future<void> signupGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);

      User? user = result.user;

      login(user!.providerData[0].email, user.displayName, 3);
    }
  }

  login(var email, var username, var type) async {
    var apiprovide = Provider.of<ApiProvider>(context, listen: false);
    await apiprovide.login(email, username, type);

    if (apiprovide.loading) {
      if (apiprovide.loginmodel.status.toString() == "200") {
        await SharedPre()
            .save("email", apiprovide.loginmodel.result?[0].email ?? "");
        await SharedPre()
            .save("userName", apiprovide.loginmodel.result?[0].username ?? "");
        await SharedPre().save("pic", '');
        await SharedPre()
            .save("type", apiprovide.loginmodel.result?[0].type ?? "");
        await SharedPre().save("login", 'off');

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Utility.toastMessage(apiprovide.loginmodel.message.toString());
      }
    }
  }
  // UI Methods-

// Login Screen UI----
  showMobile(context) {
    return SingleChildScrollView(
      child: Consumer<ApiProvider>(
        builder: (context, logindata, child) {
          return Container(
            height: SizeConfig.screenHeight,
            margin: EdgeInsets.only(
                top: SizeConfig.blockVertical * 8,
                left: SizeConfig.blockVertical * 4,
                right: SizeConfig.blockVertical * 4),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.blockVertical * 3),
                        child: Image.network(
                          logindata.getSettingModel.result?[0].appLogo
                                  .toString() ??
                              "",
                          fit: BoxFit.cover,
                          height: 100,
                        ),
                      ),
                      Container(
                        child: Text(
                          'Welcome back,'.tr(),
                          style: Fonts.welcomeBack,
                        ).tr(),
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockVertical,
                            bottom: SizeConfig.blockHorizontal),
                      ),
                      logindata.getSettingModel.result?[0].loginWithMobile ==
                              "On"
                          ? Container(
                              margin: EdgeInsets.only(
                                bottom: SizeConfig.blockVertical * 4,
                              ),
                              child: Text(
                                "Enter your mobile number".tr(),
                                style: Fonts.enterYourMobileNumberToLogin,
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(
                                bottom: SizeConfig.blockVertical * 4,
                              ),
                              child: Text(
                                "Please Login".tr(),
                                style: Fonts.enterYourMobileNumberToLogin,
                              ),
                            ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    width: double.infinity,
                    child: Column(
                      children: [
                        logindata.getSettingModel.result?[0].loginWithMobile ==
                                "On"
                            ? IntlPhoneField(
                                disableLengthCheck: true,
                                autovalidateMode: AutovalidateMode.disabled,
                                controller: mobileNumberController,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.textMultiplier * 2 - 2),
                                showCountryFlag: false,
                                showDropdownIcon: false,
                                decoration: InputDecoration(
                                  hintText: "Enter your mobile number".tr(),
                                  hintStyle: Fonts.enterYourMobileNumber,
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8)),
                                  ),
                                ),
                                initialCountryCode: 'IN',
                                onChanged: (phone) {
                                  phoneNumberCountryCode = phone.completeNumber;
                                  debugPrint('===> ${phone.completeNumber}');
                                },
                                onCountryChanged: (value) {},
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                        SizedBox(
                          height: SizeConfig.blockVertical * 4,
                        ),
                        logindata.getSettingModel.result?[0].loginWithMobile ==
                                "On"
                            ? InkWell(
                                onTap: () async {
                                  await auth.verifyPhoneNumber(
                                    phoneNumber: phoneNumberCountryCode,
                                    verificationCompleted:
                                        (phoneAuthCredential) async {},
                                    verificationFailed: (verificationFailed) {},
                                    codeSent: (verificationIdReal,
                                        resendingToken) async {
                                      setState(() {
                                        verificationId = verificationIdReal;
                                        currentState =
                                            LoginScreen.enterOTPNumber;

                                        startOTPExpireTime();
                                        wait = false;
                                        setState(() {
                                          start = 59;
                                          wait = true;
                                        });
                                      });
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationID) {},
                                  );
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  height: SizeConfig.blockVertical * 6 + 3,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            colorPrimary,
                                            colorPrimaryDark
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text("Login".tr(),
                                          textAlign: TextAlign.center,
                                          style: Fonts.login),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                        SizedBox(
                          height: SizeConfig.blockVertical * 3,
                        ),
                        logindata.getSettingModel.result?[0].loginWithMobile ==
                                    "On" &&
                                logindata.getSettingModel.result?[0]
                                        .loginWithGmail ==
                                    "On"
                            ? SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: SizeConfig.blockHorizontal / 2,
                                      color: nobel,
                                      width: 90,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 6, right: 6),
                                      child: Text(
                                        "or".tr(),
                                        style: Fonts.or,
                                      ),
                                    ),
                                    Container(
                                      height: SizeConfig.blockHorizontal / 2,
                                      color: nobel,
                                      width: 90,
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                height: 0,
                              ),
                        SizedBox(
                          height: SizeConfig.blockVertical * 3,
                        ),
                        logindata.getSettingModel.result?[0].loginWithGmail ==
                                "On"
                            ? InkWell(
                                onTap: () {
                                  signupGoogle(context);
                                },
                                // ignore: prefer_const_constructors
                                child: GoogleAndFacebookButton(
                                  iconTitle: "Login With Google".tr(),
                                  iconImage:
                                      "assets/images/login_page_images/google.svg",
                                ),
                              )
                            : const Text(""),
                        SizedBox(
                          height: SizeConfig.blockVertical * 2,
                        ),
                        logindata.getSettingModel.result?[0]
                                    .loginWithFacebook ==
                                "On"
                            ? InkWell(
                                onTap: () async {
                                  await signInWithFacebook()
                                      .then((value) async {
                                    Map<String, dynamic>? data =
                                        value.additionalUserInfo!.profile;

                                    login(data!["email"], data["name"], 2);
                                  });
                                },
                                child: GoogleAndFacebookButton(
                                  iconTitle: "Login With Facebook".tr(),

                                  // Facebook SignIn Method
                                  iconImage:
                                      "assets/images/login_page_images/facebook.svg",
                                ),
                              )
                            : const Text(""),
                        SizedBox(
                          height: SizeConfig.blockVertical * 2,
                        ),
                        if (Platform.isIOS)
                          SignInWithAppleButton(
                            onPressed: () async {
                              final credential =
                                  await SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                  AppleIDAuthorizationScopes.fullName,
                                ],
                                webAuthenticationOptions:
                                    WebAuthenticationOptions(
                                  clientId:
                                      'de.lunaone.flutter.signinwithappleexample.service',
                                  redirectUri:
                                      // For web your redirect URI needs to be the host of the "current page",
                                      // while for Android you will be using the API server that redirects back into your app via a deep link
                                      kIsWeb
                                          ? Uri.parse(
                                              'https://${window.location.host}/')
                                          : Uri.parse(
                                              'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                                            ),
                                ),
                                nonce: 'example-nonce',
                                state: 'example-state',
                              );

                              // ignore: avoid_print
                              print(credential);

                              // This is the endpoint that will convert an authorization code obtained
                              // via Sign in with Apple into a session in your system
                              final signInWithAppleEndpoint = Uri(
                                scheme: 'https',
                                host:
                                    'flutter-sign-in-with-apple-example.glitch.me',
                                path: '/sign_in_with_apple',
                                queryParameters: <String, String>{
                                  'code': credential.authorizationCode,
                                  if (credential.givenName != null)
                                    'firstName': credential.givenName!,
                                  if (credential.familyName != null)
                                    'lastName': credential.familyName!,
                                  'useBundleId': !kIsWeb &&
                                          (Platform.isIOS || Platform.isMacOS)
                                      ? 'true'
                                      : 'false',
                                  if (credential.state != null)
                                    'state': credential.state!,
                                },
                              );

                              final session = await http.Client().post(
                                signInWithAppleEndpoint,
                              );

                              // If we got this far, a session based on the Apple ID credential has been created in your system,
                              // and you can now set this as the app's session
                              // ignore: avoid_print
                              print(session.body);
                            },
                          )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockVertical * 5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

// OTP Verify Screen UI

  showOtp(context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      margin: EdgeInsets.only(
        top: SizeConfig.blockVertical * 3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.blockVertical + 2,
                  left: SizeConfig.blockVertical + 2,
                ),
                height: SizeConfig.blockVertical * 6,
                width: SizeConfig.blockVertical * 6,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      currentState = LoginScreen.enterMobileNumber;

                      otpController.clear();
                      mobileNumberController.clear();
                      startOTPExpireTime();
                    });
                  },
                  child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Container(
                          child: SvgPicture.asset(
                            "assets/images/verify_phone_number_pages_images/left_arrow.svg",
                          ),
                          decoration: const BoxDecoration(
                              // The child of a round Card should be in round shape
                              shape: BoxShape.circle,
                              color: white))),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Verify Phone Number".tr(),
                    style: Fonts.verifyPhoneNumber,
                  ),
                  SizedBox(
                    height: SizeConfig.blockVertical + 2,
                  ),
                  Text(
                    "We have sent code to your number".tr(),
                    style: Fonts.weHaveSentCodeToYourNumber,
                  ),
                  SizedBox(
                    height: SizeConfig.blockVertical + 2,
                  ),
                  Text(
                    phoneNumberCountryCode,
                    style: Fonts.mobileNumber,
                  ),
                  SizedBox(
                    height: SizeConfig.blockVertical * 4,
                  ),
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              left: SizeConfig.blockVertical * 1,
              right: SizeConfig.blockVertical * 1,
            ),
            child: PinCodeTextField(
              autoDisposeControllers: false,
              autoFocus: true,
              textStyle: Fonts.otpBox,
              cursorColor: colorPrimary,
              showCursor: true,
              enableActiveFill: true,
              keyboardType: TextInputType.phone,
              length: 6,
              controller: otpController,
              pinTheme: PinTheme(
                inactiveFillColor: white,
                inactiveColor: gray,
                activeColor: colorPrimary,
                activeFillColor: white,
                selectedColor: colorPrimary,
                selectedFillColor: white,
                borderRadius: BorderRadius.circular(10),
                borderWidth: 1,
                shape: PinCodeFieldShape.box,
                fieldHeight: SizeConfig.blockVertical * 6,
                fieldWidth: SizeConfig.blockVertical * 6,
              ),
              onChanged: (value) {},
              appContext: context,
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.blockVertical + 2,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Code expire soon: '.tr(),
                          style: Fonts.codeExpireSoon,
                          children: <TextSpan>[
                            TextSpan(text: '0:', style: Fonts.time),
                            TextSpan(text: "$start", style: Fonts.time),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockVertical * 2 + 4,
                      ),
                    ],
                  )
                ],
              ),
              InkWell(
                onTap: () async {
                  AuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text,
                  );

                  signInWithPhoneAuthCred(phoneAuthCredential);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: SizeConfig.blockVertical + 2,
                    right: SizeConfig.blockVertical + 2,
                  ),
                  width: double.infinity,
                  height: SizeConfig.blockVertical * 6,
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorPrimary, colorPrimaryDark],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text("Confirm".tr(),
                          textAlign: TextAlign.center, style: Fonts.login),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.blockVertical * 2 + 4,
                      ),
                      InkWell(
                        onTap: () async {
                          wait = false;
                          setState(() {
                            start = 59;
                            wait = true;
                          });
                          await auth.verifyPhoneNumber(
                              phoneNumber: phoneNumberCountryCode,
                              verificationCompleted:
                                  (phoneAuthCredential) async {},
                              verificationFailed: (verificationFailed) {},
                              codeSent: (verificationID, resendingToken) async {
                                setState(() {
                                  currentState = LoginScreen.enterOTPNumber;
                                  verificationId = verificationID;
                                  otpController.clear();
                                  startOTPExpireTime();
                                });
                              },
                              codeAutoRetrievalTimeout:
                                  (verificationID) async {});
                        },
                        child: Text(
                          "Resend".tr(),
                          style:
                              start == 0 ? Fonts.resend : Fonts.resendDisable,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

// OTP Expire Time Method-
  void startOTPExpireTime() async {
    const onsec = Duration(seconds: 1);
    // ignore: unused_local_variable
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }
}
