import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'lipid_profile.dart';
import 'values/colors.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Weight extends StatefulWidget {
  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  late BuildContext ctx;
  List<dynamic> historyList = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController dobCtrl1 = TextEditingController();
  TextEditingController weightCtrl = TextEditingController();

  var date, value;
  String? usertoken;
  bool loading = false;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getWeight();
        print(usertoken);
      }
    });
  }

  @override
  void initState() {
    getSession();
    super.initState();
  }

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
          'Weight',
          style: Sty()
              .largeText
              .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: loading
            ? Column(
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
                                        backgroundColor: Color(0xffEC6EDF),
                                        side: BorderSide(
                                            color: Clr().borderColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                    onPressed: () {
                                      // STM().redirect2page(ctx, HealthMatrix());
                                    },
                                    child:
                                        SvgPicture.asset('assets/weight.svg')),
                              ),
                              SizedBox(
                                width: Dim().d12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Weight',
                                    style: Sty().mediumText.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  SizedBox(
                                    height: Dim().d4,
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
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color(0xffDADADA),
                                              width: 0.7))),
                                  child: TextFormField(
                                    controller: weightCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Clr().formfieldbg,
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Clr().primaryColor,
                                            width: 1.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: EdgeInsets.all(8),
                                      // label: Text('Enter Your Number'),
                                      hintStyle: TextStyle(
                                          color: Clr().hintColor, fontSize: 14),
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
                              ),
                              SizedBox(
                                width: Dim().d8,
                              ),
                              Text(
                                'kg',
                                style: Sty().mediumText.copyWith(
                                    color: Clr().black,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: Dim().d80,
                              ),
                              SizedBox(
                                height: 40,
                                width: 120,
                                child: ElevatedButton(
                                    onPressed: () {
                                      addWeight(weightCtrl.text);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Clr().primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3))),
                                    child: Text(
                                      'Update',
                                      style: Sty().mediumText.copyWith(
                                            color: Clr().white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
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
                                  borderSide:
                                      BorderSide(color: Clr().transparent)),
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
                                  borderSide:
                                      BorderSide(color: Clr().transparent)),
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
                  SizedBox(height: Dim().d12),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 40,
                      width: 120,
                      child: ElevatedButton(
                          onPressed: () {
                            getWeight(
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
                    height: Dim().d32,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'History',
                      style: Sty().largeText.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: Dim().d20,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: historyList.length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: historyLayout(ctx, index, historyList),
                        );
                      }),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget historyLayout(ctx, index, List) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${DateFormat('dd-MM-yyyy').format(DateTime.parse(List[index]['created_at']))}',
              style: Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
            ),
            RichText(
              text: TextSpan(
                text: "${List[index]['weight']}",
                style: Sty().smallText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffEC6EDF),
                    ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' kg',
                    style: Sty()
                        .microText
                        .copyWith(color: Color(0xff2D2D2D), fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  // get bmi
  void getWeight({fromdate, todate}) async {
    FormData body = FormData.fromMap({
      'from_date': fromdate,
      'to_date': todate,
    });
    var result = await STM().postWithTokenWithoutDailog(
        ctx, 'get_weight_history', body, usertoken, 'customer');
    if (result['data'].isNotEmpty) {
      setState(() {
        value = result['data'][0]['weight'];
        weightCtrl = TextEditingController(text: result['data'][0]['weight']);
        date = result['data'][0]['updated_at'];
        historyList = result['data'];
        loading = true;
      });
    } else {
      STM().displayToast('No Weights');
    }
  }


  // add weight
void addWeight(weight) async {
    FormData body = FormData.fromMap({
      'weight': weight,
    });
    var result = await STM().postWithToken(ctx, Str().processing,'add_weight', body, usertoken, 'customer');
    var success = result['success'];
    var message = result['message'];
    if(success){
      STM().displayToast(message);
      getWeight();
    }else{
      STM().errorDialog(ctx, message);
    }
}
}
