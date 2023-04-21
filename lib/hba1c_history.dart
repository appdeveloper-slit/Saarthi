import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/values/dimens.dart';

import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'oxygen_history.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class HbA1cHistory extends StatefulWidget {
  @override
  State<HbA1cHistory> createState() => _HbA1cHistoryState();
}

class _HbA1cHistoryState extends State<HbA1cHistory> {
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
        String s = STM().dateFormat('dd-MM-yyyy', picked);
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
        String s = STM().dateFormat('dd-MM-yyyy', picked);
        dobCtrl1 = TextEditingController(text: s);
      });
    }
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
          'HbA1c',
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
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HbA1c',
                        style: Sty()
                            .largeText
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 12,),
            const Divider(),
            SizedBox(height: 20,),
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
                SizedBox(width: Dim().d8,),
                Text('to',
                  style: Sty().mediumText,),
                SizedBox(width: Dim().d8,),
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
            SizedBox(height: 30,),
            Text('History',style: Sty().largeText.copyWith(
              fontSize: 20,
            ),),
            SizedBox(height: 20,),

            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 8,
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
              '14-12-2022',
              style: Sty()
                  .mediumText
                  .copyWith(fontWeight: FontWeight.w400),
            ),
            Text(
              '19mg/dl 1 mmoI/L',
              style: Sty()
                  .smallText
                  .copyWith(fontWeight: FontWeight.w400,
                  color: Color(0xff70D4FF)),
            ),
          ],),
        SizedBox(height: 20,)
      ],
    );

  }
}
