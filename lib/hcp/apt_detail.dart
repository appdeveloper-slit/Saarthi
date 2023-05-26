import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saarathi/hcp/add_prescription.dart';
import 'package:saarathi/hcp/callpage.dart';
import 'package:saarathi/hcp/hcphome.dart';
import 'package:saarathi/hcp/preview_prescription.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/styles.dart';
import 'imageView.dart';

class AptDetail extends StatefulWidget {
  final Map<String, dynamic> data;
  final String? time;

  const AptDetail(this.data, this.time, {Key? key}) : super(key: key);

  @override
  State<AptDetail> createState() => AptDetailState();
}

class AptDetailState extends State<AptDetail> {
  late BuildContext ctx;
  String? sToken;
  var stypeValue;
  List<dynamic> arrayList = [];
  TextEditingController canCtrl = TextEditingController();
  DateTime now = DateTime.now();
  Map<String, dynamic> v = {};
  File? imageFile;
  String? profile;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sToken = sp.getString('hcptoken') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getReason();
      }
    });
  }

  @override
  void initState() {
    v = widget.data;
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
                    child: Center(
                        child: Text(
                            nameShort(v['patient']['full_name'].toString()),
                            style: Sty().mediumBoldText.copyWith(
                                fontSize: Dim().d52, color: Clr().white)))),
                SizedBox(
                  width: Dim().d20,
                ),
                Expanded(
                  child: Column(
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
                        'Complain : ${v['complain'] ?? ''}',
                        style: Sty().smallText.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
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
                  ),
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
            v['is_reschedule'] == 1
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Appointment Date and Time',
                        style: Sty().mediumText))
                : Container(),
            v['is_reschedule'] == 1
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text('${v['booking_date']} ${DateFormat.jm().format(DateTime.parse('${v['booking_date'].toString()} ${v['slot']['slot']}'))}',
                        style: Sty().mediumText.copyWith(
                            fontSize: Dim().d12,
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xffB7B7B7))),
                  )
                : Container(),
            SizedBox(height: Dim().d12),
            v['is_reschedule'] == 1
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Rescheduled Date and Time',
                        style: Sty()
                            .largeText
                            .copyWith(color: Clr().primaryColor)),
                  )
                : Container(),
            resheduleAndFirstBooking(),
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
                    onPressed: () async {
                      await Permission.camera.request();
                      await Permission.microphone.request();
                      getToken();
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
            v['status'].toString() == "2"
                ? Container()
                : v['status'].toString() == "1"
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(top: Dim().d20),
                        child: CancelButton(),
                      ),
            //When apt is complete , apt type is online & prescription not added
            // if (v['status'].toString() == "2" &&
            //         v['appointment_type'].toString() == "1" &&
            //         v['is_prescription'] == true)
            v['is_prescription']
                ? Padding(
                    padding: EdgeInsets.only(top: Dim().d20),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: Dim().d300,
                        child: ElevatedButton(
                          style: Sty().primaryButton,
                          onPressed: () async {
                            v['prescription'][0]['type'] == "2"
                                ? STM().redirect2page(
                                    ctx,
                                    ImagView(
                                      image: v['prescription'][0]['pdf_path'],
                                    ))
                                : await launchUrl(
                                    Uri.parse(v['prescription'][0]['pdf_path']),
                                    mode: LaunchMode.externalApplication,
                                  );
                          },
                          child: Text(
                            'View Prescription',
                            style: Sty().largeText.copyWith(
                                  color: Clr().white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            //When apt is complete , apt type is online & prescription not added
            // if (v['status'].toString() == "2" &&
            //         v['appointment_type'].toString() == "1" &&
            //         v['prescription'] == [])
            v['cancel_reason'] == null &&
                    v['status'] == '1' &&
                    v['is_prescription'] == false
                ? Padding(
                    padding: EdgeInsets.only(top: Dim().d20),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: Dim().d300,
                        child: ElevatedButton(
                          style: Sty().primaryButton,
                          onPressed: () {
                            v['cancel_reason'] == null &&
                                    v['status'] == '1' &&
                                    v['is_prescription'] == false
                                ? _addPrescriptionDialog()
                                : STM().redirect2page(
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
                  )
                : Container(),
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
                                  complete(v['appointment_type']);
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
  void complete(type) async {
    //Input
    FormData body = FormData.fromMap({
      'type': type,
      'appointment_id': v['id'],
    });
    //Output
    var result = await STM().postWithToken(
        ctx, Str().loading, "change_appointment_status", body, sToken, 'hcp');
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      //   if (v['appointment_type'].toString() == "1") {
      //     STM().successDialogWithReplace(
      //       ctx,
      //       message,
      //       AddPrescription(
      //         {
      //           'id': v['id'],
      //           'apt_id': v['appointment_type'],
      //         },
      //       ),
      //     );
      //   } else {
      //     setState(() {
      //       v['status'] = "1";
      //     });
      //     STM().successDialogWithAffinity(
      //       ctx,
      //       message,
      //       HomeVisit(),
      //     );
      //   }
      // } else {
      //   var message = result['message'];
      //   STM().errorDialog(ctx, message);
      // }
      STM().back2Previous(ctx);
      _addPrescriptionDialog();
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  String nameShort(name) {
    return name.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase();
  }

  // get reasons
  void getReason() async {
    var result =
        await STM().getWithoutDialogToken(ctx, 'get_reason', sToken, 'hcp');
    setState(() {
      arrayList = result['reasons'];
    });
  }

  // Api method
  void getToken() async {
    //Input
    FormData body = FormData.fromMap({
      'customer_id': v['customer_id'],
    });
    //Output
    var result = await STM()
        .postWithToken(ctx, Str().loading, "agora/token", body, sToken, 'hcp');
    if (!mounted) return;
    var error = result['success'];
    if (error) {
      Map<String, dynamic> map = {
        'id': v['id'],
        'name': v['customer']['name'],
        'customer_id': v['customer_id'],
        'channel': result['channel'],
        'token': result['token'],
      };
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(map),
        ),
      );
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  // appointment cancel
  void AppointmentCancel(id) async {
    FormData data = FormData.fromMap({
      'appointment_id': id,
      'reason': canCtrl.text.isEmpty ? stypeValue : canCtrl.text,
    });
    var result = await STM().postWithToken(
        ctx, Str().processing, 'cancel_appointment', data, sToken, 'hcp');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithReplace(ctx, message, HomeVisit());
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  // Cancel appointment and condition is if before 5 minutes slot time can't cancel appointment( appintment 18:00 user can't cancel appoitmnet 17:55)
  Widget CancelButton() {
    DateTime slotDate =
        DateTime.parse('${v['booking_date']} ${v['slot']['slot']}');
    DateTime startTime =
        slotDate.subtract(Duration(minutes: int.parse(widget.time.toString())));
    DateTime endTime = startTime.add(Duration(minutes: 5));
    // Duration diff = beforeTime.difference(afterTime);
    now.isAfter(startTime) && now.isBefore(endTime)
        ? print('cancel not show')
        : print('cancel button show');
    return now.isAfter(startTime)
        ? Container()
        : Center(
            child: SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    _CancelDialog();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Cancel Appointment',
                    style: Sty().mediumText.copyWith(
                          color: Clr().white,
                          fontWeight: FontWeight.w600,
                        ),
                  )),
            ),
          );
  }

  _CancelDialog() {
    return showDialog(
        context: context,
        builder: (index) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setstate) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dim().d12),
                      border: Border.all(color: Clr().black),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                      child: DropdownButton(
                        value: stypeValue,
                        isExpanded: true,
                        hint: Text('Select Type',
                            style: Sty()
                                .mediumText
                                .copyWith(color: Clr().shimmerColor)),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 28,
                          color: Clr().grey,
                        ),
                        underline: Container(),
                        style: TextStyle(color: Color(0xff787882)),
                        items: arrayList.map((string) {
                          return DropdownMenuItem(
                            value: string['name'],
                            child: Text(
                              string['name'],
                              style: const TextStyle(
                                  color: Color(0xff787882), fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (t) {
                          setstate(() {
                            stypeValue = t!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: Dim().d12),
                  stypeValue == 'Other'
                      ? TextFormField(
                          decoration: Sty()
                              .TextFormFieldOutlineDarkStyle
                              .copyWith(
                                  hintText: 'Enter The Reason',
                                  hintStyle: Sty()
                                      .mediumText
                                      .copyWith(color: Clr().hintColor)),
                          style: Sty().mediumText,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: canCtrl,
                        )
                      : Container(),
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d44),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Clr().primaryColor)),
                      onPressed: () {
                        AppointmentCancel(v['id']);
                      },
                      child: Center(child: Text('Submit'))),
                )
              ],
            );
          });
        });
  }

  _addPrescriptionDialog() {
    return showDialog(
        context: context,
        builder: (index) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setstate) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: Dim().d12),
              title: Text(
                'Select Prescription Type:-',
                style: Sty().mediumBoldText,
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      _getFromCamera();
                      STM().back2Previous(ctx);
                    },
                    child: Container(
                        height: Dim().d60,
                        decoration: BoxDecoration(
                          color: Clr().primaryColor,
                          borderRadius: BorderRadius.circular(Dim().d12),
                          border: Border.all(color: Clr().black),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(Dim().d8),
                          child: Text(
                            'Upload Prescription',
                            style:
                                Sty().mediumText.copyWith(color: Clr().white),
                          ),
                        )),
                  )),
                  SizedBox(width: Dim().d4),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      STM().redirect2page(
                        ctx,
                        AddPrescription(
                          {
                            'id': v['id'],
                            'apt_id': v['appointment_type'],
                          },
                        ),
                      );
                    },
                    child: Container(
                        height: Dim().d60,
                        decoration: BoxDecoration(
                          color: Clr().primaryColor,
                          borderRadius: BorderRadius.circular(Dim().d12),
                          border: Border.all(color: Clr().black),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(Dim().d8),
                            child: Text(
                              'Create Prescription',
                              style:
                                  Sty().mediumText.copyWith(color: Clr().white),
                            ),
                          ),
                        )),
                  )),
                ],
              ),
            );
          });
        });
  }

  // reshedule and first time booking
  Widget resheduleAndFirstBooking() {
    return v['is_reschedule'] == 1
        ? Card(
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
                            color: Clr().white, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'BOOKING DATE',
                        style: Sty().mediumText.copyWith(
                            color: Clr().white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Container(
                    height: 50,
                    width: 1.5,
                    decoration: BoxDecoration(color: Color(0xffECFFDB)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateFormat.jm().format(DateTime.parse('${v['reschedule_date'].toString()} ${v['reschedule_slot']['slot']}'))}',
                        style: Sty().mediumText.copyWith(
                            color: Clr().white, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: Dim().d8,
                      ),
                      Text(
                        v['reschedule_date'],
                        style: Sty().mediumText.copyWith(
                            color: Clr().white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : Card(
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
                            color: Clr().white, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'BOOKING DATE',
                        style: Sty().mediumText.copyWith(
                            color: Clr().white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Container(
                    height: 50,
                    width: 1.5,
                    decoration: BoxDecoration(color: Color(0xffECFFDB)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateFormat.jm().format(DateTime.parse('${v['booking_date'].toString()} ${ v['slot']['slot']}'))}',
                        style: Sty().mediumText.copyWith(
                            color: Clr().white, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: Dim().d8,
                      ),
                      Text(
                        v['booking_date'],
                        style: Sty().mediumText.copyWith(
                            color: Clr().white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }

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
        profile!.isNotEmpty ? addData() : null;
      });
    }
  }

  //Api method
  void addData() async {
    //Input
    FormData body = FormData.fromMap({
      'appointment_id': v['id'],
      'type': 2,
      'image': profile,
    });
    //Output
    var result = await STM().postWithToken(
        ctx, Str().loading, "add_prescription", body, sToken, 'hcp');
    var error = result['success'];
    var message = result['message'];
    if (error) {
      STM().successDialogWithAffinity(ctx, message, HomeVisit());
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
