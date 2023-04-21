import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarathi/manage/static_method.dart';
import 'package:saarathi/values/dimens.dart';

import 'bottom_navigation/bottom_navigation.dart';
import 'dr_name.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class Nutritionist extends StatefulWidget {
  @override
  State<Nutritionist> createState() => _NutritionistState();
}

class _NutritionistState extends State<Nutritionist> {
  late BuildContext ctx;

  List<dynamic>  nutritionistList = [];

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return  Scaffold(
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
        actions: [
          Padding(
            padding: EdgeInsets.all(Dim().d16),
            child: SvgPicture.asset('assets/filter.svg'),
          )
        ],
        centerTitle: true,
        title: Text(
          'Nutritionist',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        physics: BouncingScrollPhysics(),
        child: Column(
          children:[
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return nutritionistLayout(ctx, index, nutritionistList);
            },
          ),

          ],
        ),
      ),

    );
  }

  Widget nutritionistLayout(ctx, index, List){
    return  Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 0.6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Clr().borderColor)),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/dr.png',
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Dr.Devina Rajput',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SvgPicture.asset('assets/map_pin.svg'),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '1 KM',
                                  style: Sty().smallText.copyWith(
                                      color: Clr().primaryColor,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Nutritionist',
                          style: Sty()
                              .smallText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Speaks : English, Hindi, +1',
                          style: Sty()
                              .smallText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),

                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          '13 Years of experience',
                          style: Sty()
                              .smallText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Dombivali (w)',
                          style: Sty()
                              .smallText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Booking prices',
                  style: Sty()
                      .mediumText
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 8,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Wrap(
                    children: [
                      SvgPicture.asset('assets/online_consultation.svg'),
                      SizedBox(
                        width: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Online',
                            style: Sty()
                                .smallText
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 4,),
                          Text(
                            '₹ 500',
                            style:
                            Sty().smallText.copyWith(color: Clr().primaryColor),
                          ),

                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Wrap(
                    children: [
                      SvgPicture.asset('assets/home_visit.svg'),
                      SizedBox(
                        width: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Home Visit',
                            style: Sty()
                                .smallText
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 4,),
                          Text(
                            '₹ 500',
                            style:
                            Sty().smallText.copyWith(color: Clr().primaryColor),
                          ),

                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Wrap(
                    children: [
                      SvgPicture.asset('assets/tele_call.svg'),
                      SizedBox(
                        width: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tele_call',
                            style: Sty()
                                .smallText
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 4,),
                          Text(
                            '₹ 500',
                            style:
                            Sty().smallText.copyWith(color: Clr().primaryColor),
                          ),

                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      STM().redirect2page(ctx, DrName());
                    },
                    style: ElevatedButton.styleFrom( elevation: 0,
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Book Appointment',
                      style: Sty().mediumText.copyWith(
                        color: Clr().white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}