import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'manage/static_method.dart';
import 'otp.dart';
import 'register.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late BuildContext ctx;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();
  List<String> arrayList = ['HCP', 'Customer','Retailer'];
  String? stypeValue;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        backgroundColor: Clr().white,
        body: SizedBox(
          height: MediaQuery.of(ctx).size.height,
          child: Form(
            key: formKey,
            child: Stack(
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
                      padding: EdgeInsets.only(top: Dim().d260),
                      child: Container(
                        height: 600.0,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Clr().grey.withOpacity(0.1),
                                spreadRadius: 0.1,
                                blurRadius: 12,
                                offset:
                                    Offset(0, 0), // changes position of shadow
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
                              const SizedBox(
                                height: 40,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: Sty().largeText.copyWith(
                                      color: Clr().primaryColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: Dim().d8,
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Enter your mobile number',
                                    style: Sty().smallText.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  )),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dim().d16, vertical: Dim().d4),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Clr().grey.withOpacity(0.1),
                                        spreadRadius: 0.5,
                                        blurRadius: 12,
                                        offset: Offset(
                                            0, 8), // changes position of shadow
                                      ),
                                    ],
                                    color: Clr().formfieldbg,
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Clr().transparent)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<String>(
                                    value: stypeValue,
                                    isExpanded: true,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Select type';
                                      }
                                    },
                                    decoration: Sty()
                                        .textFieldOutlineStyle
                                        .copyWith(
                                            contentPadding: EdgeInsets.zero,
                                            errorBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none),
                                    hint: Text('Select Type',
                                        style: Sty()
                                            .mediumText
                                            .copyWith(color: Clr().black)),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 28,
                                      color: Clr().grey,
                                    ),
                                    style: const TextStyle(
                                        color: Color(0xff787882)),
                                    items: arrayList.map((String string) {
                                      return DropdownMenuItem<String>(
                                        value: string,
                                        child: Text(
                                          string,
                                          style: const TextStyle(
                                              color: Color(0xff787882),
                                              fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (t) {
                                      // STM().redirect2page(ctx, Home());
                                      setState(() {
                                        stypeValue = t!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dim().d20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Clr().grey.withOpacity(0.1),
                                      spreadRadius: 0.5,
                                      blurRadius: 12,
                                      offset: Offset(
                                          0, 8), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: mobileCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Clr().formfieldbg,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Clr().primaryColor,
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.all(18),
                                    // label: Text('Enter Your Number'),
                                    hintText: "Mobile Number",
                                    counterText: "",
                                  ),
                                  maxLength: 10,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r'([5-9]{1}[0-9]{9})')
                                            .hasMatch(value)) {
                                      return Str().invalidMobile;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: Dim().d40,
                              ),
                              SizedBox(
                                height: 50,
                                width: 300,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        sendOTP();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Clr().primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Text(
                                      'Send OTP',
                                      style: Sty().mediumText.copyWith(
                                            color: Clr().white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    )),
                              ),
                              SizedBox(
                                height: Dim().d40,
                              ),
                              InkWell(
                                onTap: () {
                                  STM().redirect2page(ctx, SignUp());
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: "Don’t have an account? ",
                                    style: Sty().smallText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff2D2D2D),
                                        ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Sign Up',
                                        style: Sty().mediumText.copyWith(
                                            color: Clr().accentColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // Api Method
  void sendOTP() async {
    //Input
    FormData body = FormData.fromMap({
      'page_type': "login",
      'mobile': mobileCtrl.text,
      'user_type': stypeValue == 'HCP' ? 1 : stypeValue == 'Customer' ? 2 : 3,
    });
    //Output
    var result = await STM().postOpen(ctx, Str().sendingOtp, "send_otp", body);
    if (!mounted) return;
    var success = result['success'];
    if (success) {
      STM().redirect2page(
        ctx,
        Verification("login", mobileCtrl.text, stypeValue!),
      );
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }
}
