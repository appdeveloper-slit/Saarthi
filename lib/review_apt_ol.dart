import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'review_apt_call.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class OnlineConsultation extends StatefulWidget {
  final dynamic onlineDetails;
  final String? reshedule;

  const OnlineConsultation({super.key, this.onlineDetails, this.reshedule});

  @override
  State<OnlineConsultation> createState() => _OnlineConsultationState();
}

class _OnlineConsultationState extends State<OnlineConsultation> {
  late BuildContext ctx;
  String? usertoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        // getHome();
        print(widget.onlineDetails);
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
    return WillPopScope(
      onWillPop: () async {
        STM().back2Previous(ctx);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        backgroundColor: Clr().white,
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
            'Review Appointment',
            style: Sty().largeText.copyWith(
                color: Clr().appbarTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: Dim().d56,
                      backgroundImage: NetworkImage(
                          widget.onlineDetails[0]['hcpprofilepic'].toString()),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr.${widget.onlineDetails[0]['hcpname'].toString()}',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.onlineDetails[0]['speciality'].toString(),
                          style: Sty()
                              .smallText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              const Divider(),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Card(
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
                                  color: Clr().white,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'BOOKING DATE',
                              style: Sty().mediumText.copyWith(
                                  color: Clr().white,
                                  fontWeight: FontWeight.w600),
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
                              DateFormat.jm().format(DateTime.parse(
                                  '${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.onlineDetails[0]['bookingdate'].toString()))} ${widget.onlineDetails[0]['bookingtime'].toString()}')),
                              style: Sty().mediumText.copyWith(
                                  color: Clr().white,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: Dim().d8,
                            ),
                            Text(
                              DateFormat('d MMM y').format(DateTime.parse(widget
                                  .onlineDetails[0]['bookingdate']
                                  .toString())),
                              style: Sty().mediumText.copyWith(
                                  color: Clr().white,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Text(
                  'Appointment type',
                  style: Sty().largeText.copyWith(
                      fontWeight: FontWeight.w600, color: Clr().primaryColor),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Text(
                  'Online Consultation',
                  style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Text(
                  'Patient Details',
                  style: Sty().largeText.copyWith(
                      fontWeight: FontWeight.w600, color: Clr().primaryColor),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Text(
                  widget.onlineDetails[0]['patientname'].toString(),
                  style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Text(
                  'Age : ${widget.onlineDetails[0]['patientage'].toString()} Years',
                  style: Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        // controller: mobileCtrl,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Clr().formfieldbg,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Clr().transparent)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Clr().primaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          // label: Text('Enter Your Number'),
                          hintText: "Enter coupon code",
                          hintStyle: Sty().mediumText.copyWith(
                              color: Clr().shimmerColor, fontSize: 14),
                          counterText: "",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      height: 46,
                      width: 100,
                      child: ElevatedButton(
                          onPressed: () {
                            // STM().redirect2page(ctx, AddNewPatient());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Clr().primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Text(
                            'APPLY',
                            style: Sty().smallText.copyWith(
                                color: Clr().white,
                                fontWeight: FontWeight.w600),
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'View all coupons',
                    style: Sty()
                        .smallText
                        .copyWith(fontSize: 12, color: Clr().primaryColor),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              widget.reshedule == 'yes'
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                          child: Text(
                            'Payment Details',
                            style: Sty().largeText.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Clr().primaryColor),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Consultation Fee',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '₹ ${widget.onlineDetails[0]['charges'].toString()}',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'GST',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '₹ ${widget.onlineDetails[0]['gst'].toString()}',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 4,
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         'Discount',
                        //         style:
                        //             Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                        //       ),
                        //       Text(
                        //         '₹90',
                        //         style:
                        //             Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount Payable',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '₹ ${widget.onlineDetails[0]['total'].toString()}',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 30,
              ),
              widget.reshedule == 'yes'
                  ? Padding(
                padding:  EdgeInsets.only(bottom: Dim().d12),
                child: Center(
                  child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                        onPressed: () {
                          // STM().redirect2page(ctx, HomeVisitConsultation());
                          resheduleAppoitnment();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Clr().primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Text(
                          'Reschedule Appointment',
                          style: Sty().smallText.copyWith(
                              color: Clr().white,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
              )
                  : Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Clr().grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 12,
                              offset:
                                  Offset(12, 0.5), // changes position of shadow
                            ),
                          ],
                          color: Clr().primaryColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dim().d24, vertical: Dim().d8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '₹ ${widget.onlineDetails[0]['total'].toString()}',
                                  style: Sty().mediumText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Clr().white),
                                ),
                                Text(
                                  widget.reshedule == 'yes'
                                      ? 'paid'
                                      : 'Total Payable',
                                  style: Sty().smallText.copyWith(
                                      fontWeight: widget.reshedule == 'yes'
                                          ? FontWeight.w900
                                          : FontWeight.w400,
                                      color: Clr().white),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                              width: 100,
                              child: ElevatedButton(
                                  onPressed: () {
                                    widget.onlineDetails[0]['appointment_id'] !=
                                            null
                                        ? resheduleAppoitnment()
                                        : addAppoinment();
                                    // STM().redirect2page(ctx, TeleCallConsultation());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Clr().white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  child: Text(
                                    'Confirm',
                                    style: Sty().smallText.copyWith(
                                        color: Clr().primaryColor,
                                        fontWeight: FontWeight.w600),
                                  )),
                            )
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  // add appoinment
  void addAppoinment() async {
    FormData body = FormData.fromMap({
      'hcp_user_id': widget.onlineDetails[0]['hcpuserid'],
      'slot_id': widget.onlineDetails[0]['slotid'],
      'booking_date': DateFormat('yyyy-MM-dd').format(
          DateTime.parse(widget.onlineDetails[0]['bookingdate'].toString())),
      'address': '',
      'contact_number': '',
      'appointment_type': 1,
      'patient_id': widget.onlineDetails[0]['patientid'],
      'consultation_fee': widget.onlineDetails[0]['charges'],
      'gst': widget.onlineDetails[0]['gst'],
      'discount': '',
      'total_amount': widget.onlineDetails[0]['total'],
      'complain':widget.onlineDetails[0]['complain'],
    });
    var result = await STM().postWithToken(
        ctx, Str().processing, 'add_appointment', body, usertoken, 'customer');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithReplace(ctx, message, Home());
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  // reshedule appointment

  void resheduleAppoitnment() async {
    FormData body = FormData.fromMap({
      'appointment_id': widget.onlineDetails[0]['appointment_id'],
      'reschedule_slot_id': widget.onlineDetails[0]['slotid'],
      'reschedule_date': DateFormat('yyyy-MM-dd').format(
          DateTime.parse(widget.onlineDetails[0]['bookingdate'].toString()))
    });
    var result = await STM().postWithToken(
        ctx, Str().uploading, 'reschedule', body, usertoken, 'customer');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithReplace(ctx, message, Home());
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
