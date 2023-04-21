import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/blood_glucose.dart';
import 'package:saarathi/bmr_calculator.dart';
import 'package:saarathi/heart_rate.dart';
import 'package:saarathi/lipid_profile.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/hba1c.dart';
import 'package:saarathi/weight.dart';

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

  List<dynamic> categoryList = [
    {
      'name': 'BMI Calculator',
      'img': 'assets/bmi.svg',
      'clr': Color(0xffF6505A),
      'page' : BMI(),
    },
    {
      'name': 'BMR Calculator',
      'img': 'assets/bmr_cal.svg',
      'clr': Color(0xff336699),
      'page' : BMRCalculator(),
    },
    {
      'name': 'Blood Glucose',
      'img': 'assets/blood_glu.svg',
      'clr': Color(0xff1FDA8D),
      'page' : BloodGlucose(),
    },
    {
      'name': 'HbA1c',
      'img': 'assets/hba1c.svg',
      'clr': Color(0xff70D4FF),
      'page' : HbA1c(),
    },
    {
      'name': 'Oxygen',
      'img': 'assets/oxygen.svg',
      'clr': Color(0xff616FEC),
      'page' : Oxygen(),
    },
    {
      'name': 'Weight',
      'img': 'assets/weight.svg',
      'clr': Color(0xffEC6EDF),
      'page' : Weight(),
    },

    {
      'name': 'Heart Rate',
      'img': 'assets/heart_rate.svg',
      'clr': Color(0xffFC9A40),
      'page' : HeartRate(),
    }
  ];

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
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
            color: Clr().black,
          ),
        ),
        centerTitle: true,
        title: Text(
          'HealthMatrix',
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
                    child: categoryLayout(ctx, index, categoryList),
                  );
                }),
            SizedBox(
              height: 4,
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
              child: InkWell(
                onTap: (){
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
                                          backgroundColor: Color(0xffAD55FF),
                                          side: BorderSide(color: Clr().borderColor),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          )),
                                      onPressed: () {
                                        STM().redirect2page(ctx, LipidProfile());
                                      },
                                      child: SvgPicture.asset('assets/lipid.svg')),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Lipid Profile',
                                      style: Sty()
                                          .mediumText
                                          .copyWith(fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '04 December, 2022 ',
                                      style: Sty().smallText.copyWith(
                                          color: Clr().grey,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '26.8',
                                      style: Sty().smallText.copyWith(
                                          color: Clr().black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SvgPicture.asset('assets/arrow1.svg')
                          ],
                        ),
                        SizedBox(height: 12,),
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
                            '37 mg/dL',
                            style: Sty()
                                .smallText
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],),

                        SizedBox(height: 8,),
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
                              '116 mg/dL',
                              style: Sty()
                                  .smallText
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ],),

                        SizedBox(height: 8,),
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
                          ],),

                        SizedBox(height: 8,),
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
                          ],),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
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
        onTap: (){
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
                        Text(
                          '04 December, 2022 ',
                          style: Sty().smallText.copyWith(
                              color: Clr().grey, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '26.8',
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
}
