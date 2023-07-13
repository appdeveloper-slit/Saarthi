import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navigation/bottom_navigation.dart';
import 'heart_rate_history.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class OxygenHistory extends StatefulWidget {
  @override
  State<OxygenHistory> createState() => _OxygenHistoryState();
}

class _OxygenHistoryState extends State<OxygenHistory> {
  late BuildContext ctx;

  List<dynamic> historyList = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController dobCtrl1 = TextEditingController();

  Future datePicker() async {
    DateTime? picked = await showDatePicker(
      context: ctx,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Clr().primaryColor),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      //Disabled past date
      // firstDate: DateTime.now().subtract(Duration(days: 1)),
      // Disabled future date
      // lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        String s = STM().dateFormat('yyyy-MM-dd', picked);
        dobCtrl = TextEditingController(text: s);
      });
    }
  }

  Future datePicker1() async {
    DateTime? picked = await showDatePicker(
      context: ctx,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Clr().primaryColor),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      //Disabled past date
      // firstDate: DateTime.now().subtract(Duration(days: 1)),
      // Disabled future date
      // lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        String s = STM().dateFormat('yyyy-MM-dd', picked);
        dobCtrl1 = TextEditingController(text: s);
      });
    }
  }
  bool loading = false;
  String? usertoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getOxygen();
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
          'Oxygen',
          style: Sty()
              .largeText
              .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0.7,
                            backgroundColor: Color(0xff616FEC),
                            side: BorderSide(color: Clr().borderColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                        onPressed: () {
                          // STM().redirect2page(ctx, HealthMatrix());
                        },
                        child: SvgPicture.asset('assets/oxygen.svg')),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Oxygen',
                        style: Sty()
                            .largeText
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
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Clr().borderColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      // boxShadow: [
                      //
                      //   BoxShadow(
                      //     color: Clr().grey.withOpacity(0.1),
                      //     spreadRadius: 0.5,
                      //     blurRadius: 12,
                      //     offset: Offset(0, 8), // changes position of shadow
                      //   ),
                      // ],
                    ),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () {
                        datePicker();
                      },
                      controller: dobCtrl,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Pickup date is required';
                        }
                      },
                      // controller: mobileCtrl,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(Dim().d12),
                          child: SvgPicture.asset('assets/calender.svg'),
                        ),
                        fillColor: Clr().formfieldbg,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Clr().transparent)),
                        focusColor: Clr().primaryColor,

                        contentPadding: EdgeInsets.all(18),
                        // label: Text('Enter Your Number'),
                        hintText: "dd-mm-yy",
                        counterText: "",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dim().d8,
                ),
                Text(
                  'to',
                  style: Sty().mediumText,
                ),
                SizedBox(
                  width: Dim().d8,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Clr().borderColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      // boxShadow: [
                      //
                      //   BoxShadow(
                      //     color: Clr().grey.withOpacity(0.1),
                      //     spreadRadius: 0.5,
                      //     blurRadius: 12,
                      //     offset: Offset(0, 8), // changes position of shadow
                      //   ),
                      // ],
                    ),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () {
                        datePicker1();
                      },
                      controller: dobCtrl1,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Pickup date is required';
                        }
                      },
                      // controller: mobileCtrl,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(Dim().d12),
                          child: SvgPicture.asset('assets/calender.svg'),
                        ),
                        fillColor: Clr().formfieldbg,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Clr().transparent)),
                        focusColor: Clr().primaryColor,

                        contentPadding: EdgeInsets.all(18),
                        // label: Text('Enter Your Number'),
                        hintText: "dd-mm-yy",
                        counterText: "",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 40,
                width: 120,
                child: ElevatedButton(
                    onPressed: () {
                      getOxygen(
                          fromdate: dobCtrl.text, todate: dobCtrl1.text);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3))),
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
              height: 30,
            ),
            Text(
              'History',
              style: Sty().largeText.copyWith(
                    fontSize: 20,
                  ),
            ),
            SizedBox(
              height: 20,
            ),
            historyList.isEmpty ?  Text('No History') : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: historyList.length,
                // padding: EdgeInsets.only(top: 2,bottom: 12),
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: historyLayout(ctx, index, historyList),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget historyLayout(ctx , index , List){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${DateFormat('dd-MM-yyy').format(DateTime.parse(List[index]['updated_at']))}',
              style: Sty()
                  .mediumText
                  .copyWith(fontWeight: FontWeight.w400),
            ),
            Text(
              '${List[index]['oxygen']}%mg/dl',
              style: Sty()
                  .smallText
                  .copyWith(fontWeight: FontWeight.w400,
                  color: Color(0xff1FDA8D)),
            ),
          ],),
        SizedBox(height: 20,)
      ],
    );

  }
  // get bmi
  void getOxygen({fromdate, todate}) async {
    FormData body = FormData.fromMap({
      'from_date': fromdate,
      'to_date': todate,
    });
    var result = await STM().postWithTokenWithoutDailog(ctx, 'get_oxygen_history', body, usertoken, 'customer');
      setState(() {
        // value = result['data'][0]['blood_glucose'];
        // date = result['data'][0]['updated_at'];
        historyList = result['data'];
        loading = true;
      });
  }
}
