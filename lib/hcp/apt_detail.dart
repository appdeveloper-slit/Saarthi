import 'package:flutter/material.dart';
import 'package:saarathi/values/dimens.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/styles.dart';

class AptDetail extends StatefulWidget {
  final Map<String, dynamic> data;

  const AptDetail(this.data, {Key? key}) : super(key: key);

  @override
  State<AptDetail> createState() => AptDetailState();
}

class AptDetailState extends State<AptDetail> {
  late BuildContext ctx;

  Map<String, dynamic> v = {};

  @override
  void initState() {
    v = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Clr().white,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Icon(
            Icons.arrow_back,
            color: Clr().black,
          ),
        ),
        centerTitle: true,
        title: Text(
          '${v['patient_name']}',
          style: Sty().largeText.copyWith(color: Clr().black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                ClipOval(
                  child: STM().imageView(
                    v['patient_image'],
                    width: Dim().d100,
                    height: Dim().d100,
                  ),
                ),
                SizedBox(
                  width: Dim().d20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Appointment ID : ',
                          style: Sty().smallText,
                        ),
                        Text(
                          '${v['apt_id']}',
                          style: Sty().smallText.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color(0xffFFC107),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Mr. ${v['patient_name']}',
                      style: Sty().smallText,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'Male',
                          style: Sty().smallText.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: Dim().d20,
                        ),
                        Text(
                          'Age : 24',
                          style: Sty().smallText.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Online Consultation',
                      style: Sty().smallText.copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            const Divider(),
            SizedBox(
              height: 8,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Clr().primaryColor,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Dim().d16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BOOKING TIME',
                          style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w600, color: Clr().white),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'BOOKING DATE',
                          style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w600, color: Clr().white),
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      decoration: BoxDecoration(color: Clr().white),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${v['time']}',
                          style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w600, color: Clr().white),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${v['date']}',
                          style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w600, color: Clr().white),
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
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    // STM().redirect2page(ctx, PersonalInfo());
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Video Call',
                    style: Sty().mediumText.copyWith(
                      color: Clr().white,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    // STM().redirect2page(ctx, OLConsultationDetails2());
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Complete Appointment',
                    style: Sty().mediumText.copyWith(
                      color: Clr().white,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum ',
              style: Sty().smallText,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Contact Support',
              style: Sty().mediumText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}