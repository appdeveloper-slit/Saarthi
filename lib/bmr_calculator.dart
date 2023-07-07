import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/health_matrix.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blood_glucose.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class BMRCalculator extends StatefulWidget {
  final v;
  const BMRCalculator({super.key,  this.v});
  @override
  State<BMRCalculator> createState() => _BMRCalculatorState();
}

class _BMRCalculatorState extends State<BMRCalculator> {
  late BuildContext ctx;
  var date;
  var value;
  String? usertoken;
  bool loading = false;
 TextEditingController bmrctrl = TextEditingController();
  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getBmr();
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
    return WillPopScope(
      onWillPop: () async {
        widget.v == true ? STM().replacePage(ctx, HealthMatrix()) : STM().back2Previous(ctx);
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
              widget.v == true ? STM().replacePage(ctx, HealthMatrix()) : STM().back2Previous(ctx);
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Clr().black,
            ),
          ),
          centerTitle: true,
          title: Text(
            'BMR Calculator',
            style: Sty()
                .largeText
                .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
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
                                      backgroundColor: Color(0xff336699),
                                      side: BorderSide(color: Clr().borderColor),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      )),
                                  onPressed: () {
                                    // STM().redirect2page(ctx, HealthMatrix());
                                  },
                                  child:
                                      SvgPicture.asset('assets/heart_rate.svg')),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BMR Calculator',
                                  style: Sty()
                                      .mediumText
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                if (date != null)
                                  Text(
                                    '${DateFormat('dd MMMM, yyyy').format(DateTime.parse(date.toString()))}',
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
                        if (value != null)
                        Row(
                          children: [
                            Text(
                              'Your BMR is',
                              style: Sty().mediumText.copyWith(
                                  color: Clr().black,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 20,
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
                                '${value.toString()}',
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
              SizedBox(
                height: Dim().d24,
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
                  controller: bmrctrl,
                  keyboardType: TextInputType.number,
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
                    hintText: "Enter the BMR",
                    hintStyle:
                    TextStyle(color: Clr().hintColor, fontSize: 14),
                    counterText: "",
                  ),
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
                        addBMR(bmrctrl.text);
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
              ),
              SizedBox(
                height: 40,
              ),
              Table(
                border: TableBorder.all(
                    color: Color(0xff189392),
                    borderRadius: BorderRadius.circular(5)),
                children: const [
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Age (y)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Males",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Females",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "14-15",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "46.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "43.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "16-17",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "43.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "40.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "18-19",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "41.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "38.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "20-29",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "39.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "35.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "30-39",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "39.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "35.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "30-39",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "39.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "37",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "50-59",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "39.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "37",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "60-69",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "39.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "37",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "70-79",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "39.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "37",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // get bmr
  void getBmr() async {
    FormData body = FormData.fromMap({});
    var result = await STM().postWithTokenWithoutDailog(
        ctx, 'get_bmr', body, usertoken, 'customer');
    setState(() {
      value = result['bmr'];
      date = result['date']['updated_at'];
      loading = true;
    });
  }

  void addBMR(bmr) async {
    FormData body = FormData.fromMap({
      'bmr': bmr,
    });
    var result = await STM().postWithToken(
        ctx, Str().processing, 'add_bmr', body, usertoken, 'customer');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message);
      getBmr();
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
