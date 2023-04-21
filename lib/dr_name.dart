import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/values/dimens.dart';

import 'add_new_patient.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class DrName extends StatefulWidget {
  @override
  State<DrName> createState() => _DrNameState();
}

class _DrNameState extends State<DrName> {
  late BuildContext ctx;

  int selected = -1;

  bool isChecked = false;

  String AppointmentValue = 'Online Appointment';
  List<String> AppointmentList = [
    'Online Appointment',
    'Home Visit',
  ];
  String t = "0";

  List<dynamic> dateList = [];

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
          'Dr. Mansi Janl',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/dr1.png',
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Dr.Mansi Janl',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w600),
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
                          'Dombivali (w)',
                          style: Sty()
                              .smallText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Experience : 9 Years',
                          style: Sty()
                              .smallText
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            const Divider(),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d16),
              child: SizedBox(
                height: 100,
                width: MediaQuery.of(ctx).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 50,
                  itemBuilder: (context, index) {
                    return dateLayout(ctx, index, dateList);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select appointment type',
                  style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d16),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Clr().grey)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: AppointmentValue,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 28,
                      color: Clr().grey,
                    ),
                    style: TextStyle(color: Color(0xff787882)),
                    items: AppointmentList.map((String string) {
                      return DropdownMenuItem<String>(
                        value: string,
                        child: Text(
                          string,
                          style:
                              TextStyle(color: Color(0xff787882), fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (t) {
                      // STM().redirect2page(ctx, Home());
                      setState(() {
                        AppointmentValue = t!;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Patient',
                    style:
                        Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Wrap(
                    children: [
                      SvgPicture.asset('assets/add.svg'),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Add New',
                        style:
                            Sty().smallText.copyWith(color: Clr().primaryColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    width: Dim().d8,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Clr().primaryColor),
                    child: Center(
                        child: Text(
                      'AM',
                      style: Sty().mediumText.copyWith(
                          color: Clr().white, fontWeight: FontWeight.w600),
                    )),
                  ),
                  SizedBox(
                    width: Dim().d16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aniket Mahakal',
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Male, 21 years',
                        style: Sty().mediumText.copyWith(
                            fontWeight: FontWeight.w400, color: Clr().grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Clr().grey),
                      ),
                      SizedBox(
                        width: Dim().d4,
                      ),
                      Text(
                        'Booked',
                        style: Sty()
                            .smallText
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Clr().white,
                            border: Border.all(color: Clr().primaryColor)),
                      ),
                      SizedBox(
                        width: Dim().d4,
                      ),
                      Text(
                        'Available',
                        style: Sty()
                            .smallText
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffFFC107)),
                      ),
                      SizedBox(
                        width: Dim().d4,
                      ),
                      Text(
                        'Unavailable',
                        style: Sty()
                            .smallText
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 50,
                ),
                itemCount: 17,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: index == selected
                              ? Clr().primaryColor
                              : Clr().transparent,
                          borderRadius: BorderRadius.circular(Dim().d8),
                          border: Border.all(color: Clr().primaryColor)),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selected = index;
                          });
                          // STM().redirect2page(ctx, Electronics(categoryList[index]['id'].toString()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '09 : 00 AM',
                              style: Sty().smallText.copyWith(
                                  color: index == selected
                                      ? Clr().white
                                      : Clr().primaryColor,
                                  fontWeight: FontWeight.w600),
                              // categoryList[index]['name'].toString(),
                              // overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
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
                    Text(
                      'Fees : ₹ 200',
                      style: Sty().mediumText.copyWith(
                          fontWeight: FontWeight.w600, color: Clr().white),
                    ),
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: ElevatedButton(
                          onPressed: () {
                            STM().redirect2page(ctx, AddNewPatient());
                          },
                          style: ElevatedButton.styleFrom( elevation: 0,
                            backgroundColor: Clr().white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Text(
                            'Proceed',
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

  //Date
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
                    elevation: 0.7,
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
}
