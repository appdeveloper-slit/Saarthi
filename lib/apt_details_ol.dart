import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'apt_details_telecall.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class AppointmentDetails extends StatefulWidget {
  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  late BuildContext ctx;

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
          'Appointment Details',
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
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/dr1.png'),
                ),
                SizedBox(
                  width: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment ID : #12234',
                      style: Sty()
                          .mediumText
                          .copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: Dim().d4,),
                    Text(
                      'Dr.Mansi Janl',
                      style: Sty()
                          .mediumText
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: Dim().d4,),
                    Text(
                      'Nutritionist',
                      style: Sty()
                          .mediumText
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: Dim().d4,),
                    Text(
                      'Pending',
                      style: Sty()
                          .mediumText
                          .copyWith(
                          color: Color(0xffFFC107),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            const Divider(),
            SizedBox(
              height: 12,
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
                              color: Clr().white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'BOOKING DATE',
                          style: Sty().mediumText.copyWith(
                              color: Clr().white,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Container(
                      height: 50,
                      width: 1.5,
                      decoration: BoxDecoration(color: Color(0xffECFFDB)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '01 : 00 PM',
                          style: Sty().mediumText.copyWith(
                              color: Clr().white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '28 Nov 2022',
                          style: Sty().mediumText.copyWith(
                              color: Clr().white,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Appointment type',
              style: Sty().largeText.copyWith(
                  fontWeight: FontWeight.w600, color: Clr().primaryColor),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Online Consultation',
              style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Payment Details',
              style: Sty().largeText.copyWith(
                  fontWeight: FontWeight.w600, color: Clr().primaryColor),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Consultation Fee',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  '₹500',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GST',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  '₹90',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  '₹90',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount Payable',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '₹590',
                  style:
                  Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Clr().borderColor,
                  
                )
              ),
              elevation: 0,
              color: Clr().formfieldbg,
              child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d16,vertical: Dim().d16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    children: [
                      SvgPicture.asset('assets/invoice.svg',width: 20,),
                      SizedBox(width: 12,),
                      Text(
                        'Invoice download',
                        style:
                        Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SvgPicture.asset('assets/arrow_black.svg'),
                ],
              ),
            ),),
            SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      STM().redirect2page(ctx, TeleCallAppointmentDetails());
                    },
                    style: ElevatedButton.styleFrom( elevation: 0,
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10))),
                    child: Text(
                      'Cancel Appointment',
                      style: Sty().mediumText.copyWith(
                        color: Clr().white,
                        fontWeight: FontWeight.w600,),
                    )),
              ),
            ),
            SizedBox(height: 20,),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum ',
              textAlign: TextAlign.center,
              style:
              Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text(
                'Contact Support',
                style:
                Sty().mediumText.copyWith(
                    color: Clr().primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
