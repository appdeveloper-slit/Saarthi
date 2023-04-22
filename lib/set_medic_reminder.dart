import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'medication_reminder.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class SetMedicReminder extends StatefulWidget {
  final List<dynamic>? remiderlist;

  const SetMedicReminder({super.key, this.remiderlist});

  @override
  State<SetMedicReminder> createState() => _SetMedicReminderState();
}

class _SetMedicReminderState extends State<SetMedicReminder> {
  late BuildContext ctx;

  List<dynamic> dayList = [
    {"id": "0", "name": "Sunday"},
    {"id": "1", "name": "Monday"},
    {"id": "2", "name": "Tuesday"},
    {"id": "3", "name": "Wednesday"},
    {"id": "4", "name": "Thursday"},
    {"id": "5", "name": "Friday"},
    {"id": "6", "name": "Saturday"},
  ];
  String? usertoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        // getHome();
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
    return WillPopScope(onWillPop: () async{
      STM().finishAffinity(ctx, Home());
      return false;
    },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            STM().redirect2page(ctx, MedicationReminder());
          },
          backgroundColor: Clr().primaryColor,
          child: Icon(
            Icons.add,
            size: Dim().d32,
          ),
        ),
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Clr().white,
          leading: InkWell(
            onTap: () {
              STM().finishAffinity(ctx, Home());
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Clr().appbarTextColor,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Set Medication Reminder',
            style: Sty().largeText.copyWith(
                color: Clr().appbarTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.remiderlist!.length,
                itemBuilder: (context, index) {
                  return reminderList(ctx, index, widget.remiderlist);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Medication Reminder
  Widget reminderList(ctx, index, list) {
    List<dynamic> dayidList = list[index]['day_id'] ?? [];
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Clr().shimmerColor.withOpacity(0.1),
            spreadRadius: 0.1,
            blurRadius: 12,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Clr().borderColor)),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Wrap(
                    children: [
                      Text(
                        list[index]['medicine'].toString(),
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        list[index]['time'].toString(),
                        style:
                            Sty().smallText.copyWith(color: Clr().primaryColor),
                      ),
                    ],
                  ),
                  SizedBox(width: Dim().d20),
                  Wrap(
                    children: [
                      SvgPicture.asset('assets/edit.svg'),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      InkWell(
                          onTap: () {
                            deleteReminder(id: list[index]['id'], index: index);
                          },
                          child: SvgPicture.asset('assets/delete.svg')),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: Dim().d4,
              ),
              ListView.builder(
                  itemCount: dayidList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index2) {
                    return Row(
                      children: [
                        Text(
                          dayList[int.parse(dayidList[index2])]['name'].toString(),
                          style: Sty()
                              .smallText
                              .copyWith(color: Clr().primaryColor),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // delete reminder

  void deleteReminder({id, index}) async {
    FormData body = FormData.fromMap({
      'id': id,
    });
    var result = await STM()
        .postWithToken(ctx, Str().deleting, 'deleteReminder', body, usertoken,'customer');
    var success = result['status'];
    var message = result['message'];
    if (success) {
      setState(() {
        STM().displayToast(message);
        widget.remiderlist!.removeAt(index);
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

}
