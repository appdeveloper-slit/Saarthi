import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/strings.dart';
import '../values/styles.dart';
import 'apt_detail.dart';

class OnlineAppointment extends StatefulWidget {
  @override
  State<OnlineAppointment> createState() => _OnlineAppointmentState();
}

class _OnlineAppointmentState extends State<OnlineAppointment>
    with TickerProviderStateMixin {
  late BuildContext ctx;

  TabController? tabCtrl;

  List<dynamic> todayList = [
    {
      'id': 1,
      'apt_id': 123456,
      'patient_id': 1,
      'patient_name': 'Aniket Mahakal',
      'patient_image': 'assets/dr1.png',
      'date': 'Sunday, 12/11/2022',
      'time': '03 : 30PM',
    },
    {
      'id': 2,
      'apt_id': 123456,
      'patient_id': 1,
      'patient_name': 'Aniket Mahakal',
      'patient_image': 'assets/dr1.png',
      'date': 'Monday, 13/11/2022',
      'time': '03 : 30PM',
    },
  ];
  List<dynamic> upcomingList = [
    {
      'id': 1,
      'apt_id': 123456,
      'patient_id': 1,
      'patient_name': 'Aniket Mahakal',
      'patient_image': 'assets/dr1.png',
      'date': 'Sunday, 12/11/2022',
      'time': '03 : 30PM',
    },
    {
      'id': 2,
      'apt_id': 123456,
      'patient_id': 1,
      'patient_name': 'Aniket Mahakal',
      'patient_image': 'assets/dr1.png',
      'date': 'Monday, 13/11/2022',
      'time': '03 : 30PM',
    },
  ];
  List<dynamic> historyList = [
    {
      'id': 1,
      'apt_id': 123456,
      'patient_id': 1,
      'patient_name': 'Aniket Mahakal',
      'patient_image': 'assets/dr1.png',
      'date': 'Sunday, 12/11/2022',
      'time': '03 : 30PM',
    },
    {
      'id': 2,
      'patient_id': 1,
      'patient': 123456,
      'patient_name': 'Aniket Mahakal',
      'patient_image': 'assets/dr1.png',
      'date': 'Monday, 13/11/2022',
      'time': '03 : 30PM',
    },
  ];

  String? sToken;

  @override
  void initState() {
    tabCtrl = TabController(length: 3, vsync: this);
    // getSession();
    super.initState();
  }

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sToken = sp.getString('customerId') ?? '';
      STM().checkInternet(context, widget).then((value) {
        if (value) {
          getData();
        }
      });
    });
  }

  //Api method
  void getData() async {
    //Input
    FormData body = FormData.fromMap({
      'page_type': 'register',
    });
    //Output
    var result = await STM()
        .postWithToken(ctx, Str().loading, "sendOTP", body, sToken, 'hcp');
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
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
          'Online Appointment',
          style: Sty().largeText.copyWith(color: Clr().black),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Clr().lightGrey,
                ),
              ),
            ),
            child: TabBar(
                controller: tabCtrl,
                labelColor: Clr().primaryColor,
                indicatorColor: Clr().primaryColor,
                automaticIndicatorColorAdjustment: true,
                unselectedLabelColor: Colors.black,
                labelStyle: Sty().mediumText,
                tabs: [
                  Tab(
                    text: "Today",
                    height: Dim().d60,
                  ),
                  Tab(
                    text: 'Upcoming',
                    height: Dim().d60,
                  ),
                  Tab(
                    text: 'History',
                    height: Dim().d60,
                  ),
                ]),
          ),
          SizedBox(
            height: Dim().d12,
          ),
          Expanded(
            child: TabBarView(
              controller: tabCtrl,
              children: [
                listView(todayList),
                listView(upcomingList),
                listView(historyList),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listView(list) {
    return ListView.separated(
      itemCount: list.length,
      padding: EdgeInsets.symmetric(
        horizontal: Dim().d12,
      ),
      itemBuilder: (context, index) {
        return itemLayout(ctx, list[index]);
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: Dim().d8,
        );
      },
    );
  }

  Widget itemLayout(ctx, v) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Clr().borderColor,
        ),
        borderRadius: BorderRadius.circular(
          Dim().d12,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(
              Dim().d12,
            ),
            child: Row(
              children: [
                ClipOval(
                  child: STM().imageView(
                    v['patient_image'],
                    width: Dim().d60,
                    height: Dim().d60,
                  ),
                ),
                SizedBox(
                  width: Dim().d12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mr. ${v['patient_name']}',
                      style: Sty().mediumText,
                    ),
                    Text(
                      'Appointment ID : ${v['apt_id']}',
                      style: Sty().mediumText,
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(
              Dim().d12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    SvgPicture.asset(
                      'assets/calender_black.svg',
                    ),
                    SizedBox(
                      width: Dim().d8,
                    ),
                    Text(
                      '${v['date']}',
                      style: Sty().mediumText,
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    SvgPicture.asset(
                      'assets/clock.svg',
                    ),
                    SizedBox(
                      width: Dim().d8,
                    ),
                    Text(
                      '${v['time']}',
                      style: Sty().mediumText,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: Dim().d4,
          ),
          Center(
            child: SizedBox(
              height: Dim().d40,
              width: Dim().d260,
              child: ElevatedButton(
                onPressed: () {
                  STM().redirect2page(ctx, AptDetail(v));
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xffe6f3d9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Dim().d12,
                    ),
                  ),
                ),
                child: Text(
                  'Details',
                  style: Sty().mediumText.copyWith(
                      color: Clr().primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Dim().d20,
          ),
        ],
      ),
    );
  }
}