import 'dart:async';
import 'dart:convert';
import 'package:calender_picker/calender_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dr_name.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'add_new_patient.dart';
import 'bottom_navigation/bottom_navigation.dart';

var controller = StreamController<String?>.broadcast();

class PaymentSummary extends StatefulWidget {
  final dynamic labdetails;
  final dynamic testDetails;
  final int? totalValue;
  final int? type;

  const PaymentSummary({super.key, this.labdetails, this.testDetails, this.totalValue,this.type});

  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  late BuildContext ctx;
  String? usertoken;
  List<dynamic> patientlist = [];
  List testids = [];
  var datetime;
  List<Map<String, dynamic>> patientDetailsList = [];

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    for(int a = 0; a < widget.testDetails.length; a++){
      setState(() {
        testids.add(widget.testDetails[a]['id']);
      });
    }
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getPatient();
        print(usertoken);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    controller.stream.listen(
      (event) {
        print(event.toString());
        getPatient();
      },
    );
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
            color: Clr().appbarTextColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Payment Summary',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.30,
              color: Color(0xff80C342),
              alignment: Alignment.center,
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.26,
                  child: Column(
                    children: [
                      Flexible(
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color(0xffcee8b0),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: Center(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: Dim().d20),
                                  child: Text(
                                    widget.labdetails[0]['labname'],
                                    style: Sty().mediumText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Flexible(
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: Dim().d20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.labdetails[0]['dayname'],
                                            style: Sty().mediumText.copyWith(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            widget.labdetails[0]['timename'],
                                            style: Sty().mediumText.copyWith(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: Dim().d16),
                                        child: Text(
                                          '₹ ${widget.totalValue}',
                                          style: Sty().smallText.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Clr().primaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Container(
                        decoration: const BoxDecoration(
                            color: Color(0xffcee8b0),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15))),
                        child: Padding(
                          padding: EdgeInsets.all(Dim().d12),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              SizedBox(width: Dim().d12),
                              Expanded(
                                child: Text(
                                  '${widget.labdetails[0]['address']}',
                                  maxLines: 2,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Dim().d12,
            ),
            CalenderPicker(
              DateTime.now(),
              initialSelectedDate: DateTime.now(),
              selectionColor: Clr().primaryColor,
              selectedTextColor: Colors.white,
              height: Dim().d100,
              width: Dim().d80,
              onDateChange: (date) {
                setState(() {
                  datetime = DateFormat('yyyy-MM-dd').format(date);
                  // dayno = date;
                  // int position = dayList.indexWhere((e) =>
                  //     e['name'].toString() == DateFormat.EEEE().format(date));
                  // if (dayList.contains(DateFormat.EEEE().format(date))) {
                  //   dayList[position]['id'];
                  // }
                  // getSlots(id: dayList[position]['id']);
                });
              },
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dim().d16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      itemCount: widget.testDetails.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index2) {
                        return Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Color(0xFFFBFBFB),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: Dim().d16,
                                    bottom: Dim().d16,
                                    left: Dim().d16,
                                    right: Dim().d16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.testDetails[index2]['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Sty().largeText.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '₹ ${widget.testDetails[index2]['price']}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Sty().largeText.copyWith(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            SizedBox(
                                              width: Dim().d20,
                                            ),
                                            SvgPicture.asset(
                                                'assets/cutpaysum.svg'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  patientlist.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                          child: InkWell(
                            onTap: () {
                              STM().redirect2page(
                                  ctx, const AddNewPatient(stype: 'lab'));
                            },
                            child: Container(
                              height: Dim().d44,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Dim().d12),
                                  border: Border.all(color: Clr().hintColor)),
                              child: Center(
                                child: Text('Add New Patient',
                                    style: Sty().mediumBoldText),
                              ),
                            ),
                          ),
                        )
                      : Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: patientlist.isEmpty
                              ? Clr().white
                              : Color(0xFFFBFBFB),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dim().d16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Select Patient',
                                        style: Sty().mediumText.copyWith(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          STM().redirect2page(
                                              ctx,
                                              const AddNewPatient(
                                                  stype: 'lab'));
                                        },
                                        child: Wrap(
                                          children: [
                                            SvgPicture.asset(
                                                'assets/plusenew.svg'),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              'Add New',
                                              style: Sty().smallText.copyWith(
                                                  color: Clr().primaryColor),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                ListView.builder(
                                    itemCount: patientlist.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return patientDetails(
                                          ctx, index, patientlist);
                                    }),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 15,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextFormField(
                              // controller: mobileCtrl,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                filled: true,
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(5)),

                                fillColor: Clr().white,

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
                    height: Dim().d16,
                  ),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color(0xFFFBFBFB),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: Dim().d8),
                                  child: Text(
                                    'Price Summary',
                                    style: Sty().largeText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          // fontFamily: Outfit
                                        ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dim().d8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Test Charges',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      '₹ ${widget.totalValue}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Dim().d8,
                              ),
                              // Padding(
                              //   padding:
                              //       EdgeInsets.symmetric(horizontal: Dim().d8),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(
                              //         'Discount',
                              //         style: TextStyle(
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.w400),
                              //       ),
                              //       Text(
                              //         '₹ 0',
                              //         style: TextStyle(
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.w500),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: Dim().d8,
                              // ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 2,
                          thickness: 1.5,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: Dim().d2,
                              bottom: Dim().d16,
                              left: Dim().d16,
                              right: Dim().d16),
                          child: Column(
                            children: [
                              SizedBox(
                                height: Dim().d8,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dim().d4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: Sty().largeText.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      '₹ ${widget.totalValue}',
                                      style: Sty().largeText.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Clr().grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 12,
                      offset: Offset(12, 0.5), // changes position of shadow
                    ),
                  ],
                  color: Clr().primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dim().d24, vertical: Dim().d16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹ ${widget.totalValue}',
                          style: Sty().mediumText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Clr().white),
                        ),
                        Text(
                          'Total Payable',
                          style: Sty().mediumText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Clr().white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      width: 110,
                      child: ElevatedButton(
                          onPressed: () {
                            // STM().redirect2page(ctx, DrName());
                            paymentLab();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Clr().white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Text(
                            'Pay Now',
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
    );
  }

  Widget dateLayout(ctx, index, List) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 95,
            width: 80,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Clr().primaryColor,
                    side: BorderSide(color: Clr().borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nov',
                      style: Sty().smallText.copyWith(
                          fontWeight: FontWeight.w400, color: Clr().white),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '28',
                      style: Sty().mediumText.copyWith(
                          fontWeight: FontWeight.w600, color: Clr().white),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '2022',
                      style: Sty().smallText.copyWith(
                          fontWeight: FontWeight.w400, color: Clr().white),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  // getPatient
  void getPatient() async {
    var result = await STM().getWithTokenUrl(
        ctx, Str().loading, 'get_patient', usertoken, 'customer');
    var success = result['success'];
    if (success) {
      setState(() {
        patientlist = result['patients'];
      });
    }
  }

  // patientdetails
  Widget patientDetails(ctx, index, list) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dim().d16, vertical: Dim().d12),
      child: InkWell(
        onTap: () {
          if (patientDetailsList
              .map((e) => e['id'])
              .contains(list[index]['id'])) {
            setState(() {
              patientDetailsList.clear();
            });
          } else {
            setState(() {
              patientDetailsList.clear();
              patientDetailsList.add({
                'id': list[index]['id'],
                'name': list[index]['full_name'],
                'age': list[index]['age'],
              });
            });
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            patientDetailsList.map((e) => e['id']).contains(list[index]['id'])
                ? Container(
                    height: Dim().d16,
                    width: Dim().d16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Clr().primaryColor,
                    ),
                  )
                : Container(
                    height: Dim().d16,
                    width: Dim().d16,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Clr().white,
                        border: Border.all(color: Clr().hintColor)),
                  ),
            SizedBox(
              width: Dim().d8,
            ),
            SizedBox(
              width: Dim().d16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${list[index]['full_name']}',
                  style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                Text(
                  '${list[index]['gender']}, ${list[index]['age']} years',
                  style: Sty()
                      .mediumText
                      .copyWith(fontWeight: FontWeight.w400, color: Clr().grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // paynow
 void paymentLab() async {
    FormData body = FormData.fromMap({
    'patient_id': patientDetailsList[0]['id'],
    'lab_id': widget.labdetails[0]['id'],
    'charge': widget.totalValue,
    'coupon_code': '',
    'booking_date': datetime,
    'test_ids': jsonEncode(testids),
    'type': widget.type,
      'total':widget.totalValue,
    });
    var result = await STM().postWithToken(ctx, Str().processing, 'book_lab_appointment', body, usertoken, 'customer');
    var success = result['success'];
    var message = result['message'];
    if(success){
      STM().successDialogWithAffinity(ctx, message, Home());
    }else{
      STM().errorDialog(ctx, message);
    }
 }
}
