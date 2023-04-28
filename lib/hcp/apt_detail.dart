import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarathi/hcp/add_prescription.dart';
import 'package:saarathi/hcp/callpage.dart';
import 'package:saarathi/hcp/hcphome.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/styles.dart';

class AptDetail extends StatefulWidget {
  final Map<String, dynamic> data;

  const AptDetail(this.data, {Key? key}) : super(key: key);

  @override
  State<AptDetail> createState() => AptDetailState();
}

class AptDetailState extends State<AptDetail> {
  late BuildContext ctx;
  String? sToken;
  Map<String, dynamic> v = {};

  @override
  void initState() {
    v = widget.data;
    getSession();
    super.initState();
  }

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sToken = sp.getString('hcptoken') ?? '';
    });
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
            Icons.arrow_back,
            color: Clr().black,
          ),
        ),
        centerTitle: true,
        title: Text(
          '${v['patient']['full_name']}',
          style: Sty().largeText.copyWith(color: Clr().black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    width: Dim().d100,
                    height: Dim().d100,
                    decoration: BoxDecoration(
                      color: const Color(0x8080C342),
                      borderRadius: BorderRadius.circular(Dim().d52),
                      // border: Border.all(color: Clr().hintColor)
                    ),
                    child: Center(child: Text(nameShort(v['patient']['full_name'].toString()),style: Sty().mediumBoldText.copyWith(fontSize: Dim().d52,color: Clr().white)))),
                SizedBox(
                  width: Dim().d20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Appointment ID : ',
                          style: Sty().smallText,
                        ),
                        Text(
                          '${v['appointment_uid']}',
                          style: Sty().smallText.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Color(0xffFFC107),
                              ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Mr. ${v['patient']['full_name']}',
                      style: Sty().smallText,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          v['patient']['gender'],
                          style: Sty().smallText.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(
                          width: Dim().d20,
                        ),
                        Text(
                          'Age : ${v['patient']['age']}',
                          style: Sty().smallText.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Dim().d8,
                    ),
                    Text(
                      v['appointment_type'] == "1"
                          ? 'Online Consultation'
                          : v['appointment_type'] == "2"
                              ? 'OPD'
                              : 'Home Visit',
                      style: Sty().smallText.copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            const Divider(),
            SizedBox(
              height: 8,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Clr().primaryColor,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Dim().d16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BOOKING TIME',
                          style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w600, color: Clr().white),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'BOOKING DATE',
                          style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w600, color: Clr().white),
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      decoration: BoxDecoration(color: Clr().white),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${v['slot']['slot']}',
                          style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w600, color: Clr().white),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${v['booking_date']}',
                          style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w600, color: Clr().white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (v['appointment_type'].toString() == "3")
              SizedBox(
                height: Dim().d12,
              ),
            if (v['appointment_type'].toString() == "3")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Patient Address",
                    style: Sty().largeText.copyWith(
                      color: Clr().primaryColor,
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Container(
                      color: Clr().white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                              Dim().d12,
                            ),
                            child: Html(
                              data: '${v['address']}',
                              shrinkWrap: true,
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: EdgeInsets.zero,
                                  fontFamily: 'Regular',
                                  letterSpacing: 0.5,
                                  color: Clr().black,
                                  fontSize: FontSize(16.0),
                                ),
                              },
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: EdgeInsets.only(
                              left: Dim().d12,
                              right: Dim().d12,
                              bottom: Dim().d12,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/accent_call.svg",
                                  width: Dim().d32,
                                ),
                                SizedBox(
                                  width: Dim().d8,
                                ),
                                Expanded(
                                  child: Text(
                                    "Contact No : ${v['contact_number']}",
                                    style: Sty().smallText,
                                  ),
                                ),
                                SizedBox(
                                  width: Dim().d4,
                                ),
                                InkWell(
                                  onTap: () {
                                    STM().openDialer(
                                        v['contact_number'].toString());
                                  },
                                  child: SvgPicture.asset(
                                    "assets/dial_call.svg",
                                    height: Dim().d32,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            //When apt type is online & apt is pending
            if (v['status'].toString() == "0" &&
                v['appointment_type'].toString() == "1")
              SizedBox(
                height: Dim().d20,
              ),
            //When apt type is online & apt is pending
            if (v['status'].toString() == "0" &&
                v['appointment_type'].toString() == "1")
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      // STM().redirect2page(ctx, PersonalInfo());
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Video Call',
                      style: Sty().mediumText.copyWith(
                        color: Clr().white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
            //When apt is complete , apt type is online & prescription not added
            if (v['status'].toString() == "1" &&
                v['appointment_type'].toString() == "1" &&
                v['is_prescription']
                ? true
                : v['is_prescription'])
              SizedBox(
                height: Dim().d20,
              ),
            //When apt is complete , apt type is online & prescription not added
            if (v['status'].toString() == "1" &&
                v['appointment_type'].toString() == "1" &&
                v['is_prescription']
                ? true
                : v['is_prescription'])
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: Dim().d300,
                  child: ElevatedButton(
                    style: Sty().primaryButton,
                    onPressed: () {
                      STM().redirect2page(
                          ctx,
                          AddPrescription(
                            {
                              'id': v['id'],
                              'apt_id': v['appointment_type'],
                            },
                          ));
                    },
                    child: Text(
                      'Add Prescription',
                      style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                    ),
                  ),
                ),
              ),
            if (v['status'].toString() == "0")
              const SizedBox(
                height: 30,
              ),
            //When apt is pending
            if (v['status'].toString() == "0")
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Clr().white,
                            contentPadding: EdgeInsets.all(
                              Dim().pp,
                            ),
                            title: Text(
                              "Confirmation",
                              style: Sty().largeText.copyWith(
                                color: Clr().errorRed,
                              ),
                            ),
                            content: Text(
                              "Are you sure you want to complete?",
                              style: Sty().smallText,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  complete();
                                },
                                child: Text(
                                  "Yes",
                                  style: Sty()
                                      .smallText
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  STM().back2Previous(ctx);
                                },
                                child: Text(
                                  "No",
                                  style: Sty()
                                      .smallText
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Complete Appointment',
                      style: Sty().mediumText.copyWith(
                        color: Clr().white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum ',
              style: Sty().smallText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Contact Support',
              style: Sty().mediumText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
  //Api method
  void complete() async {
    //Input
    FormData body = FormData.fromMap({
      'type': v['appointment_type'],
      'appointment_id': v['id'],
    });
    //Output
    var result = await STM().postWithToken(
        ctx, Str().loading, "change_appointment_status", body, sToken, 'hcp');
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if (v['appointment_type'].toString() == "1") {
        STM().successDialogWithReplace(
          ctx,
          message,
          AddPrescription(
            {
              'id': v['id'],
              'apt_id': v['appointment_type'],
            },
          ),
        );
      } else {
        setState(() {
          v['status'] = "1";
        });
        STM().successDialogWithAffinity(
          ctx,
          message,
          HomeVisit(),
        );
      }
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  String nameShort(name) {
    return name.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase();
  }

  //Api method
  // void getToken() async {
  //   //Input
  //   FormData body = FormData.fromMap({
  //     'doctor_id': sID,
  //     'customer_id': v['customer_id'],
  //   });
  //   //Output
  //   var result =
  //   await STM().post(ctx, Str().loading, "doctor/agora/token", body);
  //   if (!mounted) return;
  //   var error = result['error'];
  //   if (!error) {
  //     Map<String, dynamic> map = {
  //       'id': sID,
  //       'name': v['patient_name'],
  //       'customer_id': v['customer_id'],
  //       'channel': result['channel'],
  //       'token': result['token'],
  //     };
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CallPage(map),
  //       ),
  //     );
  //   } else {
  //     var message = result['message'];
  //     STM().errorDialog(ctx, message);
  //   }
  // }
}
