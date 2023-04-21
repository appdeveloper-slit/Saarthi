import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/strings.dart';
import '../values/styles.dart';
import 'apt_detail.dart';

class Appointment extends StatefulWidget {
  final Map<String, dynamic> data;

  const Appointment(this.data, {Key? key}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment>
    with TickerProviderStateMixin {
  late BuildContext ctx;

  TabController? tabCtrl;

  List<dynamic> todayList = [];
  List<dynamic> upcomingList = [];
  List<dynamic> historyList = [];

  String? sToken;

  Map<String, dynamic> v = {};

  @override
  void initState() {
    v = widget.data;
    tabCtrl = TabController(length: 3, vsync: this);
    getSession();
    super.initState();
  }

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sToken = sp.getString('hcptoken') ?? '';
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
      'type': v['apt_id'],
    });
    //Output
    var result = await STM().postWithToken(
        ctx, Str().loading, "view_appointment_details", body, sToken, 'hcp');
    if (!mounted) return;
    var success = result['success'];
    if (success) {
      setState(() {
        todayList = result['today_appointments'];
        upcomingList = result['upcoming_appointments'];
        historyList = result['completed_appointments'];
      });
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
          '${v['apt_name']}',
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
                    height: Dim().d52,
                  ),
                  Tab(
                    text: 'Upcoming',
                    height: Dim().d52,
                  ),
                  Tab(
                    text: 'History',
                    height: Dim().d52,
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
                todayList.isEmpty
                    ? STM().emptyData('No Appointment Found')
                    : listView(todayList),
                upcomingList.isEmpty
                    ? STM().emptyData('No Appointment Found')
                    : listView(upcomingList),
                historyList.isEmpty
                    ? STM().emptyData('No Appointment Found')
                    : listView(historyList),
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
                Container(
                  width: Dim().d80,
                  height: Dim().d80,
                  decoration: BoxDecoration(
                    color: const Color(0x801F98B3),
                    border: Border.all(
                      color: const Color(0xFF1F98B3),
                    ),
                    borderRadius: BorderRadius.circular(
                      Dim().d100,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      STM().nameShort('${v['patient']['full_name']}'),
                      style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dim().d12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mr. ${v['patient']['full_name']}',
                        style: Sty().mediumText,
                      ),
                      Text(
                        'Appointment ID : ${v['appointment_uid']}',
                        style: Sty().mediumText,
                      ),
                    ],
                  ),
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
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/calender_black.svg',
                    ),
                    SizedBox(
                      width: Dim().d12,
                    ),
                    Text(
                      '${DateFormat('EEEE').format(DateTime.parse(v['booking_date']))}, ${DateFormat('dd/MM/yyyy').format(DateTime.parse(v['booking_date']))}',
                      style: Sty().mediumText,
                    ),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/clock.svg',
                    ),
                    SizedBox(
                      width: Dim().d12,
                    ),
                    Text(
                      '${v['slot']['slot']}',
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
                  // v.addEntries(this.v.entries);
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