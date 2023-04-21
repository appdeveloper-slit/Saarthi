import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../dr_name.dart';
import '../manage/static_method.dart';

import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';

class PaymentSummary extends StatefulWidget {
  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    List<dynamic> dateList = [];
    bool isChecked = false;



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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                                    'NirAmaya Pathlabs',
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Mon - Sat',
                                            style: Sty().mediumText.copyWith(
                                                fontWeight: FontWeight.w500),
                                          ),


                                          Text(
                                            '10:30 Am to 10:30 Pm',
                                            style: Sty().mediumText.copyWith(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: Dim().d16),
                                        child: Text(
                                          '₹ 700',
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
                      Flexible(
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color(0xffcee8b0),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15))),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: Dim().d20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(

                                    children: [
                                      Icon(Icons.location_on_outlined),
                                      Text(
                                        'Vasant Lawns, DP Road, Opp. TCS, Subhash\n Nagar, Thane West, Thane, ...',maxLines: 2,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: Dim().d12,
            ),
            Padding(
              padding: EdgeInsets.only(left: Dim().d16),
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
              height: Dim().d8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d16,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Color(0xFFFBFBFB),
                    child: Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(top: Dim().d8,bottom: Dim().d16,left:Dim().d16,right: Dim().d16 ),
                          child: Column(
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Test 1',
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
                                        '₹ 500',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Sty().largeText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width:  Dim().d20,
                                      ),
                                      SvgPicture.asset('assets/cutpaysum.svg'),
                                    ],
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          height: 2,
                          thickness: 1.5,
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top: Dim().d8,bottom: Dim().d16,left:Dim().d16,right: Dim().d16 ),
                          child: Column(
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Test 1',
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
                                        '₹ 500',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Sty().largeText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width:  Dim().d20,
                                      ),
                                      SvgPicture.asset('assets/cutpaysum.svg'),
                                    ],
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color(0xFFFBFBFB),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
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
                                    SvgPicture.asset('assets/plusenew.svg'),
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
                            decoration:  BoxDecoration(

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 15,
                                  offset: Offset(0, 0), // changes position of shadow

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
                                    borderSide: BorderSide.none,borderRadius: BorderRadius.circular(5)
                                ),


                                fillColor: Clr().white,

                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Clr().primaryColor, width: 1.0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                // label: Text('Enter Your Number'),

                                hintText: "Enter coupon code",
                                hintStyle: Sty()
                                    .mediumText
                                    .copyWith(color: Clr().shimmerColor, fontSize: 14),
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
                              style: ElevatedButton.styleFrom( elevation: 0,
                                backgroundColor: Clr().primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              child: Text(
                                'APPLY',
                                style: Sty().smallText.copyWith(
                                    color: Clr().white, fontWeight: FontWeight.w600),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                                  padding:  EdgeInsets.only(left: Dim().d8),
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
                                padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Test Charges',
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      '₹1000',
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

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Discount',
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      '₹ 0',
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

                            ],
                          ),
                        ),

                        Divider(
                          height: 2,
                          thickness: 1.5,
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top: Dim().d2,bottom: Dim().d16,left:Dim().d16,right: Dim().d16 ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: Dim().d8,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: Sty().largeText.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '₹ 1000',
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
                          '₹ 1000',
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
                          },
                          style: ElevatedButton.styleFrom( elevation: 0,
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
                style: ElevatedButton.styleFrom( elevation: 0,

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
