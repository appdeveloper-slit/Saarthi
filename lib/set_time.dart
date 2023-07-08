import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'medication_reminder.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class SetTime extends StatefulWidget {
  final String? medicine;
  final List<dynamic>? days;
  final List<dynamic>? timelist;
  final String? id;
  const SetTime({super.key, this.medicine, this.days,this.timelist,this.id});

  @override
  State<SetTime> createState() => _SetTimeState();
}

class _SetTimeState extends State<SetTime> {
  late BuildContext ctx;
  DateTime dateTime = DateTime.now();
  List<dynamic> timeList = [];
  var time;
  var showtime;
  String? usertoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
      timeList = widget.timelist ?? [];
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
            'Set Time',
            style: Sty().largeText.copyWith(
                color: Clr().appbarTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: Dim().d52,
            ),
            // buildDatePicker(),

            TimePickerSpinner(
              spacing: Dim().d80,
              is24HourMode: false,
              isShowSeconds: false,
              normalTextStyle: TextStyle(fontSize: Dim().d24),
              highlightedTextStyle: TextStyle(color: Clr().primaryColor,fontSize: Dim().d24,),
              onTimeChange: (value){
                setState(() {
                  time = DateFormat.jm().format(value);
                  print(DateFormat.jm().format(value));
                });
              },
            ),
            SizedBox(
              height: Dim().d14,
            ),
            SizedBox(
              height: Dim().d32,
              child: ListView.builder(
                  itemCount: timeList.length + 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return index == timeList.length ?  Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Clr().primaryColor, // foreground (text) color
                          ),
                          onPressed: () {
                            setState(() {
                              timeList.add(time);
                              print(timeList);
                            });
                          },
                          child: Text(
                            'Add Time',
                            style: Sty().mediumText.copyWith(color: Clr().white),
                          )),
                    ) : Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dim().d8),
                              border: Border.all(color: Clr().hintColor),
                              color: Clr().lightGrey,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d12, vertical: Dim().d4),
                              child: Text(
                                timeList[index].toString(),
                                style: Sty().mediumText,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -8,
                            right: -5,
                            child: InkWell(onTap: (){
                              setState(() {
                                timeList.removeAt(index);
                              });
                            },
                              child: Icon(Icons.dangerous_rounded, color: Clr().primaryColor),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: Dim().d52,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      timeList.isEmpty ? STM().displayToast('Add time for medication reminder') : widget.id == null ? addReminder() : editaddReminder(widget.id);
                      print(jsonEncode(widget.days));
                      print(jsonEncode(timeList));
                      print(widget.medicine);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      widget.id == null ? 'Done' : 'Update',
                      style: Sty().mediumText.copyWith(
                            color: Clr().white,
                            fontWeight: FontWeight.w600,
                          ),
                    )),
              ),
            ),
          ],
        ));
  }

  Widget buildDatePicker() => SizedBox(
        height: 190,
        child: CupertinoDatePicker(
          initialDateTime: dateTime,
          backgroundColor: Clr().white,
          use24hFormat: true,
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: (DateTime value) {
            time = DateFormat.Hm().format(value);
            print(DateFormat.Hm().format(value));
          },
        ),
      );


  void addReminder() async {
    FormData body = FormData.fromMap({
      "medicine": widget.medicine,
      "day": jsonEncode(widget.days),
      "time": jsonEncode(timeList),
    });
    var result = await STM().postWithToken(ctx, Str().processing, 'addReminder', body, usertoken,'customer');
    var success = result['status'];
    var message = result['message'];
    if(success){
      STM().successDialogWithAffinity(ctx, message, Home());
    }else{
      STM().errorDialog(ctx, message);
    }
  }

  void editaddReminder(id) async {
    FormData body = FormData.fromMap({
      "medicine": widget.medicine,
      "day": jsonEncode(widget.days),
      "time": jsonEncode(timeList),
      "reminder_time_id": id,
    });
    var result = await STM().postWithToken(ctx, Str().updating, 'editReminder', body, usertoken,'customer');
    var success = result['status'];
    var message = result['message'];
    if(success){
      STM().successDialogWithAffinity(ctx, message, Home());
    }else{
      STM().errorDialog(ctx, message);
    }
  }

}
