import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saarathi/add_new_patient.dart';
import 'package:saarathi/blood_glucose.dart';
import 'package:saarathi/heart_rate.dart';
import 'package:saarathi/lab_details.dart';
import 'package:saarathi/manage/static_method.dart';
import 'package:saarathi/notifications.dart';
import 'package:saarathi/oxygen.dart';
import 'package:saarathi/physical_details.dart';
import 'package:saarathi/programdetails.dart';
import 'package:saarathi/sidedrawer.dart';
import 'package:saarathi/values/colors.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/hba1c.dart';
import 'package:saarathi/values/strings.dart';
import 'package:saarathi/values/styles.dart';
import 'package:saarathi/your_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bmi.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'doctors.dart';
import 'dr_name.dart';
import 'enroll_program.dart';
import 'health_matrix.dart';
import 'labs.dart';
import 'log_in.dart';
import 'my_profile.dart';
import 'nutritionist.dart';
import 'pharmacy.dart';
import 'product_page.dart';
import 'set_medic_reminder.dart';

class Home extends StatefulWidget {
  final String? Lat, Lng;

  const Home({super.key, this.Lat, this.Lng});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BuildContext ctx;
  dynamic userDetails;
  String? laguagesList;
  List<dynamic> dayList = [
    {"id": "0", "name": "Sunday"},
    {"id": "1", "name": "Monday"},
    {"id": "2", "name": "Tuesday"},
    {"id": "3", "name": "Wednesday"},
    {"id": "4", "name": "Thursday"},
    {"id": "5", "name": "Friday"},
    {"id": "6", "name": "Saturday"},
  ];
  List<dynamic> matrixList = [
    {
      'name': 'BMI',
      'img': 'assets/bmi.svg',
      'clr': Color(0xffF6505A),
      'page': BMI(),
    },
    {
      'name': 'Blood Glucose',
      'img': 'assets/blood_glu.svg',
      'clr': Color(0xff1FDA8D),
      'page': BloodGlucose(),
    },
    {
      'name': 'HbA1c',
      'img': 'assets/hba1c.svg',
      'clr': Color(0xff70D4FF),
      'page': HbA1c(),
    },
    {
      'name': 'Oxygen',
      'img': 'assets/oxygen.svg',
      'clr': Color(0xff616FEC),
      'page': Oxygen(),
    },
    {
      'name': 'Heart Rate',
      'img': 'assets/heart_rate.svg',
      'clr': Color(0xffFC9A40),
      'page': HeartRate(),
    },
    {
      'name': 'See All',
      'img': 'assets/see_all.svg',
      'clr': Clr().primaryColor,
      'page': HealthMatrix(),
    }
  ];

