import 'package:dio/dio.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/hcp/appointment.dart';
import 'package:saarathi/log_in.dart';
import 'package:saarathi/manage/static_method.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../values/colors.dart';
import '../values/styles.dart';
import 'hcpMyprofile.dart';
import 'hcpappointmentavailability.dart';

class HomeVisit extends StatefulWidget {
  @override
  State<HomeVisit> createState() => _HomeVisitState();
}

class _HomeVisitState extends State<HomeVisit> {
  late BuildContext ctx;
  String? hcptoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      hcptoken = sp.getString('hcptoken') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getHomeDetails();
        print(hcptoken);
      }
    });
  }
  dynamic allcount;

  @override
  void initState() {
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return DoubleBack(
      message: 'Please Press back once again',
      child: Scaffold(
        backgroundColor: Clr().white,
        appBar: appbarLayout(),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              programLayout(),
              appoinmentsLayout(),
              walletProfileSlots(),
              policiesLayout(),
            ],
          ),
        ),
      ),
    );
  }

  // appbarlayout
  AppBar appbarLayout() {
    return AppBar(
      elevation: 2,
      backgroundColor: Clr().white,
      centerTitle: true,
      title: Image.asset('assets/homelogo.png'),
      actions: [
        Padding(
          padding: EdgeInsets.all(Dim().d16),
          child: Icon(
            Icons.notifications,
            color: Clr().primaryColor,
          ),
        )
      ],
    );
  }

  // patient support program
  Widget programLayout() {
    return Padding(
      padding: EdgeInsets.only(bottom: Dim().d20),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Clr().grey.withOpacity(0.1),
              spreadRadius: 0.1,
              blurRadius: 12,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          color: Clr().formfieldbg,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Clr().borderColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dim().d16, horizontal: Dim().d16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SvgPicture.asset('assets/support.svg'),
                    SizedBox(
                      width: Dim().d20,
                    ),
                    InkWell(
                      onTap: () {
                        // STM().redirect2page(ctx, Programs());
                      },
                      child: Text(
                        'Patient Support Program',
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                InkWell(
                    onTap: () {
                      // STM().redirect2page(ctx, Programs());
                    },
                    child: SvgPicture.asset('assets/arrow1.svg')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // appointment
  Widget appoinmentsLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointments',
          style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dim().d16),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Clr().grey.withOpacity(0.1),
                  spreadRadius: 0.1,
                  blurRadius: 12,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              color: Clr().formfieldbg,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Clr().borderColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Dim().d12, horizontal: Dim().d12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          height: 55,
                          width: 55,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Color(0xffF6505A),
                                  side: BorderSide(color: Clr().borderColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              onPressed: () {
                                STM().redirect2page(ctx, OnlineAppointment());
                              },
                              child: SvgPicture.asset(
                                'assets/online_apt.svg',
                              )),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            // STM().redirect2page(ctx, OnlineAppointment());
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Online Appointment',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                              Text(
                                'Total : ${allcount == null ? 0 : allcount['online_count']}',
                                style: Sty().mediumText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffF6505A)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          // STM().redirect2page(ctx, OnlineAppointment());
                        },
                        child: SvgPicture.asset('assets/arrow_red.svg')),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Clr().grey.withOpacity(0.1),
                spreadRadius: 0.1,
                blurRadius: 12,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            color: Clr().formfieldbg,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Clr().borderColor,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dim().d12, horizontal: Dim().d12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        height: 55,
                        width: 55,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Color(0xFFFFC107),
                                side: BorderSide(color: Clr().borderColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {
                              // STM().redirect2page(ctx, OPDAppointment());
                            },
                            child: SvgPicture.asset(
                              'assets/opd.svg',
                            )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          // STM().redirect2page(ctx, OPDAppointment());
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'OPD Appointment',
                              style: Sty()
                                  .mediumText
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Total : ${allcount == null ? 0 : allcount['opd_count']}',
                              style: Sty().mediumText.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffFFC107)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        // STM().redirect2page(ctx, OPDAppointment());
                      },
                      child: SvgPicture.asset('assets/arrow_orange.svg')),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: Dim().d16, bottom: Dim().d20),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Clr().grey.withOpacity(0.1),
                  spreadRadius: 0.1,
                  blurRadius: 12,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              color: Clr().formfieldbg,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Clr().borderColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Dim().d12, horizontal: Dim().d12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          height: 55,
                          width: 55,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Color(0xff2BC999),
                                  side: BorderSide(color: Clr().borderColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              onPressed: () {
                                // STM().redirect2page(ctx, HomeVisit());
                              },
                              child: SvgPicture.asset(
                                'assets/homevisit.svg',
                              )),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            // STM().redirect2page(ctx, HomeVisit());
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Home Visit',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                              Text(
                                'Total : ${allcount == null ? 0 : allcount['home_count']}',
                                style: Sty().mediumText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff2BC999)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          // STM().redirect2page(ctx, HomeVisit());
                        },
                        child: SvgPicture.asset('assets/arrow_green.svg')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // wallet && appslot && myprofile
  Widget walletProfileSlots() {
    return Padding(
      padding: EdgeInsets.only(bottom: Dim().d20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              // STM().redirect2page(ctx, AddBankDetails());
            },
            child: Container(
              height: 100,
              width: 108,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Clr().grey.withOpacity(0.1),
                    spreadRadius: 0.1,
                    blurRadius: 12,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                color: Clr().formfieldbg,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Clr().borderColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Dim().d12, horizontal: 10),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/wallet_green.svg',
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'My Wallet',
                          style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
          Container(
            height: 100,
            width: 108,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Clr().grey.withOpacity(0.1),
                  spreadRadius: 0.1,
                  blurRadius: 12,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                STM().redirect2page(ctx, const ApptAvailability(pagetype: 'edit'));
              },
              child: Card(
                elevation: 0,
                color: Clr().formfieldbg,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Clr().borderColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Dim().d12, horizontal: 10),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/appt_slots.svg',
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Appt Slots',
                          style: Sty().mediumText.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    )),
              ),
            ),
          ),
          InkWell(
            onTap: ()  {
              STM().redirect2page(ctx, MyProfile());
            },
            child: Container(
              height: 100,
              width: 108,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Clr().grey.withOpacity(0.1),
                    spreadRadius: 0.1,
                    blurRadius: 12,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                color: Clr().formfieldbg,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Clr().borderColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Dim().d12, horizontal: 10),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/profile.svg',
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'My Profile',
                          style: Sty().mediumText.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // policies
  Widget policiesLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Policies',
          style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        Padding(
          padding: EdgeInsets.only(top: Dim().d16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 120,
                width: 108,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Clr().grey.withOpacity(0.1),
                      spreadRadius: 0.1,
                      blurRadius: 12,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  color: Clr().formfieldbg,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Clr().borderColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dim().d12, horizontal: 10),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/privacy.svg',
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Privacy\nPolicy',
                            textAlign: TextAlign.center,
                            style: Sty().mediumText.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                ),
              ),
              Container(
                height: 120,
                width: 110,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Clr().grey.withOpacity(0.1),
                      spreadRadius: 0.1,
                      blurRadius: 12,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  color: Clr().formfieldbg,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Clr().borderColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dim().d12, horizontal: 10),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/terms.svg',
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Terms &\nConditions',
                            textAlign: TextAlign.center,
                            style: Sty().mediumText.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                ),
              ),
              Container(
                height: 120,
                width: 108,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Clr().grey.withOpacity(0.1),
                      spreadRadius: 0.1,
                      blurRadius: 12,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  color: Clr().formfieldbg,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Clr().borderColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dim().d12, horizontal: 10),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/refund.svg',
                          ),
                          SizedBox(
                            height: Dim().d8,
                          ),
                          Text(
                            'Refund\nPolicy',
                            textAlign: TextAlign.center,
                            style: Sty().mediumText.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // api home details
  void getHomeDetails() async {
    FormData body = FormData.fromMap({});
    var result = await STM().postWithToken(ctx, Str().loading, 'home', body, hcptoken, 'hcp');
    setState(() {
      allcount = result;
    });
  }
}
