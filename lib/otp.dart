import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:saarathi/pesonal_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hcp/create_account.dart';
import 'hcp/hcphome.dart';
import 'home.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Verification extends StatefulWidget {
  final String stypeValue, smobileCtrl, signuptype;
  const Verification(this.stypeValue, this.smobileCtrl, this.signuptype, {Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  late BuildContext ctx;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpCtrl = TextEditingController();
  bool again = false;
  bool isResend = false;



  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        backgroundColor: Clr().white,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/logo.png",
                width: Dim().d260,
                height: Dim().d260,
              ),
            ),
            Positioned(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: Dim().d250),
                  child: Container(
                    height: 600.0,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Clr().grey.withOpacity(0.1),
                            spreadRadius: 0.1,
                            blurRadius: 12,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                        color: Clr().white,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40))),
                    child: Padding(
                      padding: EdgeInsets.all(Dim().d16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'OTP Verification',
                              textAlign: TextAlign.left,
                              style: Sty().largeText.copyWith(
                                  color: Clr().primaryColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '4 digit code has been sent to +91 ${widget.smobileCtrl}',
                                style: Sty().mediumText.copyWith(
                                    fontSize: Dim().d12,
                                    fontWeight: FontWeight.w600),
                              )),
                          SizedBox(
                            height: Dim().d32,
                          ),
                          PinCodeTextField(
                            controller: otpCtrl,
                            // errorAnimationController: errorController,
                            appContext: context,
                            enableActiveFill: true,
                            textStyle: Sty().largeText,
                            length: 4,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            // inputFormatters: <TextInputFormatter>[
                            //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            // ],
                            animationType: AnimationType.scale,
                            cursorColor: Clr().primaryColor,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(Dim().d8),
                              fieldWidth: Dim().d68,
                              fieldHeight: Dim().d68,
                              selectedFillColor: Clr().formfieldbg,
                              activeFillColor: Clr().formfieldbg,
                              inactiveFillColor: Clr().formfieldbg,
                              inactiveColor: Clr().lightGrey,
                              activeColor: Clr().primaryColor,
                              selectedColor: Clr().primaryColor,
                            ),
                            animationDuration:
                                const Duration(milliseconds: 200),
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'(.{4,})').hasMatch(value)) {
                                return "";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Center(
                                child: Visibility(
                                  visible: !again,
                                  child: TweenAnimationBuilder<Duration>(
                                      duration: const Duration(seconds: 60),
                                      tween: Tween(
                                          begin: const Duration(seconds: 60),
                                          end: Duration.zero),
                                      onEnd: () {
                                        // ignore: avoid_print
                                        // print('Timer ended');
                                        setState(() {
                                          again = true;
                                        });
                                      },
                                      builder: (BuildContext context,
                                          Duration value, Widget? child) {
                                        final minutes = value.inMinutes;
                                        final seconds = value.inSeconds % 60;
                                        return Column(
                                          children: [
                                            Text(
                                              'Haven’t received the verification code?',
                                              style: Sty()
                                                  .mediumText
                                                  .copyWith(color: Clr().grey),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                "$minutes:$seconds Sec",
                                                textAlign: TextAlign.center,
                                                style: Sty()
                                                    .mediumText
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Clr().black),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                              ),
                              Visibility(
                                visible: again,
                                child: GestureDetector(
                                  onTap: () {
                                    resendOtp();
                                  },
                                  child: Text(
                                    'Re-send code',
                                    style: Sty()
                                        .mediumBoldText
                                        .copyWith(color: Clr().primaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 50,
                            width: 300,
                            child: ElevatedButton(
                                onPressed: () {
                                  RegisterOTP();
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Clr().primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Text(
                                  'Submit',
                                  style: Sty().mediumText.copyWith(
                                        color: Clr().white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  _showSuccessDialog(ctx) {
    AwesomeDialog(
      context: ctx,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.BOTTOMSLIDE,
      alignment: Alignment.centerLeft,
      body: Container(
        padding: EdgeInsets.all(Dim().d4),
        child: Column(
          children: [
            Image.asset('assets/success.png'),
            SizedBox(
              height: 20,
            ),
            Text(
              'OTP verified successfully',
              style: Sty().mediumText.copyWith(
                    color: Clr().black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    ).show();
  }

  // //Api Method
  // void VerifyOTP() async {
  //   //Input
  //   FormData body = FormData.fromMap({
  //     'page_type': "register",
  //     'mobile': widget.smobileCtrl,
  //     'otp': otpCtrl.text,
  //   });
  //   //Output
  //   var result = await STM().post(ctx, Str().sendingOtp, "verify_otp", body);
  //   if (!mounted) return;
  //   var success = result['success'];
  //   if (success) {
  //     STM().redirect2page(
  //       ctx,
  //       PersonalDetails(smobileCtrl: widget.smobileCtrl),
  //     );
  //   } else {
  //     var message = result['message'];
  //     STM().errorDialog(ctx, message);
  //   }
  // }

  void RegisterOTP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'page_type': widget.stypeValue,
      'mobile': widget.smobileCtrl,
      'otp': otpCtrl.text,
      'user_type': widget.signuptype == 'HCP' ? 1 : widget.signuptype == 'Customer' ? 2 : 3,
    });
    //Output
    var result = await STM().postOpen(ctx, Str().verifying, "verify_otp", body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if(widget.stypeValue == 'login'){
        widget.signuptype == 'HCP' ? STM().finishAffinity(ctx, HomeVisit()) : STM().finishAffinity(ctx, Home());
        widget.signuptype == 'HCP' ? sp.setBool('hcplogin', true) : sp.setBool('login', true);
        widget.signuptype == 'HCP' ? sp.setString('hcptoken', result['hcp_token'].toString()) : sp.setString('customerId', result['customer_token']);
        widget.signuptype == 'Retailer' ? STM().finishAffinity(ctx, Home()) : null;
      }else{
        widget.signuptype == 'HCP' ? STM().redirect2page(ctx, createAccount(smobile: widget.smobileCtrl,)) : STM().redirect2page(
          ctx,
          PersonalDetails(smobileCtrl: widget.smobileCtrl),
        );
        widget.signuptype == 'Retailer' ? STM().finishAffinity(ctx, Home()) : null;
      }
      otpCtrl.clear();
      STM().displayToast(message);
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  void resendOtp() async {
    FormData body = FormData.fromMap(
        {'mobile': widget.smobileCtrl, 'page_type': widget.stypeValue});
    var result = await STM().postOpen(ctx, Str().resendotp, 'resend_otp', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        again = false;
      });
      STM().displayToast(message);
    }
  }
}
