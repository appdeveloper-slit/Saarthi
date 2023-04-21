import 'package:flutter/material.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'apt_details_ol.dart';
import 'bottom_navigation/bottom_navigation.dart';

class MyAppointments extends StatefulWidget {
  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments>
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
        bottomNavigationBar: bottomBarLayout(ctx, 1),
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
            'My Appointments',
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
                            elevation: 0,
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
                              itemCount: 4,
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
                                              ctx, AppointmentDetails());
                                        },
                                        child:  Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Clr().grey.withOpacity(0.1),
                                                spreadRadius: 0.1,
                                                blurRadius: 12,
                                                offset: Offset(0, 8), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            color: Clr().formfieldbg,
                                            margin: EdgeInsets.only(top: Dim().d12),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Dim().d12),
                                                side: BorderSide(
                                                    color: Clr().borderColor)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    child: Image.asset(
                                                      'assets/dr.png',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Dim().d12,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Dr.Mansi Janl',
                                                          style: Sty()
                                                              .mediumText
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          'Nutritionist',
                                                          style: Sty()
                                                              .smallText
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '18-07-2022',
                                                              style: Sty()
                                                                  .smallText
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                            Text(
                                                              '11:30 AM',
                                                              style: Sty()
                                                                  .smallText
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          'Pending',
                                                          style: Sty()
                                                              .smallText
                                                              .copyWith(
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                color: Color(
                                                                    0xffFFC107),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                              ctx, AppointmentDetails());
                                        },
                                        child:  Container(
                                          decoration: BoxDecoration(

                                            boxShadow: [
                                              BoxShadow(
                                                color: Clr().grey.withOpacity(0.1),
                                                spreadRadius: 0.1,
                                                blurRadius: 12,
                                                offset: Offset(0, 8), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            color: Clr().formfieldbg,
                                            margin: EdgeInsets.only(top: Dim().d12),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Dim().d12),
                                                side: BorderSide(
                                                    color: Clr().borderColor)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    child: Image.asset(
                                                      'assets/dr.png',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Dim().d20,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Dr.Mansi Janl',
                                                          style: Sty()
                                                              .mediumText
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          'Nutritionist',
                                                          style: Sty()
                                                              .smallText
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '18-07-2022',
                                                              style: Sty()
                                                                  .smallText
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                            Text(
                                                              '11:30 AM',
                                                              style: Sty()
                                                                  .smallText
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          'Pending',
                                                          style: Sty()
                                                              .smallText
                                                              .copyWith(
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                color: Color(
                                                                    0xffFFC107),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                            elevation: 0,
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
                                    "Darshan Jadhav",
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
                              itemCount: 4,
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
                                              ctx, AppointmentDetails());
                                        },
                                        child:  Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Clr().grey.withOpacity(0.1),
                                                spreadRadius: 0.1,
                                                blurRadius: 12,
                                                offset: Offset(0, 8), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            color: Clr().formfieldbg,
                                            margin: EdgeInsets.only(top: Dim().d12),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Dim().d12),
                                                side: BorderSide(color: Clr().borderColor)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    child: Image.asset(
                                                      'assets/dr.png',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Dim().d12,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Dr.Mansi Janl',
                                                          style: Sty()
                                                              .mediumText
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          'Nutritionist',
                                                          style: Sty()
                                                              .smallText
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '18-07-2022',
                                                              style: Sty()
                                                                  .smallText
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                            Text(
                                                              '11:30 AM',
                                                              style: Sty()
                                                                  .smallText
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          'Completed',
                                                          style: Sty()
                                                              .smallText
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Clr()
                                                                      .primaryColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                              ctx, AppointmentDetails());
                                        },
                                        child:  Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Clr().grey.withOpacity(0.1),
                                                spreadRadius: 0.1,
                                                blurRadius: 12,
                                                offset: Offset(0, 8), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            color: Clr().formfieldbg,
                                            margin: EdgeInsets.only(top: Dim().d12),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Dim().d12),
                                                side: BorderSide(color: Clr().borderColor)
                                             ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    child: Image.asset(
                                                      'assets/dr.png',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Dim().d20,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Dr.Mansi Janl',
                                                          style: Sty()
                                                              .mediumText
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          'Nutritionist',
                                                          style: Sty()
                                                              .smallText
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '18-07-2022',
                                                              style: Sty()
                                                                  .smallText
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                            Text(
                                                              '11:30 AM',
                                                              style: Sty()
                                                                  .smallText
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          'Cancelled',
                                                          style: Sty()
                                                              .smallText
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Clr().red),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
