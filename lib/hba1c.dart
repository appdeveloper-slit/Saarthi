import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/hba1c_history.dart';
import 'package:saarathi/values/dimens.dart';

import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'oxygen.dart';
import 'values/colors.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class HbA1c extends StatefulWidget {
  @override
  State<HbA1c> createState() => _HbA1cState();
}

class _HbA1cState extends State<HbA1c> {
  late BuildContext ctx;

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
          'HbA1c',
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
                                  backgroundColor: Color(0xff70D4FF),
                                  side: BorderSide(color: Clr().borderColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                              onPressed: () {
                                // STM().redirect2page(ctx, HealthMatrix());
                              },
                              child: SvgPicture.asset('assets/hba1c.svg')),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HbA1c',
                              style: Sty().mediumText.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
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
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'plasma blood glucose',
                            style: Sty().smallText.copyWith(
                                color: Clr().black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          ':',
                          style: Sty().smallText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          '19 mg/dl 1 mmol/L',
                          textAlign: TextAlign.end,
                          style: Sty().smallText.copyWith(
                              color: Clr().black, fontWeight: FontWeight.w400),
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
              'Glycosylated Hemoglobin (HbA1c)',
              style: Sty()
                  .mediumText
                  .copyWith(color: Clr().black, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 20,
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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Clr().formfieldbg,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Clr().primaryColor, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.all(18),
                  // label: Text('Enter Your Number'),
                  hintText: "2.5 - 23",
                  hintStyle: TextStyle(color: Clr().hintColor,fontSize: 14),
                  counterText: "",
                ),
                maxLength: 10,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'([5-9]{1}[0-9]{9})')
                          .hasMatch(value)) {
                    return Str().invalidMobile;
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(height: 30,),
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
                            borderRadius:
                            BorderRadius.circular(10))),
                    child: Text(
                      'Submit',
                      style: Sty().mediumText.copyWith(
                        color: Clr().white,
                        fontWeight: FontWeight.w600,),
                    )),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                STM().redirect2page(ctx, HbA1cHistory());
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
              height: 10,
            ),
            SvgPicture.asset('assets/blood_graph.svg')
          ],
        ),
      ),
    );
  }
}
