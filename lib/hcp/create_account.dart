import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../register.dart';
import '../values/colors.dart';
import '../values/styles.dart';
import 'hcppersonalinfo.dart';

class createAccount extends StatefulWidget {
  final String? smobile;

  const createAccount({super.key, this.smobile});

  @override
  State<createAccount> createState() => createAccountState();
}

class createAccountState extends State<createAccount> {
  late BuildContext ctx;
  int? cityValue;
  int? stateValue;
  String? _dropdownError;
  String? _dropdownError1;
  List<dynamic> cityList = [];
  List<dynamic> stateList = [];

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastnameCtrl = TextEditingController();
  TextEditingController emailIdCtrl = TextEditingController();
  String t = "0";

  // String name = "*";
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      getCity();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, SignUp());
        return false;
      },
      child: Scaffold(
        appBar: apbarlayout(ctx),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dim().d32,
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
                    controller: nameCtrl,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'First name is required';
                      }
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
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: Dim().d20, vertical: Dim().d16),
                      hintText: "First Name",
                      hintStyle: Sty().smallText.copyWith(
                            color: Clr().shimmerColor,
                          ),
                      suffix: RichText(
                          text: const TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ))),
                      counterText: "",
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d24,
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
                    controller: lastnameCtrl,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Last name is required';
                      }
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
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: Dim().d20, vertical: Dim().d16),
                      // label: Text('Enter Your Number'),
                      hintText: "Last name",
                      hintStyle:
                          Sty().smallText.copyWith(color: Clr().shimmerColor),
                      suffix: RichText(
                        text: const TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      counterText: "",
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d24,
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
                    controller: emailIdCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email ID is required';
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      // label: Text('Enter Your Number'),
                      hintText: "Email ID",
                      hintStyle: Sty().smallText.copyWith(
                            color: Clr().shimmerColor,
                          ),
                      suffix: RichText(
                        text: const TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      counterText: "",
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d24,
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
                          _dropdownError1 = null;
                          int position = int.parse(stateValue.toString());
                          cityList = stateList[position]['city'];
                          cityValue = null;
                        });
                      },
                    ),
                  ),
                ),
                _dropdownError1 == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding:
                            EdgeInsets.only(left: Dim().d16, top: Dim().d8),
                        child: Text(
                          _dropdownError1 ?? "",
                          style: const TextStyle(color: Colors.red),
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
                          _dropdownError = null;
                        });
                      },
                    ),
                  ),
                ),
                _dropdownError == null
                    ? SizedBox.shrink()
                    : Padding(
                        padding:
                            EdgeInsets.only(left: Dim().d16, top: Dim().d8),
                        child: Text(
                          _dropdownError ?? "",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                SizedBox(
                  height: Dim().d40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(
                          onPressed: () {
                            _validateForm(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Clr().primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text(
                            'Sign Up',
                            style: Sty().mediumText.copyWith(
                                  color: Clr().white,
                                  fontWeight: FontWeight.w600,
                                ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateForm(ctx) {
    bool _isValid = formKey.currentState!.validate();

    if (cityValue == null) {
      setState(() => _dropdownError = "Please select city");
      _isValid = false;
    }
    if (stateValue == null) {
      setState(() {
        _dropdownError1 = "Please select state";
      });
      _isValid = false;
    }
    if (_isValid) {
      createAccount();
    }
  }

  // appbar
  AppBar apbarlayout(ctx) {
    return AppBar(
      backgroundColor: Clr().white,
      leading: InkWell(
        onTap: () {
          STM().finishAffinity(ctx, SignUp());
        },
        child: Icon(
          Icons.arrow_back_rounded,
          color: Clr().appbarTextColor,
        ),
      ),
      centerTitle: true,
      title: Text(
        'Create Account',
        style: Sty().largeText.copyWith(
            color: Clr().appbarTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  // api create account
  void createAccount() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'user_type': 1,
      'first_name': nameCtrl.text,
      'last_name': lastnameCtrl.text,
      'email': emailIdCtrl.text,
      'city_id': cityValue,
      'state_id': stateValue,
      'mobile': widget.smobile,
    });
    var result = await STM().postOpen(
      ctx,
      Str().processing,
      'register',
      body,
    );
    var success = result['success'];
    var message = result['message'];
    if (success) {
      sp.setString('hcpid', result['hcp_id'].toString());
      sp.setBool('hcpaccount', true);
      sp.setString('hcptoken', result['hcp_token'].toString());
      STM().successDialogWithAffinity(ctx, message, hcp_Personalinfo());
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  // get state and city

  void getCity() async {
    var result = await STM().getOpen(ctx, Str().loading, 'get_cities');
    var success = result['success'];
    if(success){
      setState(() {
        stateList = result['cities'];
      });
    }
  }
}
