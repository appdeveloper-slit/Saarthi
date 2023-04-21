import 'dart:async';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'hcpOnlineConsultSlots.dart';
import 'hcphome.dart';

class ApptAvailability extends StatefulWidget {
  final type;
  final pagetype;

  const ApptAvailability({super.key, this.type, this.pagetype});

  @override
  State<StatefulWidget> createState() {
    return ApptAvailabilityPage();
  }
}

class ApptAvailabilityPage extends State<ApptAvailability> {
  late BuildContext ctx;
  static StreamController<String?> controller = StreamController<String?>.broadcast();
  dynamic value;
  String? hcptoken;
  List<dynamic> getAppointmentDetails = [];
  dynamic onlineAppointmentDetails;
  dynamic opdAppointmentDetails;
  dynamic homeAppointmentDetails;
  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      hcptoken = sp.getString('hcptoken') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        widget.pagetype == 'edit' ? getAppoinmentDetails() : null;
        print(hcptoken);
      }
    });
  }

  @override
  void initState() {
    getSession();
    value = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return widget.pagetype == 'edit'
        ? WillPopScope(
            child: homeLayout(ctx),
            onWillPop: () async {
              STM().finishAffinity(ctx,HomeVisit());
              return false;
            })
        : DoubleBack(
            message: 'Press back again to exit',
            child: homeLayout(ctx),
          );
  }

// homedetails
  Widget homeLayout(ctx) {
    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Clr().white,
        // leading: InkWell(
        //   onTap: () {
        //     STM().back2Previous(ctx);
        //   },
        //   child: Icon(
        //     Icons.arrow_back_rounded,
        //     color: Clr().appbarTextColor,
        //   ),
        // ),
        centerTitle: true,
        title: Text(
          'Appointment Availability',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment type',
              style: Sty().largeText.copyWith(
                  color: Clr().appbarTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: Dim().d20,
            ),
            InkWell(
              onTap: () {
                STM().redirect2page(
                    ctx,
                    OlConsSlots(
                      type: 1,
                      stypename: 'Online',
                      pageType: widget.pagetype,
                      appoinmentdetails: onlineAppointmentDetails,
                    ));
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Color(0xffD9D9D9))),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dim().d12, horizontal: Dim().d20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SvgPicture.asset('assets/ol_consultation.svg'),
                          SizedBox(width: Dim().d20),
                          Text('Online Consultation',
                              style: Sty()
                                  .mediumText
                                  .copyWith(fontWeight: FontWeight.w400)),
                        ],
                      ),
                      SvgPicture.asset('assets/arrow.svg'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: Dim().d16),
            InkWell(
              onTap: () {
                STM().redirect2page(
                    ctx,
                    OlConsSlots(
                      type: 2,
                      stypename: 'Opd',
                      pageType: widget.pagetype,
                      appoinmentdetails: opdAppointmentDetails,
                    ));
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                        // color: Clr().borderColor
                        color: Color(0xffD9D9D9))),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dim().d12, horizontal: Dim().d20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SvgPicture.asset('assets/opd_appointment.svg'),
                          SizedBox(width: Dim().d20),
                          Text('OPD Appointment', style: Sty().mediumText.copyWith(fontWeight: FontWeight.w400)),
                        ],
                      ),
                      SvgPicture.asset('assets/arrow.svg'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: Dim().d16),
            InkWell(
              onTap: () {
                STM().redirect2page(
                    ctx,
                    OlConsSlots(
                      type: 3,
                      stypename: 'HomeVisit',
                      pageType: widget.pagetype,
                      appoinmentdetails: homeAppointmentDetails,
                    ));
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                        // color: Clr().borderColor
                        color: Color(0xffD9D9D9))),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dim().d12, horizontal: Dim().d20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SvgPicture.asset('assets/home_visit.svg'),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Home Visit Appointment',
                            style: Sty()
                                .mediumText
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SvgPicture.asset('assets/arrow.svg'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: Dim().d32),
            value == 1 || value == 2 || value == 3
                ? Center(
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences sp =
                                await SharedPreferences.getInstance();
                            sp.setBool('hcplogin', true);
                            STM().finishAffinity(ctx, HomeVisit());
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
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
                  )
                :  Container(),
          ],
        ),
      ),
    );
  }

// get appoinmentdetails
  void getAppoinmentDetails() async {
    var result = await STM().getWithTokenUrl(
        ctx, Str().loading, 'hcp_appointment_details', hcptoken, 'hcp');
    var success = result['success'];
    if (success) {
      setState(() {
        getAppointmentDetails = result['appointments'];
        int position = getAppointmentDetails.indexWhere((element) => element['appointment_type_id'] == 1);
        int position1 = getAppointmentDetails.indexWhere((element) => element['appointment_type_id'] == 2);
        int position2 = getAppointmentDetails.indexWhere((element) => element['appointment_type_id'] == 3);
        onlineAppointmentDetails = getAppointmentDetails[position];
        opdAppointmentDetails = getAppointmentDetails[position1];
        homeAppointmentDetails = getAppointmentDetails[position2];
      });
      print(onlineAppointmentDetails);
      print(opdAppointmentDetails);
      print(homeAppointmentDetails);
    }
  }
}
