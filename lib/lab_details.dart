import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'payment_summary.dart';

class LabsDetails extends StatefulWidget {
  @override
  State<LabsDetails> createState() => _LabsDetailsState();
}

class _LabsDetailsState extends State<LabsDetails> {
  late BuildContext ctx;
  int _selectedIndex = 0;

  final List<String> _wordName = [
    "Lab Visit",
    "Home Collection",
  ];

  final items = [
    'Complete urine examination',
    'Complete urine examination2',

  ];

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0),
      backgroundColor: Clr().white,
      appBar: AppBar(
          elevation: 2,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Icon(
            Icons.arrow_back,
            color: Clr().black,
          ),
        ),
        title: Text(
          'NirAmaya Pathlabs',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(Dim().d8),
            child: InkWell(
                onTap: () {
                  // STM().redirect2page(context, Pharmacy());
                },
                child: SvgPicture.asset('assets/search.svg')),
          ),
          SizedBox(
            width: 20,
          ),
        ],
        backgroundColor: Clr().white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.22,
              color: Color(0xff80C342),
              alignment: Alignment.center,
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.18,
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
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15))),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: Dim().d20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
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
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 40,
                  width: 280,
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    itemCount: 2,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 40,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _selectedIndex == index? SvgPicture.asset('assets/myaddDot.svg'):
                            SvgPicture.asset('assets/selectDrop.svg'),
                            // Icon(_selectedIndex == index
                            //     ?Icons.check_circle_outline_rounded :
                            // Icons.circle_outlined,
                            //     color: _selectedIndex == index
                            //         ? Color(0xffFA3C5A)
                            //         : Colors.grey),

                            Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Text(_wordName[index],
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),



            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color(0xFFFBFBFB),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Lab Address',
                              style: Sty().largeText.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    // fontFamily: Outfit
                                  ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Vasant Lawns, DP Road, Opp. TCS, Subhash Nagar, Thane West, Thane, Maharashtra 400606',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Card(
                    elevation: 0,
                    child:  Text(
                      'Select Test :',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ) ,
                  ),
                  Divider(),
                  ListView.builder(
                    padding: EdgeInsets.zero,

                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0.5,

                        child: ExpansionTile(
                          backgroundColor: Clr().white ,
                          collapsedBackgroundColor: Colors.white,


                          title: ListTile(
                              minLeadingWidth : 5,
                              leading:Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SvgPicture.asset('assets/check box.svg'),
                              ),
                              title: Text(items[index],style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color:Clr().black)),
subtitle:Text('5 tests included',
    style: TextStyle(
      fontSize: 16,
      color: Colors.grey,
    )),
                          ),
                          // leading: Icon(Icons.local_pizza),

                          onExpansionChanged:(value) {
                            Icon(Icons.arrow_drop_up,size: 30);
                          },
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Column(

                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: Dim().d72),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset('assets/dot.svg'),
                                          SizedBox(width: Dim().d8,),
                                          Text('Colour',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              )),

                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Dim().d8,),
                                    Padding(
                                      padding: EdgeInsets.only(left: Dim().d72),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset('assets/dot.svg'),
                                          SizedBox(width: Dim().d8,),
                                          Text('RBC',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              )),

                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Dim().d8,),
                                    Padding(
                                      padding: EdgeInsets.only(left: Dim().d72),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset('assets/dot.svg'),
                                          SizedBox(width: Dim().d8,),
                                          Text('PUS Cells',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              )),

                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Dim().d8,),
                                  ],
                                ),

                              ],
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Dim().d16),
                    child: Text(
                      'Test Requirements',
                      style: Sty()
                          .mediumText
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 100,
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Color(0xFFFBFBFB),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Test Sample',
                              style: Sty().smallText.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Clr().primaryColor),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Blood and Urine samples',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d24,
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
                    Text(
                      '₹ 590',
                      style: Sty().mediumText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Clr().white),
                    ),
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: ElevatedButton(
                          onPressed: () {
                            STM().redirect2page(ctx, PaymentSummary());
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
}