  List<dynamic> programList = [];
  List<Map<String, dynamic>> servicesList = [
    {
      'image': 'assets/physician.svg',
      'name': 'Doctor',
    },
    {
      'image': 'assets/Nurse.svg',
      'name': 'Nurse',
    }
  ];
  List<dynamic> doctorsList = [];
  List<dynamic> medicineList = [];
  List<dynamic> Lablist = [];
  List<dynamic> appointmentList = [];
  List<dynamic> medicationList = [];
  String locationValue = 'Dombivli';
  List<String> locationList = ['Dombivli', 'Thane', 'Kalyan', 'Dadar'];
  String t = "0";
  String? sValue = 'Home';
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  String? usertoken,sUUID;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await Permission.camera.request();
    await Permission.microphone.request();
    var status = await OneSignal.shared.getDeviceState();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
      sUUID = status?.userId;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getHome();
        print(usertoken);
        print(sUUID);
      }
    });
  }

  @override
  void initState() {
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0),
      key: scaffoldState,
      backgroundColor: Clr().white,
      appBar: appbarLayout(),
      drawer: navbar(ctx, scaffoldState),
      body: homeLayout(),
    );
  }

  AppBar appbarLayout() {
    return AppBar(
      elevation: 2,
      backgroundColor: Clr().white,
      leading: InkWell(
        onTap: () {
          scaffoldState.currentState?.openDrawer();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 6),
          child: Icon(Icons.menu, color: Clr().primaryColor, size: 30),
        ),
      ),
      title: Row(children: [
        SvgPicture.asset('assets/location.svg'),
        SizedBox(
          width: Dim().d12,
        ),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: locationValue,
              isExpanded: true,
              icon: SvgPicture.asset('assets/dropdown.svg'),
              style: const TextStyle(color: Color(0xff787882)),
              items: locationList.map((String string) {
                return DropdownMenuItem<String>(
                  value: string,
                  child: Text(
                    string,
                    style:
                        const TextStyle(color: Color(0xff787882), fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (t) {
                // STM().redirect2page(ctx, Home());
                setState(() {
                  locationValue = t!;
                });
              },
            ),
          ),
        ),
        SizedBox(
          width: Dim().d40,
        )
      ]),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(left: Dim().d52),
          child: InkWell(
              onTap: () {
                STM().redirect2page(ctx, MyCart());
              },
              child: SvgPicture.asset(
                'assets/my_cart.svg',
                height: 22,
              )),
        ),
        SizedBox(
          width: 20,
        ),
        Padding(
            padding: EdgeInsets.only(right: 20),
            child: InkWell(
                onTap: () {
                  STM().redirect2page(ctx, NotificationPage());
                },
                child: SvgPicture.asset(
                  'assets/notification.svg',
                  height: 22,
                ))),
      ],
    );
  }

  Widget homeLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Dim().d16),
      physics: const BouncingScrollPhysics(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(
            'Hello, ${userDetails == null ? '' : userDetails['name']}',
            style: Sty().largeText.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: Dim().d20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim().d4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Demographics',
                style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () {
                  STM()
                      .redirect2page(ctx, const PhysicalDetails(sType: 'home'));
                },
                child: Text(
                  'Edit',
                  style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Clr().primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Dim().d12,
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Clr().shimmerColor.withOpacity(0.1),
                  spreadRadius: 0.01,
                  blurRadius: 12,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Clr().borderColor)),
              elevation: 0,
              child: SizedBox(
                  width: MediaQuery.of(ctx).size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Dim().d16),
                    child: demographs(),
                  )),
            ),
          ),
        ),
        SizedBox(
          height: Dim().d20,
        ),
        programsLayout(ctx),
        SizedBox(
          height: Dim().d20,
        ),
        medicationReminder(ctx),
        SizedBox(
          height: Dim().d20,
        ),
        Padding(
          padding: EdgeInsets.only(left: 6),
          child: Text(
            'Health Matrix',
            style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: Dim().d16,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 100,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: matrixLayout(ctx, index, matrixList),
            );
          },
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: EdgeInsets.only(left: 6),
          child: Text(
            'Health Care Services',
            style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: Dim().d16,
        ),
        Padding(
          padding: EdgeInsets.only(left: 6),
          child: SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: servicesList.length,
              itemBuilder: (context, index) {
                return servicesLayout(ctx, index, servicesList);
              },
            ),
          ),
        ),
        SizedBox(
          height: Dim().d8,
        ),
        Row(
          children: [
            SizedBox(
              height: 60,
              width: 160,
              child: InkWell(
                onTap: () {
                  STM().redirect2page(ctx, Pharmacy());
                },
                child: Card(
                  elevation: 0.6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Clr().borderColor)),
                  child: Padding(
                    padding: EdgeInsets.all(Dim().d16),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/pharmacy.svg'),
                        SizedBox(
                          width: Dim().d12,
                        ),
                        Text(
                          'Pharmacy',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60,
              width: 160,
              child: InkWell(
                onTap: () {
                  STM().redirect2page(ctx, Labs());
                },
                child: Card(
                  elevation: 0.6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Clr().borderColor)),
                  child: Padding(
                    padding: EdgeInsets.all(Dim().d16),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/labs.svg'),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Labs',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: Dim().d20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Doctors Nearby Me',
              style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
            ),
            // InkWell(
            //   onTap: () {
            //     STM().redirect2page(ctx, Doctors());
            //   },
            //   child: Text(
            //     'See all',
            //     style: Sty().mediumText.copyWith(
            //           fontWeight: FontWeight.w600,
            //           fontSize: 14,
            //           color: Clr().primaryColor,
            //         ),
            //   ),
            // ),
          ],
        ),
        SizedBox(
          height: Dim().d16,
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: doctorsList.length,
            itemBuilder: (context, index) {
              return doctorsLayout(ctx, index, doctorsList);
            },
          ),
        ),
        SizedBox(
          height: Dim().d20,
        ),
        // SizedBox(
        //   height: 20,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       'Medicines',
        //       style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
        //     ),
        //     InkWell(
        //       onTap: () {
        //         STM().redirect2page(ctx, Pharmacy());
        //       },
        //       child: Text(
        //         'See all',
        //         style: Sty().mediumText.copyWith(
        //               fontWeight: FontWeight.w600,
        //               fontSize: 14,
        //               color: Clr().primaryColor,
        //             ),
        //       ),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 12,
        // ),
        // SizedBox(
        //   height: 230,
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     itemCount: 6,
        //     itemBuilder: (context, index) {
        //       return medicineLayout(ctx, index, medicineList);
        //     },
        //   ),
        // ),
        // SizedBox(
        //   height: Dim().d20,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       ' Nearby Labs',
        //       style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
        //     ),
        //     InkWell(
        //       onTap: () {
        //         STM().redirect2page(ctx, Labs());
        //       },
        //       child: Text(
        //         'See all',
        //         style: Sty().mediumText.copyWith(
        //               fontWeight: FontWeight.w600,
        //               fontSize: 14,
        //               color: Clr().primaryColor,
        //             ),
        //       ),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 12,
        // ),
        // SizedBox(
        //   height: 230,
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     itemCount: 6,
        //     itemBuilder: (context, index) {
        //       return labLayout(ctx, index, Lablist);
        //     },
        //   ),
        // ),
        // SizedBox(
        //   height: 20,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       'Upcoming Appointment',
        //       style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
        //     ),
        //     Text(
        //       'See all',
        //       style: Sty().mediumText.copyWith(
        //             fontWeight: FontWeight.w600,
        //             fontSize: 14,
        //             color: Clr().primaryColor,
        //           ),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 12,
        // ),
        // SizedBox(
        //   height: 145,
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     // itemCount: resultList.length,
        //     itemCount: 5,
        //     itemBuilder: (context, index) {
        //       return appointmentLayout(ctx, index, appointmentList);
        //     },
        //   ),
        // ),
      ]),
    );
  }

  // Medication reminder
  Widget medicationReminder(ctx) {
    return Column(
      children: [
        medicationList.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Medication Reminder',
                      style: Sty()
                          .mediumText
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      onTap: () {
                        STM().redirect2page(
                            ctx,
                            SetMedicReminder(
                              remiderlist: medicationList,
                            ));
                      },
                      child: Text(
                        'View all',
                        style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Clr().primaryColor,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
        medicationList.isEmpty
            ? Container()
            : SizedBox(
                height: Dim().d12,
              ),
        medicationList.isEmpty
            ? InkWell(
                onTap: () {
                  STM().redirect2page(
                      ctx,
                      SetMedicReminder(
                        remiderlist: medicationList,
                      ));
                },
                child: Container(
                  height: Dim().d52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Clr().white,
                      boxShadow: [
                        BoxShadow(
                          color: Clr().shimmerColor.withOpacity(0.1),
                          spreadRadius: 0.01,
                          blurRadius: 12,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(Dim().d12)),
                  child: Center(
                    child: Text(
                      'Add Medicine Reminder',
                      style: Sty().mediumBoldText,
                    ),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Clr().white,
                  boxShadow: [
                    BoxShadow(
                      color: Clr().shimmerColor.withOpacity(0.1),
                      spreadRadius: 0.01,
                      blurRadius: 12,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Dim().d12, horizontal: Dim().d16),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: medicationList.length,
                        itemBuilder: (context, index) {
                          List<dynamic> dayidList = medicationList[index]['day_id'] ?? [];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${medicationList[index]['medicine']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: Dim().d4,
                              ),
                              GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6,childAspectRatio: 12/7),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: dayidList.length,
                                  itemBuilder: (context, index2) {
                                    return Text(
                                      dayidList.isEmpty
                                          ? ''
                                          : dayList[int.parse(
                                                      dayidList[index2]
                                                          .toString())]
                                                  ['name']
                                              .toString()
                                              .substring(0, 3),
                                      style: Sty().mediumText,
                                    );
                                  }),
                              SizedBox(
                                height: Dim().d16,
                              ),
                              // GridView.builder(
                              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              //             crossAxisCount: 3,
                              //             childAspectRatio: 28/ 4),
                              //     physics: const NeverScrollableScrollPhysics(),
                              //     shrinkWrap: true,
                              //     itemCount: medicationList[index]['time'].length,
                              //     itemBuilder: (context, index2) {
                              //       return Text(
                              //         medicationList[index]['time'][index2].toString(),
                              //         style: Sty().smallText.copyWith(
                              //             color: Clr().primaryColor),
                              //       );
                              //     }),
                              Text(
                                medicationList[index]['time'].toString().replaceAll('[', '').replaceAll(']', ''),
                                style: Sty()
                                    .smallText
                                    .copyWith(color: Clr().primaryColor),
                              ),
                              const Divider(),
                            ],
                          );
                        })),
              ),
      ],
    );
  }

  //Health Care Services
  Widget servicesLayout(ctx, index, list) {
    return InkWell(
        onTap: () {
          STM().redirect2page(ctx, Nutritionist());
        },
        child: Padding(
          padding: EdgeInsets.only(right: Dim().d12),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Clr().hintColor),
                borderRadius: BorderRadius.circular(Dim().d12)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dim().d24, vertical: Dim().d4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(list[index]['image'], height: Dim().d60),
                  Text(
                    list[index]['name'],
                    style: Sty().smallText.copyWith(),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  // demographs
  Widget demographs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            SizedBox(
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0.7,
                      backgroundColor: Color(0xffF6505A),
                      side: BorderSide(color: Clr().borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  onPressed: () {},
                  child: Text(
                    userDetails == null
                        ? ''
                        : userDetails['age'] == null
                            ? '0'
                            : userDetails['age'].toString(),
                    style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w700, color: Clr().white),
                  )),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'Age',
              style: Sty().smallText,
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0.7,
                      backgroundColor: Color(0xff1FDA8D),
                      side: BorderSide(color: Clr().borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  onPressed: () {},
                  child: Text(
                    userDetails == null
                        ? ''
                        : userDetails['gender'] == null
                            ? ''
                            : userDetails['gender'],
                    style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w700, color: Clr().white),
                  )),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'Gender',
              style: Sty().smallText,
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0.7,
                      backgroundColor: Color(0xff70D4FF),
                      side: BorderSide(color: Clr().borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  onPressed: () {},
                  child: Text(
                    userDetails == null
                        ? ''
                        : userDetails['height_in_feet'] == null
                            ? '0'
                            : '${userDetails['height_in_feet'].toString()}`${userDetails['height_in_inch'].toString()}"',
                    style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w700, color: Clr().white),
                  )),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'height',
              style: Sty().smallText,
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0.7,
                      backgroundColor: Color(0xff616FEC),
                      side: BorderSide(color: Clr().borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  onPressed: () {},
                  child: Text(
                    userDetails == null
                        ? ''
                        : userDetails['diet'] == null
                            ? ''
                            : userDetails['diet'].toString(),
                    style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w700, color: Clr().white),
                  )),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'Diet',
              style: Sty().smallText,
            ),
          ],
        ),
      ],
    );
  }

  //Doctors Near by
  Widget doctorsLayout(ctx, index, list) {
    List typelist = [];
    List specialityList = [];
    typelist = list[index]['appoitment_types'];

    for (int a = 0; a < list[index]['professional']['speciality_name'].length; a++) {
      specialityList.add(list[index]['professional']['speciality_name'][a]['name']);
    }
    return Card(
      elevation: 0.6,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Clr().borderColor)),
      child: Container(
        width: MediaQuery.of(ctx).size.width / 1.15,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                STM().imageDisplay(
                    list: list[index]['profile_pic'],
                    url: list[index]['profile_pic'],
                    h: Dim().d120,
                    w: Dim().d100),
                SizedBox(
                  width: Dim().d12,
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
                              'Dr.${list[index]['first_name']} ${list[index]['last_name']}',
                              style: Sty()
                                  .mediumText
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          // Wrap(
                          //   crossAxisAlignment: WrapCrossAlignment.center,
                          //   children: [
                          //     SvgPicture.asset('assets/map_pin.svg'),
                          //     SizedBox(
                          //       width: 4,
                          //     ),
                          //     Text(
                          //       '1 KM',
                          //       style: Sty().smallText.copyWith(
                          //           color: Clr().primaryColor,
                          //           fontWeight: FontWeight.w600),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                      SizedBox(
                        height: Dim().d4,
                      ),
                      list[index]['professional'] == null
                          ? Container()
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: specialityList.length > 1 ? 2 : specialityList.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisExtent: 20.0),
                              itemBuilder: (context, index2) {
                                return Text(specialityList[index2],
                                    style: Sty().smallText.copyWith(fontWeight: FontWeight.w400));
                              }),
                      SizedBox(
                        height: Dim().d4,
                      ),
                      list[index]['languages'] == null
                          ? Container()
                          : Text(
                              'Speaks : ${list[index]['languages'].toString().replaceAll('[', '').replaceAll(']', '')}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Sty()
                                  .smallText
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                      SizedBox(
                        height: Dim().d4,
                      ),
                      Text(
                        'Starts at : ₹ ${list[index]['appointment_details'][0]['charges']}',
                        style: Sty()
                            .smallText
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: Dim().d4,
                      ),
                      Text(
                        list[index]['professional'] == null
                            ? ''
                            : '${list[index]['professional']['experience']} Years of experience',
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
              height: Dim().d8,
            ),
            Row(
              children: [
                typelist.contains('Online Consultation')
                    ? Row(
                        children: [
                          SvgPicture.asset('assets/online_consultation.svg'),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Online Consultation',
                            style: Sty()
                                .mediumText
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  width: 16,
                ),
                typelist.contains('OPD')
                    ? Row(
                        children: [
                          SvgPicture.asset('assets/opd.svg'),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            'OPD',
                            style: Sty()
                                .mediumText
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            typelist.contains('Home Visit')
                ? Row(
                    children: [
                      SvgPicture.asset('assets/home_visit.svg'),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Home Visit',
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    STM().redirect2page(
                        ctx,
                        DrName(
                          doctorDetails: list[index],
                          id: list[index]['id'],
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
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
    );
  }

  // programs
  Widget programsLayout(ctx) {
    return Column(
      children: [
        programList.length == 0
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enroll for program',
                      style: Sty()
                          .mediumText
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      onTap: () {
                        STM().redirect2page(ctx, EnrollForProgram());
                      },
                      child: Text(
                        'View all',
                        style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Clr().primaryColor,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
        programList.isEmpty
            ? Container()
            : SizedBox(
                height: Dim().d12,
              ),
        programList.isEmpty
            ? Container()
            : ListView.builder(
                itemCount: programList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      STM().redirect2page(
                          ctx,
                          ProgramDetails(
                              programId: programList[index]['id'].toString()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Clr().shimmerColor.withOpacity(0.1),
                            spreadRadius: 0.01,
                            blurRadius: 12,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Clr().borderColor)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dim().d16, vertical: Dim().d16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${programList[index]['name']}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Sty().mediumText,
                                ),
                              ),
                              SvgPicture.asset('assets/arrow.svg')
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
      ],
    );
  }

//Medicines
  Widget medicineLayout(ctx, index, List) {
    return SizedBox(
      width: 160,
      child: Container(
        width: MediaQuery.of(ctx).size.width / 2.5,
        child: Card(
          elevation: 0.6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Clr().borderColor)),
          child: Padding(
            padding: EdgeInsets.all(Dim().d12),
            child: Column(
              children: [
                InkWell(
                    onTap: () {
                      STM().redirect2page(ctx, ProductPage());
                    },
                    child: Image.asset('assets/medicine.png')),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Baidynath Kesari Kalpsfsfgfsgg',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Sty().smallText.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                      '₹400',
                      style: Sty().mediumText.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '₹700',
                      style: Sty().microText.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color(0xffC2C2C2),
                            decoration: TextDecoration.lineThrough,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Clr().white,
                          side: BorderSide(color: Clr().primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onPressed: () {
                        STM().redirect2page(ctx, MyCart());
                      },
                      child: Text(
                        'Add to Cart',
                        style: Sty().mediumText.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Clr().primaryColor),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Lablist
  Widget labLayout(ctx, index, List) {
    return SizedBox(
      width: 145,
      child: Container(
        width: MediaQuery.of(ctx).size.width / 2.5,
        child: Card(
          elevation: 0.6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Clr().borderColor)),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Image.asset('assets/lab.png')),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                child: Text(
                  'NirAmaya Pathlabs ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Sty().smallText.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/map_pin.svg'),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Dombivli',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Sty().smallText.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 40,
                width: 100,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Clr().white,
                        side: BorderSide(color: Clr().primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onPressed: () {
                      STM().redirect2page(ctx, LabsDetails());
                    },
                    child: Text(
                      'Book',
                      style: Sty().mediumText.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Clr().primaryColor),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Upcoming Appointment
  Widget appointmentLayout(ctx, index, List) {
    return SizedBox(
      width: MediaQuery.of(ctx).size.width / 1.2,
      child: Card(
        margin: const EdgeInsets.only(right: 10),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Clr().primaryColor,
        child: Padding(
          padding: EdgeInsets.all(Dim().d12),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/doc2.png'),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Imran Syahir',
                          style: Sty().extraLargeText.copyWith(
                              fontWeight: FontWeight.w500, color: Clr().white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'General Doctor',
                          style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w300, color: Clr().white),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Clr().white,
                  )
                ],
              ),
              const Divider(
                color: Color(0xffffffff),
                thickness: 1,
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/calendar.svg'),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Sun,12 June',
                        style: Sty().mediumText.copyWith(color: Clr().white),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/clock.svg'),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '11:00-12:00 AM',
                        style: Sty().mediumText.copyWith(color: Clr().white),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget matrixLayout(ctx, index, List) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0.7,
                  backgroundColor: List[index]['clr'],
                  side: BorderSide(color: Clr().borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
              onPressed: () {
                STM().redirect2page(ctx, List[index]['page']);
                // STM().redirect2page(ctx, HealthMatrix());
              },
              child: SvgPicture.asset(List[index]['img']
                  // 'assets/bmi.svg'
                  )),
        ),
        SizedBox(
          height: Dim().d4,
        ),
        Text(
          List[index]['name'],
          style: Sty().smallText.copyWith(),
        )
      ],
    );
  }

  void getHome() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'uuid': sUUID ?? "",
      'latitude': widget.Lat,
      'longitude': widget.Lng,
    });
    var result = await STM().postWithToken(
        ctx, Str().loading, 'homePageDetails', body, usertoken, 'customer');
    var status = result['status'];
    if (status == 500) {
      sp.clear();
      STM().finishAffinity(ctx, SignIn());
    } else {
      setState(() {
        userDetails = result['demographic'];
        programList = result['programs'];
        medicationList = result['reminders'];
        doctorsList = result['near_by_doctors'];
      });
    }
  }
}
