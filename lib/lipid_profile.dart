import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/lipid_profile_history.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'values/colors.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class LipidProfile extends StatefulWidget {
  @override
  State<LipidProfile> createState() => _LipidProfileState();
}

class _LipidProfileState extends State<LipidProfile> {
  late BuildContext ctx;
  var date;
  var value;
  String? usertoken;
  bool loading = false;
  TextEditingController valueCtrl = TextEditingController();
  TextEditingController valueCtrl2 = TextEditingController();
  TextEditingController valueCtrl3 = TextEditingController();
  TextEditingController valueCtrl4 = TextEditingController();

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getLiquid();
        print(usertoken);
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
            color: Clr().black,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Lipid Profile',
          style: Sty()
              .largeText
              .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              color: Clr().formfieldbg,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Clr().borderColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(Dim().d16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0.7,
                                  backgroundColor: Color(0xff616FEC),
                                  side: BorderSide(color: Clr().borderColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                              onPressed: () {
                                // STM().redirect2page(ctx, HealthMatrix());
                              },
                              child:
                                  SvgPicture.asset('assets/lipid.svg')),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lipid Profile',
                              style: Sty().mediumText.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            if(date != null)
                            Text(
                              '${DateFormat('dd MMMM yyyy').format(DateTime.parse(date.toString()))}',
                              style: Sty().smallText.copyWith(
                                  color: Clr().grey,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AHDL',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '${value['blood_cholesterol'].toString()}',
                          style: Sty()
                              .smallText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ALDL',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '${value['ldl_cholesterol'].toString()}',
                          style: Sty()
                              .smallText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CHOL',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '323 mg/dL',
                          style: Sty()
                              .smallText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TGL',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '1233 mg/dL',
                          style: Sty()
                              .smallText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Total blood Cholesterol',
              style: Sty()
                  .mediumText
                  .copyWith(color: Clr().black, fontWeight: FontWeight.w400),
            ),
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
              child: TextFormField(
                // controller: mobileCtrl,

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
                  hintText: "Normal Range 100-199",
                  hintStyle: TextStyle(color: Clr().hintColor,fontSize: 14),
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
            SizedBox(height: 20,),
            Text(
              'LDL Cholesterol',
              style: Sty()
                  .mediumText
                  .copyWith(color: Clr().black, fontWeight: FontWeight.w400),
            ),
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
              child: TextFormField(
                // controller: mobileCtrl,

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
                  hintText: "Normal Range  50-99",
                  hintStyle: TextStyle(color: Clr().hintColor,fontSize: 14),
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


            SizedBox(height: 20,),
            Text(
              'HDL Cholesterol',
              style: Sty()
                  .mediumText
                  .copyWith(color: Clr().black, fontWeight: FontWeight.w400),
            ),
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
              child: TextFormField(
                // controller: mobileCtrl,

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
                  hintText: "HDL Cholesterol",
                  hintStyle: TextStyle(color: Clr().hintColor,fontSize: 14),
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

            SizedBox(height: 20,),
            Text(
              'Triglycerides',
              style: Sty()
                  .mediumText
                  .copyWith(color: Clr().black, fontWeight: FontWeight.w400),
            ),
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
              child: TextFormField(
                // controller: mobileCtrl,

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
                  hintText: "Normal Range  75-149",
                  hintStyle: TextStyle(color: Clr().hintColor,fontSize: 14),
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
              height: 30,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      // STM().redirect2page(ctx, HomeVisitAptDetails());
                      // if (formKey.currentState!
                      //     .validate()) {
                      //   STM()
                      //       .checkInternet(
                      //       context, widget)
                      //       .then((value) {
                      //     if (value) {
                      //       sendOtp();
                      //     }
                      //   });
                      // }
                    },
                    style: ElevatedButton.styleFrom( elevation: 0,
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Submit',
                      style: Sty().mediumText.copyWith(
                            color: Clr().white,
                            fontWeight: FontWeight.w600,
                          ),
                    )),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                STM().redirect2page(ctx, LipidProfileHistory());
              },
              child: Center(
                child: Text(
                  'View History',
                  style: Sty()
                      .smallText
                      .copyWith(color: Clr().primaryColor, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: Dim().d40,
            ),
            Table(
              border: TableBorder.all(color: Color(0xff189392),borderRadius: BorderRadius.circular(5)),
              children: const [
                TableRow(

                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "TEST",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "REF INTERVAL",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ]),
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "AHDL",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "40-60",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),

                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "ALDL",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "0-99",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "CHOL",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "0-200",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "TGL",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "0.55 - 1.30",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: Dim().d12,
            ),
          ],
        ),
      ),
    );
  }
  // get hba1c
  void postLiquid() async {
    FormData body = FormData.fromMap({
      'blood_cholesterol': valueCtrl.text,
      'ldl_cholesterol': valueCtrl2.text,
      'hdl_cholesterol':valueCtrl3.text,
      'triglycerides': valueCtrl4.text,
    });
    var result = await STM().postWithTokenWithoutDailog(
        ctx, 'add_lipid_profile', body, usertoken, 'customer');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      getLiquid();
      STM().displayToast(message);
      valueCtrl.clear();
      valueCtrl2.clear();
      valueCtrl3.clear();
      valueCtrl4.clear();
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getLiquid() async {
    FormData body = FormData.fromMap({});
    var result = await STM().postWithTokenWithoutDailog(
        ctx, 'get_lipid_profile', body, usertoken, 'customer');
    setState(() {
      value = result;
      date = result['date']['updated_at'];
    });
  }
}
