import 'package:flutter/material.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'booking_details .dart';
import 'bottom_navigation/bottom_navigation.dart';

class MyBooking extends StatefulWidget {
  @override
  _MyBookingState createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking>
    with SingleTickerProviderStateMixin {
  late BuildContext ctx;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return WillPopScope(onWillPop: () async {
      STM().back2Previous(ctx);
      return false;
    },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 2),
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
            'My Booking',
            style: Sty()
                .largeText
                .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              // give the tab bar a height [can change hheight to preferred height]
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: Dim().d40,
                  width: MediaQuery.of(context).size.width * 0.70,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: TabBar(
                    physics: BouncingScrollPhysics(),
                    labelStyle: TextStyle(fontSize: 18),
                    controller: _tabController,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: Color(0xff80C342),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      // first tab [you can add an icon using the icon property]
                      Tab(
                        text: 'Upcoming',
                      ),

                      // second tab [you can add an icon using the icon property]
                      Tab(
                        text: 'Completed',
                      ),
                    ],
                  ),
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // first tab bar view widget
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Dim().d20,
                          ),
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.only(
                                left: Dim().d12, right: Dim().d12),
                            child: ExpansionTile(
                              collapsedIconColor: Colors.black,
                              iconColor: Colors.black,
                              textColor: Colors.black,
                              collapsedTextColor: Colors.black,
                              backgroundColor: Clr().background,
                              collapsedBackgroundColor: Clr().background,
                              title: Text(
                                "Aniket Mahakal",
                                style: TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w500),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    "demo2",
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dim().d4,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: 2,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      child: InkWell(
                                        onTap: () {
                                          STM().redirect2page(
                                              ctx, BookingDetails());
                                        },
                                        child: Card(
                                          color: Clr().background,
                                          margin: EdgeInsets.only(top: Dim().d12),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  Dim().d12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/mybooking.png',
                                                    height: 70,
                                                    width: 110),
                                                SizedBox(
                                                  width: Dim().d12,
                                                ),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('NirAmaya Pathlabs',
                                                            style: Sty()
                                                                .mediumText
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xff2D2D2D))),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Dim().d4,
                                                    ),
                                                    Text('Dombivli',
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('18-07-2022',
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                        Text('11:30 AM',
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                    Text('Pending',
                                                        style: Sty()
                                                            .mediumText
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                                color: Color(
                                                                    0xffFFC107))),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      child: InkWell(
                                        onTap: () {
                                          STM().redirect2page(
                                              ctx, BookingDetails());
                                        },
                                        child: Card(
                                          color: Clr().background,
                                          margin: EdgeInsets.only(top: Dim().d12),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  Dim().d12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/mybooking.png',
                                                    height: 70,
                                                    width: 110),
                                                SizedBox(
                                                  width: Dim().d12,
                                                ),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('NirAmaya Pathlabs',
                                                            style: Sty()
                                                                .mediumText
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xff2D2D2D))),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Dim().d4,
                                                    ),
                                                    Text('Dombivali',
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('18-07-2022',
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                        Text('11:30 AM',
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                    Text('Pending',
                                                        style: Sty()
                                                            .mediumText
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                                color: Color(
                                                                    0xffFFC107))),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // second tab bar view widget
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Dim().d20,
                          ),
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.only(
                                left: Dim().d12, right: Dim().d12),
                            child: ExpansionTile(
                              collapsedIconColor: Colors.black,
                              iconColor: Colors.black,
                              textColor: Colors.black,
                              collapsedTextColor: Colors.black,
                              backgroundColor: Clr().background,
                              collapsedBackgroundColor: Clr().background,
                              title: Text(
                                "Aniket Mahakal",
                                style: TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w500),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    "demo2",
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dim().d4,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: 10,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      child: InkWell(
                                        onTap: () {
                                          STM().redirect2page(
                                              ctx, BookingDetails());
                                        },
                                        child: Card(
                                          color: Clr().background,
                                          margin: EdgeInsets.only(top: Dim().d12),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  Dim().d12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/mybooking.png',
                                                    height: 70,
                                                    width: 110),
                                                SizedBox(
                                                  width: Dim().d12,
                                                ),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('NirAmaya Pathlabs',
                                                            style: Sty()
                                                                .mediumText
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xff2D2D2D))),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Dim().d4,
                                                    ),
                                                    Text('Dombivali',
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('18-07-2022',
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                        Text('11:30 AM',
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                    Text('Completed',
                                                        style: Sty()
                                                            .mediumText
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                                color: Color(
                                                                    0xff80C342))),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      child: InkWell(
                                        onTap: () {
                                          STM().redirect2page(
                                              ctx, BookingDetails());
                                        },
                                        child: Card(
                                          color: Clr().background,
                                          margin: EdgeInsets.only(top: Dim().d12),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  Dim().d12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/mybooking.png',
                                                    height: 70,
                                                    width: 110),
                                                SizedBox(
                                                  width: Dim().d12,
                                                ),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('NirAmaya Pathlabs',
                                                            style: Sty()
                                                                .mediumText
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xff2D2D2D))),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Dim().d4,
                                                    ),
                                                    Text('Dombivali',
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('18-07-2022',
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                        Text('11:30 AM',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                    Text('Cancelled',
                                                        style: Sty()
                                                            .mediumText
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                                color: Color(
                                                                    0xffC20909))),
                                                    SizedBox(
                                                      height: Dim().d8,
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
      ),
    );
  }
}
