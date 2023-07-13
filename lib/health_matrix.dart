import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/blood_glucose.dart';
import 'package:saarathi/bmr_calculator.dart';
import 'package:saarathi/heart_rate.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/lipid_profile.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/hba1c.dart';
import 'package:saarathi/values/strings.dart';
import 'package:saarathi/weight.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bmi.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'oxygen.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class HealthMatrix extends StatefulWidget {
  @override
  State<HealthMatrix> createState() => _HealthMatrixState();
}

class _HealthMatrixState extends State<HealthMatrix> {
  late BuildContext ctx;
  var liquidProfile;
  List apiList = [
    'get_bmi',
    'get_bmr',
    'get_blood_glucose',
    'get_hba1c',
    'get_oxygen',
    'get_heart_rate',
  ];
  List<dynamic> categoryList = [];
  String? usertoken;
  var result;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        allApi(apiList[0]);
        // for(int a = 0 ; a < apiList.length; a++) {
        //   allApi(apiList[a]);
        // }
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
    return WillPopScope(onWillPop: () async {
      STM().finishAffinity(ctx,Home());
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
              STM().finishAffinity(ctx,Home());
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Clr().black,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Health Metrics',
            style: Sty()
                .largeText
                .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: categoryList.length,
                  // padding: EdgeInsets.only(top: 2,bottom: 12),
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: categoryList.length != apiList.length
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: Dim().d20),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : categoryLayout(ctx, index, categoryList),
                    );
                  }),
              SizedBox(
                height: 4,
              ),
              liquidProfile == null
                  ? Container()
                  : Container(
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
                          STM().redirect2page(ctx, LipidProfile());
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
                            padding: EdgeInsets.all(Dim().d16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0.7,
                                                  backgroundColor:
                                                      Color(0xffAD55FF),
                                                  side: BorderSide(
                                                      color: Clr().borderColor),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(5),
                                                  )),
                                              onPressed: () {
                                                STM().redirect2page(
                                                    ctx, LipidProfile(v: true));
                                              },
                                              child: SvgPicture.asset(
                                                  'assets/lipid.svg')),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Lipid Profile',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            if (liquidProfile['date'] != null)
                                              Text(
                                                '${DateFormat('dd MMMM, yyyy').format(DateTime.parse(liquidProfile['date'].toString()))}',
                                                style: Sty().smallText.copyWith(
                                                    color: Clr().grey,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SvgPicture.asset('assets/arrow1.svg')
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'AHDL',
                                      style: Sty()
                                          .mediumText
                                          .copyWith(fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      '${liquidProfile['blood_cholesterol'].toString()}',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ALDL',
                                      style: Sty()
                                          .mediumText
                                          .copyWith(fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      '${liquidProfile['ldl_cholesterol'].toString()}',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'CHOL',
                                      style: Sty()
                                          .mediumText
                                          .copyWith(fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      '${liquidProfile['hdl_cholesterol'].toString()}',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'TGL',
                                      style: Sty()
                                          .mediumText
                                          .copyWith(fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      '${liquidProfile['triglycerides'].toString()}',
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
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryLayout(ctx, index, List) {
    return Container(
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
          STM().redirect2page(ctx, List[index]['page']);
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
            padding: EdgeInsets.all(Dim().d16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0.7,
                              backgroundColor: List[index]['clr'],
                              side: BorderSide(color: Clr().borderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                          onPressed: () {
                            STM().redirect2page(ctx, List[index]['page']);
                          },
                          child: SvgPicture.asset(List[index]['img'].toString()
                              // 'assets/bmi.svg'
                              )),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          List[index]['name'].toString(),
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        if (List[index]['date'] != null)
                          Text(
                            '${DateFormat('d MMMM , yyyy').format(DateTime.parse(List[index]['date'].toString()))}',
                            style: Sty().smallText.copyWith(
                                color: Clr().grey, fontWeight: FontWeight.w400),
                          ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${List[index]['value'].toString()}',
                          style: Sty().smallText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
                SvgPicture.asset('assets/arrow1.svg')
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// all api
  void allApi(apiname) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({});

    ///  response of get and post api in result using what type of api have...
    result = await STM()
        .postWithTokenWithoutDailog(ctx, apiname, body, usertoken, 'customer');
    // var success = result['success'];
    /// get response in list using apiname (get_timetable , "get_classroom" is api)
    setState(() {
      switch (apiname) {
        case "get_bmi":
          setState(() {
            categoryList.add({
              'name': 'BMI Calculator',
              'img': 'assets/bmi.svg',
              'clr': Color(0xffF6505A),
              'page': BMI(v: true),
              'date': result['date'],
              'value': result['bmi'],
            });
          });
          allApi(apiList[1]);
          break;
        case "get_bmr":
          setState(() {
            categoryList.add(
              {
                'name': 'BMR Calculator',
                'img': 'assets/bmr_cal.svg',
                'clr': Color(0xff336699),
                'page': BMRCalculator(v: true),
                'date': result['date'],
                'value': result['bmr'],
              },
            );
          });
          allApi(apiList[2]);
          break;
        case "get_blood_glucose":
          setState(() {
            categoryList.add({
              'name': 'Blood Glucose',
              'img': 'assets/blood_glu.svg',
              'clr': Color(0xff1FDA8D),
              'page': BloodGlucose(v: true),
              'date': result['date'] ,
              'value': result['blood_glucose'],
            });
          });
          allApi(apiList[3]);
          break;
        case "get_hba1c":
          setState(() {
            categoryList.add({
              'name': 'HbA1c',
              'img': 'assets/hba1c.svg',
              'clr': Color(0xff70D4FF),
              'page': HbA1c(v: true),
              'date': result['date'],
              'value': result['hba1c']
            });
          });
          allApi(apiList[4]);
          break;
        case "get_oxygen":
          setState(() {
            categoryList.add({
              'name': 'Oxygen',
              'img': 'assets/oxygen.svg',
              'clr': Color(0xff616FEC),
              'page': Oxygen(v: true),
              'date': result['date'] ,
              'value': result['oxygen']
            });
          });
          allApi(apiList[5]);
          break;
        case "get_heart_rate":
          setState(() {
            categoryList.add({
              'name': 'Heart Rate',
              'img': 'assets/heart_rate.svg',
              'clr': Color(0xffFC9A40),
              'page': HeartRate(v: true),
              'date': result['date'] ,
              'value': result['heart_rate']
            });
          });
          allApi('get_lipid_profile');
          break;
        case "get_lipid_profile":
          setState(() {
            liquidProfile = result;
          });
          break;
      }
    });
  }
}
