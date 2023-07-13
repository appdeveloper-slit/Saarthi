import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'booking_details .dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'my_appointments.dart';

class MyBooking extends StatefulWidget {
  final index;
  const MyBooking({super.key,  this.index});
  @override
  _MyBookingState createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> with SingleTickerProviderStateMixin {
  late BuildContext ctx;
  late TabController _tabController;
  String? usertoken,patientvalue;
  List<dynamic> upcominglabList = [];
  List<dynamic> completedlabList = [];
  List<dynamic> patientlist = [];

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getPatient();
        getBooking('');
        print(usertoken);
      }
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getSession();
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
      STM().directionRoute(widget.index, ctx);
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
              STM().directionRoute(widget.index, ctx);
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
                  width: MediaQuery.of(context).size.width * 0.80,
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
                    tabs: const [
                      Tab(
                        text: 'Upcoming',
                      ),
                      Tab(
                        text: 'Completed',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dim().d16),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dim().d16, vertical: Dim().d4),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Clr().grey.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 12,
                        offset: Offset(0, 8), // changes position of shadow
                      ),
                    ],
                    color: Clr().formfieldbg,
                    borderRadius: BorderRadius.circular(10),
                    border:
                    Border.all(color: Clr().transparent)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField(
                    value: patientvalue,
                    isExpanded: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Select Patient Name';
                      }
                    },
                    decoration: Sty().textFieldOutlineStyle.copyWith(
                        contentPadding: EdgeInsets.zero,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder:
                        InputBorder.none),
                    hint: Text('Select Patient Name',
                        style: Sty()
                            .mediumText
                            .copyWith(color: Clr().black)),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 28,
                      color: Clr().grey,
                    ),
                    style: const TextStyle(
                        color: Color(0xff787882)),
                    items: patientlist.map((string) {
                      return DropdownMenuItem(
                        value: string['full_name'],
                        child: Text(
                          string['full_name'],
                          style: const TextStyle(
                              color: Color(0xff787882),
                              fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (t) {
                      int position = patientlist.indexWhere((element) => element['full_name'].toString() == t.toString());
                      setState(() {
                        patientvalue = t as String;
                        getBooking(patientlist[position]['id']);
                      });
                    },
                  ),
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                     upcominglabList.isEmpty ? Center(
                      child: Text('No Bookings',style: Sty().mediumBoldText),
                    )  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: upcominglabList.length,
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
                                        STM().redirect2page(ctx, BookingDetails(labdetails: upcominglabList[index]));
                                      },
                                      child: Card(
                                        color: Clr().background,
                                        margin: EdgeInsets.only(top: Dim().d12),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dim().d12)),
                                        child: Padding(
                                          padding: EdgeInsets.all(Dim().d8),
                                          child: Row(
                                            children: [
                                              Image.network(
                                                  upcominglabList[index]['lab']['image_path'].toString(),
                                                  height: Dim().d100,
                                                  width: Dim().d100,
                                                  fit: BoxFit.cover,
                                              ),
                                              SizedBox(
                                                width: Dim().d8,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(upcominglabList[index]['lab']['name'],
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
                                                      Text(upcominglabList[index]['lab']['address'],
                                                          style: TextStyle(
                                                              fontSize: Dim().d14)),
                                                      SizedBox(
                                                        height: Dim().d8,
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(upcominglabList[index]['booking_date'].toString())),
                                                              style: TextStyle(fontSize: Dim().d14)),
                                                          SizedBox(width: Dim().d8),
                                                          Text(upcominglabList[index]['lab']['available_time'].toString(),
                                                              style: TextStyle(fontSize: Dim().d14)),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: Dim().d8,
                                                      ),
                                                      Text(upcominglabList[index]['status'] == 1 ? 'Completed' : upcominglabList[index]['status'] == 2 ? 'Cancelled' : 'Pending',
                                                          // 'Completed',
                                                          style:
                                                          Sty().mediumText.copyWith(
                                                              fontWeight:
                                                              FontWeight.w600,fontSize: 16,
                                                              color: upcominglabList[index]['status'] == 1 ? Clr().green : upcominglabList[index]['status'] == 2 ? Clr().red : Color(0xffFFC107)
                                                          )),
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
                    // second tab bar view widget
                     completedlabList.isEmpty ? Center(
                      child: Text('No Bookings',style: Sty().mediumBoldText),
                    )  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: completedlabList.length,
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
                                        STM().redirect2page(ctx, BookingDetails(labdetails: completedlabList[index],));
                                      },
                                      child: Card(
                                        color: Clr().background,
                                        margin: EdgeInsets.only(top: Dim().d12),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dim().d12)),
                                        child: Padding(
                                          padding:  EdgeInsets.all(Dim().d8),
                                          child: Row(
                                            children: [
                                              Image.network(
                                                completedlabList[index]['lab']['image_path'].toString(),
                                                height: Dim().d100,
                                                width: Dim().d100,
                                                fit: BoxFit.cover,
                                              ),
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
                                                          Text(completedlabList[index]['lab']['name'],
                                                              style: Sty().mediumText.copyWith(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: const Color(0xff2D2D2D))),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: Dim().d4,
                                                      ),
                                                      Text(completedlabList[index]['lab']['address'],
                                                          style: TextStyle(
                                                              fontSize: Dim().d14)),
                                                      SizedBox(
                                                        height: Dim().d8,
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(completedlabList[index]['booking_date'].toString())),
                                                              style: TextStyle(fontSize: Dim().d14)),
                                                          SizedBox(width: Dim().d8),
                                                          Text(completedlabList[index]['lab']['available_time'].toString(),
                                                              style: TextStyle(fontSize: Dim().d14)),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: Dim().d8,
                                                      ),
                                                      Text(completedlabList[index]['status'] == 1 ? 'Completed' : 'Cancelled',
                                                          style: Sty()
                                                              .mediumText
                                                              .copyWith(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16,
                                                              color:completedlabList[index]['status'] == 1 ? Clr().green : Clr().red)),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getBooking(id) async {
   FormData body = FormData.fromMap({
     'patient_id': id,
   });
   var result = await STM().postWithToken(ctx, Str().loading, 'lab_appointment_history', body, usertoken, 'customer');
   var success = result['success'];
   if(success){
     setState(() {
       upcominglabList = result['upcoming_appointments'];
       completedlabList = result['completed_appointments'];
     });
   }
  }

  // getPatient
  void getPatient() async {
    var result = await STM().getWithTokenUrl(ctx, Str().loading, 'get_patient', usertoken, 'customer');
    var success = result['success'];
    if (success) {
      setState(() {
        patientlist = result['patients'];
      });
    }
  }
}
