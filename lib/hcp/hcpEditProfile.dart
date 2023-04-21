import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/strings.dart';
import '../values/styles.dart';
import 'hcpMyprofile.dart';

class EditProfile extends StatefulWidget {
  final List<Map<String, dynamic>>? userdetils;

  const EditProfile({super.key, this.userdetils});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late BuildContext ctx;
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController firstnameCtrl = TextEditingController();
  TextEditingController lastnameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  int? cityValue;
  int? stateValue;
  List<dynamic> cityList = [];
  List<dynamic> stateList = [];

  String? hcptoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      hcptoken = sp.getString('hcptoken') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getCity();
        print(hcptoken);
      }
    });
  }

  @override
  void initState() {
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 0.5,
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
          'Edit Profile',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mobile Number',
                  style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                )),
            SizedBox(
              height: 12,
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
              child: Container(
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
                  keyboardType: TextInputType.number,
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
                    hintText: "Enter mobile number",
                    hintStyle: TextStyle(
                      color: Clr().dottedColor,
                      fontSize: 14,
                    ),
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
            ),
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'First Name',
                  style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                )),
            SizedBox(
              height: 12,
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
              child: Container(
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
                  controller: firstnameCtrl,
                  keyboardType: TextInputType.name,
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
                    hintText: "Enter first name",
                    hintStyle: TextStyle(
                      color: Clr().dottedColor,
                      fontSize: 14,
                    ),
                    counterText: "",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Last Name',
                  style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                )),
            SizedBox(
              height: 12,
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
              child: Container(
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
                  controller: lastnameCtrl,
                  keyboardType: TextInputType.name,
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
                    hintText: "Enter last name",
                    hintStyle: TextStyle(
                      color: Clr().dottedColor,
                      fontSize: 14,
                    ),
                    counterText: "",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email ID',
                  style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                )),
            SizedBox(
              height: 12,
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
              child: Container(
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
                    hintText: "Enter email ID",
                    hintStyle: TextStyle(
                      color: Clr().dottedColor,
                      fontSize: 14,
                    ),
                    counterText: "",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  color: Clr().formfieldbg,
                  boxShadow: [
                    BoxShadow(
                      color: Clr().grey.withOpacity(0.1),
                      spreadRadius: 0.5,
                      blurRadius: 12,
                      offset: Offset(0, 8), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Clr().transparent)),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  value: stateValue,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  hint: Text(
                    'Select State',
                    style: Sty().smallText.copyWith(
                          color: Clr().shimmerColor,
                        ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 28,
                    color: Clr().grey,
                  ),
                  style: TextStyle(color: Clr().black),
                  items: stateList.map((string) {
                    return DropdownMenuItem(
                      value: string['id'],
                      child: Text(
                        string['name'],
                        style: TextStyle(color: Clr().black, fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // STM().redirect2page(ctx, Home());
                    setState(() {
                      stateValue = value as int?;
                      int position = int.parse(stateValue.toString());
                      cityList = stateList[position]['city'];
                      cityValue = null;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: Dim().d24,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Dim().d16, vertical: Dim().d4),
              decoration: BoxDecoration(
                  color: Clr().formfieldbg,
                  boxShadow: [
                    BoxShadow(
                      color: Clr().grey.withOpacity(0.1),
                      spreadRadius: 0.5,
                      blurRadius: 12,
                      offset: Offset(0, 8), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Clr().transparent)),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  value: cityValue,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  hint: Text(
                    'Select City',
                    style: Sty().smallText.copyWith(
                          color: Clr().shimmerColor,
                        ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 28,
                    color: Clr().grey,
                  ),
                  style: TextStyle(color: Clr().black),
                  items: cityList.map((string) {
                    return DropdownMenuItem(
                      value: string['id'],
                      child: Text(
                        string['name'],
                        style: TextStyle(color: Clr().black, fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // STM().redirect2page(ctx, Home());
                    setState(() {
                      cityValue = value as int?;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    updateProfile();
                  },
                  style: ElevatedButton.styleFrom(
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
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  void updateProfile() async {
    FormData body = FormData.fromMap({
      'mobile': mobileCtrl.text,
      'first_name': firstnameCtrl.text,
      'last_name': lastnameCtrl.text,
      'email': emailCtrl.text,
      'state': stateValue,
      'city': cityValue,
    });
    var result = await STM().postWithToken(ctx, Str().processing, 'update_profile', body, hcptoken, 'hcp');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithReplace(ctx, message, MyProfile());
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  // get state and city

  void getCity() async {
    var result = await STM().getOpen(ctx, Str().loading, 'get_cities');
    var success = result['success'];
    if (success) {
      setState(() {
        stateList = result['cities'];
      });
      setState(() {
        mobileCtrl = TextEditingController(
            text: widget.userdetils![0]['mobile'].toString());
        firstnameCtrl = TextEditingController(
            text: widget.userdetils![0]['firstname'].toString());
        lastnameCtrl = TextEditingController(
            text: widget.userdetils![0]['lastname'].toString());
        emailCtrl = TextEditingController(
            text: widget.userdetils![0]['emailid'].toString());
        stateValue = widget.userdetils![0]['state'];
        print(stateValue);
        int position = int.parse(stateValue.toString());
        cityList = stateList[position - 1]['city'];
        cityValue = widget.userdetils![0]['city'];
      });
    }
  }
}
