import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'log_in.dart';
import 'manage/static_method.dart';
import 'otp.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late BuildContext ctx;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();
  List<String> arrayList = ['HCP', 'Customer','Retailer'];
  String t = "0";
  String? stypeValue;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Clr().white,
        body: Form(
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
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
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
                              Padding(
                                padding: EdgeInsets.only(
                                    top: Dim().d16, bottom: Dim().d8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.left,
                                    style: Sty().largeText.copyWith(
                                        color: Clr().primaryColor,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: Dim().d32),
                                child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        'Fill the detail to create account')),
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
                                        style: Sty().mediumText.copyWith(
                                            color: Clr().shimmerColor)),
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
                                    contentPadding: EdgeInsets.all(18),
                                    // label: Text('Enter Your Number'),
                                    hintText: "Mobile Number",
                                    hintStyle: Sty()
                                        .mediumText
                                        .copyWith(color: Clr().shimmerColor),
                                    counterText: "",
                                  ),
                                  maxLength: 10,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Mobile number is required';
                                    }
                                    if (value.length != 10) {
                                      return 'mobile number must be 10 digits long';
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                height: 50,
                                width: 300,
                                child: ElevatedButton(
                                    onPressed: () {
                                      // STM().redirect2page(ctx, Verification());
                                      if (formKey.currentState!.validate()) {
                                        STM()
                                            .checkInternet(context, widget)
                                            .then((value) {
                                          if (value) {
                                            register();
                                          }
                                        });
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
                                height: 30,
                              ),
                              InkWell(
                                onTap: () {
                                  STM().redirect2page(ctx, SignIn());
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: "Already have an account? ",
                                    style: Sty().smallText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff2D2D2D),
                                        ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Sign In',
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
                  )),
            ],
          ),
        ));
  }

  //Api Method
  void register() async {
    //Input
    FormData body = FormData.fromMap({
      'page_type': "register",
      'mobile': mobileCtrl.text,
      'user_type': stypeValue == 'HCP' ? 1 : stypeValue == 'Customer' ? 2 : 3,
    });
    //Output
    var result = await STM().postOpen(ctx, Str().sendingOtp, "send_otp", body);
    if (!mounted) return;
    var message = result['message'];
    var success = result['success'];
    if (success) {
      STM().redirect2page(
        ctx,
        // Verification("register", mobileCtrl.text.toString()),
        Verification(
          'register',
          mobileCtrl.text,
          stypeValue!
        ),
      );
      STM().displayToast(message);
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }
}
