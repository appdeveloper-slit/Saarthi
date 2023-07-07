import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:saarathi/weight.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blood_glucose_history.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class BMI extends StatefulWidget {
  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  late BuildContext ctx;
  var date;
  double? value;
  String? usertoken;
  bool loading = false;
  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getBmi();
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
          'BMI Calculator',
          style: Sty()
              .largeText
              .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        physics: BouncingScrollPhysics(),
        child: loading ? Column(
          children: [
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
                                    backgroundColor: Color(0xffF6505A),
                                    side: BorderSide(color: Clr().borderColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                onPressed: () {
                                  // STM().redirect2page(ctx, HealthMatrix());
                                },
                                child: SvgPicture.asset('assets/bmi.svg')),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BMI Calculator',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${DateFormat('d MMMM, y').format(DateTime.parse(date))}',
                                style: Sty().smallText.copyWith(
                                    color: Clr().grey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: Dim().d12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Your BMI is',
                              style: Sty().mediumText.copyWith(
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
                                color: Clr().black,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              '${value!.toStringAsFixed(2)}',
                              textAlign: TextAlign.end,
                              style: Sty().mediumText.copyWith(
                                  color: Clr().black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: Dim().d20),
            GestureDetector(
              onTap: (){
                STM().redirect2page(ctx, Weight());
              },
              child: Center(
                child: Text(
                  'View Weight History',
                  style: Sty()
                      .smallText
                      .copyWith(color: Clr().primaryColor, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: Dim().d100,
            ),
            Image.asset('assets/bmi.jpg')
          ],
        ) : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  // get bmi
  void getBmi() async {
    FormData body = FormData.fromMap({});
    var result = await STM().postWithTokenWithoutDailog(ctx, 'get_bmi', body, usertoken, 'customer');
    setState(() {
      value = result['bmi'];
      date = result['date'];
      loading = true;
    });
  }
}
