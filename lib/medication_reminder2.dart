import 'package:flutter/material.dart';
import 'package:saarathi/values/dimens.dart';

import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'set_time.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class MedicationReminder2 extends StatefulWidget {
  @override
  State<MedicationReminder2> createState() => _MedicationReminder2State();
}

class _MedicationReminder2State extends State<MedicationReminder2> {
  late BuildContext ctx;

  bool isChecked = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;

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
          'Medication Reminder',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'At what time do you take your first dose?',
              style: Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,

                        fillColor: MaterialStateProperty.all(Clr().primaryColor),
                        value: isChecked,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Text(
                            'Morning',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            overflow: TextOverflow.fade,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,

                        fillColor: MaterialStateProperty.all(Clr().primaryColor),
                        value: isChecked1,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked1 = value!;
                          });
                        },
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Text(
                            'Afternoon',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            overflow: TextOverflow.fade,
                          ))
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,

                        fillColor: MaterialStateProperty.all(Clr().primaryColor),
                        value: isChecked2,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked2 = value!;
                          });
                        },
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Text(
                            'Evening',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            overflow: TextOverflow.fade,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,

                        fillColor: MaterialStateProperty.all(Clr().primaryColor),
                        value: isChecked3,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked3 = value!;
                          });
                        },
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Text(
                            'Night',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            overflow: TextOverflow.fade,
                          ))
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      STM().redirect2page(ctx, SetTime());
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
                      'Next',
                      style: Sty().mediumText.copyWith(
                        color: Clr().white,
                        fontWeight: FontWeight.w600,),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
