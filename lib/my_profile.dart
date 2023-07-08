import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../physical_details.dart';
import '../values/colors.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'log_in.dart';
import 'values/strings.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late BuildContext ctx;
  final _formKey = GlobalKey<FormState>();
  bool again = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  File? imageFile;
  String? profile, usertoken;

  Future datePicker() async {
    DateTime? picked = await showDatePicker(
      context: ctx,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Clr().primaryColor),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      //Disabled past date
      // firstDate: DateTime.now().subtract(Duration(days: 1)),
      // Disabled future date
      // lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        String s = STM().dateFormat('dd-MM-yyyy', picked);
        dobCtrl = TextEditingController(text: s);
      });
    }
  }

  String? GenderValue, pic;
  List<String> genderList = ['Male', 'Female'];
  String t = "0";

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getProfile();
        print(usertoken);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Clr().white,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: Clr().appbarTextColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'My Profile',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
            SizedBox(
              height: Dim().d20,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    height: Dim().d140,
                    width: Dim().d140,
                    decoration: BoxDecoration(
                      color: Clr().lightGrey,
                      border: Border.all(
                        color: Clr().grey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dim().d100),
                      ),
                    ),
                    child: ClipOval(
                      child: imageFile == null
                          ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: pic ??
                                  'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                              placeholder: (context, url) =>
                                  STM().loadingPlaceHolder(),
                            )
                          : Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 2,
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: Clr().primaryColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {
                              _getFromCamera();
                            },
                            child: SvgPicture.asset('assets/cam.svg')),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mobile Number",
                  style: Sty().mediumText.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                // TextFormField(
                //   // controller: mobileCtrl,
                //   keyboardType: TextInputType.name,
                //   decoration: InputDecoration(
                //     filled: true,
                //
                //     fillColor: Clr().lightGrey,
                //     border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         borderSide: BorderSide(color: Clr().transparent)),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Clr().grey, width: 1.0),
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     contentPadding:
                //     EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                //     // label: Text('Enter Your Number'),
                //     hintText: "Name",
                //     suffixIcon: InkWell(
                //       onTap: (){},
                //       child: Padding(
                //           padding:  EdgeInsets.only(right: 15,top: 15,bottom: 15),
                //           child: SvgPicture.asset('assets/editprofile.svg',)
                //       ),
                //     ),
                //     hintStyle: Sty().mediumText.copyWith(
                //       color: Clr().shimmerColor,
                //     ),
                //     counterText: "",
                //   ),
                // ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Clr().grey.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 12,
                        offset: Offset(0, 8), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: mobileCtrl,
                    readOnly: true,
                    onTap: () {
                      updateMobileNumber();
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(Dim().d16),
                        child: SvgPicture.asset('assets/mobileupdate.svg'),
                      ),
                      filled: true,
                      fillColor: Clr().formfieldbg,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Clr().primaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.all(18),
                      // label: Text('Enter Your Number'),
                      hintText: "Enter Mobile Number",
                      counterText: "",
                    ),
                    maxLength: 10,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'([5-9]{1}[0-9]{9})').hasMatch(value)) {
                        return Str().invalidMobile;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),

                SizedBox(
                  height: Dim().d20,
                ),
                Text(
                  "Email ID",
                  style: Sty().mediumText.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Clr().grey.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 12,
                        offset: Offset(0, 8), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email Id is required';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Clr().formfieldbg,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Clr().primaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.all(18),
                      // label: Text('Enter Your Number'),
                      hintText: "Enter Email ID",
                      counterText: "",
                    ),
                  ),
                ),

                SizedBox(
                  height: Dim().d20,
                ),
                Text(
                  "Gender",
                  style: Sty().mediumText.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Clr().grey)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: GenderValue,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 28,
                        color: Clr().grey,
                      ),
                      style: TextStyle(color: Color(0xff787882)),
                      items: genderList.map((string) {
                        return DropdownMenuItem(
                          value: string,
                          child: Text(
                            string,
                            style: TextStyle(
                                color: Color(0xff787882), fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (t) {
                        // STM().redirect2page(ctx, Home());
                        setState(() {
                          GenderValue = t as String;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Text(
                  "Date of birth",
                  style: Sty().mediumText.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                TextFormField(
                  readOnly: true,
                  onTap: () {
                    datePicker();
                  },
                  controller: dobCtrl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Pickup date is required';
                    }
                  },
                  // controller: mobileCtrl,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_month),
                    fillColor: Clr().lightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Clr().grey, width: 0.1),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Clr().grey)),
                    focusColor: Clr().grey,
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('Enter Your Number'),
                    hintText: "Date of birth*",
                    counterText: "",
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    updatProfile();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Update Profile',
                    style: Sty().mediumText.copyWith(
                          color: Clr().white,
                          fontWeight: FontWeight.w600,
                        ),
                  )),
            ),
            SizedBox(
              height: Dim().d20,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    STM().canceldialog(
                        message: 'Are you sure want to delete this account?',
                        funtion: () {
                          deletAccount();
                        },
                        context: ctx);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      side: BorderSide(width: 1, color: Clr().primaryColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Delete my account',
                    style: Sty().mediumText.copyWith(
                        color: Clr().primaryColor, fontWeight: FontWeight.w500),
                  )),
            ),
            SizedBox(
              height: Dim().d20,
            ),
          ],
        ),
      ),
    );
  }

  // get camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        var image = imageFile!.readAsBytesSync();
        profile = base64Encode(image);
      });
    }
  }

  // get profile
  void getProfile() async {
    var result = await STM().getWithTokenUrl(
        ctx, Str().loading, 'get_profile', usertoken, 'customer');
    var success = result['success'];
    if (success) {
      setState(() {
        mobileCtrl = TextEditingController(text: result['customer']['mobile']);
        emailCtrl = TextEditingController(text: result['customer']['email']);
        GenderValue = result['customer']['gender'];
        dobCtrl = TextEditingController(text: result['customer']['dob']);
        pic = result['customer']['profile_image'];
      });
    }
  }

  void deletAccount() async {
    var result = await STM().getWithTokenUrl(
        ctx, Str().deleting, 'delete_profile', usertoken, 'customer');
    var success = result['success'];
    if (success) {
      STM().displayToast('${result['message']}');
      STM().finishAffinity(ctx, SignIn());
    } else {
      STM().errorDialog(ctx, '${result['message']}');
    }
  }

  //Update mobile pop up
  void updateMobileNumber() {
    bool otpsend = false;
    // var updateUserMobileNumberController;
    // updateUserMobileNumberController.text = "";
    // updateUserOtpController.text = "";
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (context) {
          TextEditingController updateUserMobileNumberController =
              TextEditingController();
          TextEditingController updateUserOtpController =
              TextEditingController();
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text("Change Mobile Number",
                  style:
                      Sty().mediumBoldText.copyWith(color: Color(0xff2C2C2C))),
              content: SizedBox(
                height: 120,
                width: MediaQuery.of(ctx).size.width,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: !otpsend,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "New Mobile Number",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller:
                                        updateUserMobileNumberController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Mobile filed is required';
                                      }
                                      if (value.length != 10) {
                                        return 'Mobile digits must be 10';
                                      }
                                    },
                                    maxLength: 10,
                                    decoration: Sty()
                                        .TextFormFieldOutlineStyle
                                        .copyWith(
                                          counterText: "",
                                          hintText: "Enter Mobile Number",
                                          prefixIconConstraints: BoxConstraints(
                                              minWidth: 50, minHeight: 0),
                                          suffixIconConstraints: BoxConstraints(
                                              minWidth: 10, minHeight: 2),
                                          border: InputBorder.none,
                                          // prefixIcon: Icon(
                                          //   Icons.phone,
                                          //   size: iconSizeNormal(),
                                          //   color: primary(),
                                          // ),
                                        ),
                                  ),
                                ),
                              ],
                            )),
                        Visibility(
                            visible: otpsend,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "One Time Password",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: TextFormField(
                                    controller: updateUserOtpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "Enter OTP",
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                              minWidth: 50, minHeight: 0),
                                      suffixIconConstraints:
                                          const BoxConstraints(
                                              minWidth: 10, minHeight: 2),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color(0xff2C2C2C),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: Dim().d8,
                                    ),
                                    Column(
                                      children: [
                                        Visibility(
                                          visible: !again,
                                          child: TweenAnimationBuilder<
                                                  Duration>(
                                              duration:
                                                  const Duration(seconds: 60),
                                              tween: Tween(
                                                  begin: const Duration(
                                                      seconds: 60),
                                                  end: Duration.zero),
                                              onEnd: () {
                                                // ignore: avoid_print
                                                // print('Timer ended');
                                                setState(() {
                                                  again = true;
                                                });
                                              },
                                              builder: (BuildContext context,
                                                  Duration value,
                                                  Widget? child) {
                                                final minutes = value.inMinutes;
                                                final seconds =
                                                    value.inSeconds % 60;
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    "Re-send code in $minutes:$seconds",
                                                    textAlign: TextAlign.center,
                                                    style: Sty().mediumText,
                                                  ),
                                                );
                                              }),
                                        ),
                                        // Visibility(
                                        //   visible: !isResend,
                                        //   child: Text("I didn't receive a code! ${(  sTime  )}",
                                        //       style: Sty().mediumText),
                                        // ),
                                        SizedBox(
                                          height: Dim().d8,
                                        ),
                                        Visibility(
                                          visible: again,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                again = false;
                                              });
                                              resendOtp(
                                                  updateUserMobileNumberController
                                                      .text);
                                              // STM.checkInternet().then((value) {
                                              //   if (value) {
                                              //     sendOTP();
                                              //   } else {
                                              //     STM.internetAlert(ctx, widget);
                                              //   }
                                              // });
                                            },
                                            child: Text(
                                              'Resend OTP',
                                              style: Sty().mediumText,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ]),
                ),
              ),
              elevation: 0,
              actions: [
                Row(
                  children: [
                    Visibility(
                      visible: !otpsend,
                      child: Expanded(
                        child: InkWell(
                          onTap: () async {
                            // API UPDATE START
                            if (_formKey.currentState!.validate()) {
                              SharedPreferences sp =
                                  await SharedPreferences.getInstance();
                              FormData body = FormData.fromMap({
                                'page_type': 'change_mobile',
                                'mobile': updateUserMobileNumberController.text,
                                'user_type': 2,
                              });
                              var result = await STM().postOpen(
                                  ctx, Str().sendingOtp, 'send_otp', body);
                              var success = result['success'];
                              var message = result['message'];
                              if (success) {
                                setState(() {
                                  otpsend = true;
                                });
                              } else {
                                STM().errorDialog(context, message);
                              }
                            }
                            // API UPDATE END
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Clr().primaryColor,
                            ),
                            child: const Center(
                              child: Text(
                                "Send OTP",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: otpsend,
                      child: Expanded(
                        child: InkWell(
                            onTap: () async {
                              // API UPDATE START
                              SharedPreferences sp =
                                  await SharedPreferences.getInstance();
                              FormData body = FormData.fromMap({
                                'otp': updateUserOtpController.text,
                                'mobile': updateUserMobileNumberController.text,
                              });
                              var result = await STM().postWithToken(
                                  ctx,
                                  Str().updating,
                                  'update_number',
                                  body,
                                  usertoken,
                                  'customer');
                              var success = result['success'];
                              var message = result['message'];
                              if (success) {
                                Navigator.pop(ctx);
                              } else {
                                STM().errorDialog(context, message);
                              }
                              setState(() {
                                otpsend = true;
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Clr().primaryColor,
                                ),
                                child: const Center(
                                    child: Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                )))),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Clr().primaryColor,
                              ),
                              child: const Center(
                                  child: Text("Cancel",
                                      style: TextStyle(color: Colors.white))))),
                    ),
                  ],
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ),
          );
        });
  }

  void resendOtp(mobile) async {
    FormData body =
        FormData.fromMap({'mobile': mobile, 'page_type': 'change_mobile'});
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

  // update profile
  void updatProfile() async {
    FormData body = FormData.fromMap({
      'email': emailCtrl.text,
      'gender': GenderValue,
      'dob': dobCtrl.text,
      'profile_image': profile,
    });
    var result = await STM().postWithToken(
        ctx, Str().updating, 'update_profile', body, usertoken, 'customer');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithAffinity(ctx, message, Home());
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
