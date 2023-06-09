import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saarathi/add_new_patient.dart';
import 'package:saarathi/blood_glucose.dart';
import 'package:saarathi/heart_rate.dart';
import 'package:saarathi/lab_details.dart';
import 'package:saarathi/localstore.dart';
import 'package:saarathi/manage/static_method.dart';
import 'package:geocoding/geocoding.dart';
import 'package:saarathi/notifications.dart';
import 'package:saarathi/oxygen.dart';
import 'package:saarathi/physical_details.dart';
import 'package:saarathi/programdetails.dart';
import 'package:saarathi/select_location.dart';
import 'package:saarathi/sidedrawer.dart';
import 'package:saarathi/values/colors.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/hba1c.dart';
import 'package:saarathi/values/strings.dart';
import 'package:saarathi/values/styles.dart';
import 'package:saarathi/your_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apt_details_home_visit.dart';
import 'apt_details_ol.dart';
import 'apt_details_telecall.dart';
import 'bmi.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'doctors.dart';
import 'dr_name.dart';
import 'enroll_program.dart';
import 'health_matrix.dart';
import 'labs.dart';
import 'log_in.dart';
import 'my_appointments.dart';
import 'my_profile.dart';
import 'nutritionist.dart';
import 'pharmacy.dart';
import 'product_page.dart';
import 'set_medic_reminder.dart';

class Home extends StatefulWidget {
  final String? Lat, Lng;
  final type;

  const Home({super.key, this.Lat, this.Lng, this.type});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BuildContext ctx;
  dynamic userDetails;
  String? laguagesList;
  AwesomeDialog? dialog;
  List<dynamic> dayList = [
    {"id": "0", "name": "Sunday"},
    {"id": "1", "name": "Monday"},
    {"id": "2", "name": "Tuesday"},
    {"id": "3", "name": "Wednesday"},
    {"id": "4", "name": "Thursday"},
    {"id": "5", "name": "Friday"},
    {"id": "6", "name": "Saturday"},
  ];
  List<dynamic> addToCart = [];
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

  void _refreshData() async {
    dynamic data = await Store.getItems();
    setState(() {
      addToCart = data;
    });
  }

  Future<void> _addItem(
      medicine_id, varientid, name, image, price, actualPrice, counter) async {
    await Store.createItem(
        medicine_id, varientid, name, image, price, actualPrice, counter);
  }

  List<dynamic> programList = [];
  List<Map<String, dynamic>> servicesList = [
    {
      'id': 1,
      'image': 'assets/physician.svg',
      'name': 'Physicians',
    },
    {
      'id': 2,
      'image': 'assets/nutritionist.svg',
      'name': 'Nutritionist',
    },
    {
      'id': 3,
      'image': 'assets/Physiotherapist.svg',
      'name': 'Physiotherapist',
    },
    {
      'id': 4,
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
  String? usertoken, sUUID, city;
  var time;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await Permission.camera.request();
    await Permission.microphone.request();
    var status = await OneSignal.shared.getDeviceState();
    double lat = double.parse(sp.getString('lat').toString());
    double lng = double.parse(sp.getString('lng').toString());
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark placeMark = placemarks[0];
    city = placeMark.subLocality;
    print('${city}gREG');
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
      sUUID = status?.userId;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getHome();
        _refreshData();
        print(usertoken);
        print(sUUID);
      }
    });
  }

  @override
  void initState() {
    widget.type == 'from otp' ? permissionHandle() : getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return DoubleBack(
      message: 'Please Press back again to exit',
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        key: scaffoldState,
        backgroundColor: Clr().white,
        appBar: appbarLayout(),
        drawer: navbar(ctx, scaffoldState),
        body: homeLayout(),
      ),
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
      title: InkWell(
        onTap: () {
          STM().redirect2page(
              ctx,
              SelectLocation(
                type: 'home',
              ));
        },
        child: Row(children: [
          SvgPicture.asset('assets/location.svg'),
          SizedBox(
            width: Dim().d12,
          ),
          Expanded(
            child: Text(
              '${city == null ? '' : city.toString()}',
              maxLines: 2,
              style: Sty().mediumText.copyWith(color: Clr().black),
            ),
          ),
        ]),
      ),
      centerTitle: true,
      actions: [
        InkWell(
          onTap: () {
            // STM().redirect2page(context, NotificationPage());
            STM().redirect2page(
                ctx,
                MyCart(
                  type: 'home',
                ));
          },
          child: addToCart.length > 0
              ? SvgPicture.asset('assets/AddCart.svg')
              : SvgPicture.asset('assets/my_cart.svg'),
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
                  STM().redirect2page(ctx, PhysicalDetails(sType: 'home'));
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
            // 'Health Matrix',
            ' Health Metrics',
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
          child: GridView.builder(
              itemCount: servicesList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 6,
                childAspectRatio: 20 / 13,
              ),
              itemBuilder: (context, index) {
                return servicesLayout(ctx, index, servicesList);
              }),
        ),
        SizedBox(
          height: Dim().d8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  STM().redirect2page(ctx, Pharmacy());
                },
                child: Card(
                  elevation: 0.6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
            Expanded(
              child: InkWell(
                onTap: () {
                  STM().redirect2page(ctx, Labs());
                },
                child: Card(
                  elevation: 0.6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
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
        doctorsList.isEmpty
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Doctors Nearby Me',
                    style:
                        Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
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
        if (doctorsList.isNotEmpty)
          SizedBox(
            height: Dim().d16,
          ),
        if (doctorsList.isNotEmpty)
          SizedBox(
            height: Dim().d300,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: doctorsList.length,
              itemBuilder: (context, index) {
                return doctorsLayout(ctx, index, doctorsList);
              },
            ),
          ),
        if (doctorsList.isNotEmpty)
          SizedBox(
            height: Dim().d20,
          ),
        if (medicineList.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBe
            tween,
            children: [
              Text(
                'Medicines',
                style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () {
                  STM().redirect2page(ctx, Pharmacy());
                },
                child: Text(
                  'See all',
                  style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Clr().primaryColor,
                      ),
                ),
              ),
            ],
          ),
        if (medicineList.isNotEmpty)
          SizedBox(
            height: Dim().d12,
          ),
        if (medicineList.isNotEmpty)
          SizedBox(
            height: Dim().d220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: medicineList.length,
              itemBuilder: (context, index) {
                return medicineLayout(ctx, index, medicineList);
              },
            ),
          ),
        if (Lablist.isNotEmpty)
          SizedBox(
            height: Dim().d20,
          ),
        if (Lablist.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ' Nearby Labs',
                style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () {
                  STM().redirect2page(ctx, Labs());
                },
                child: Text(
                  'See all',
                  style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Clr().primaryColor,
                      ),
                ),
              ),
            ],
          ),
        if (Lablist.isNotEmpty)
          SizedBox(
            height: Dim().d12,
          ),
        if (Lablist.isNotEmpty)
          SizedBox(
            height: Dim().d220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Lablist.length,
              itemBuilder: (context, index) {
                return labLayout(ctx, index, Lablist);
              },
            ),
          ),
        if (appointmentList.isNotEmpty)
          SizedBox(
            height: Dim().d20,
          ),
        if (appointmentList.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Appointment',
                style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () {
                  STM().redirect2page(ctx, MyAppointments());
                },
                child: Text(
                  'See all',
                  style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Clr().primaryColor,
                      ),
                ),
              ),
            ],
          ),
        if (appointmentList.isNotEmpty)
          SizedBox(
            height: Dim().d12,
          ),
        if (appointmentList.isNotEmpty)
          SizedBox(
            height: Dim().d150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // itemCount: resultList.length,
              itemCount: appointmentList.length,
              itemBuilder: (context, index) {
                return appointmentLayout(ctx, index, appointmentList);
              },
            ),
          ),
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
                          List<dynamic> dayidList =
                              medicationList[index]['day_id'] ?? [];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${medicationList[index]['medicine']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: Dim().d4,
                              ),
                              GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 6,
                                          childAspectRatio: 12 / 7),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: dayidList.length,
                                  itemBuilder: (context, index2) {
                                    return Text(
                                      dayidList.isEmpty
                                          ? ''
                                          : dayList[int.parse(dayidList[index2]
                                                  .toString())]['name']
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
                                medicationList[index]['time']
                                    .toString()
                                    .replaceAll('[', '')
                                    .replaceAll(']', ''),
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
          STM().redirect2page(
              ctx,
              Nutritionist(
                id: list[index]['id'],
                name: list[index]['name'],
              ));
        },
        child: Padding(
          padding: EdgeInsets.only(right: Dim().d12),
          child: Container(
            decoration: BoxDecoration(
                color: Clr().white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.brown.shade50,
                      offset: Offset(1, 1),
                      spreadRadius: 1,
                      blurRadius: 15)
                ],
                borderRadius: BorderRadius.circular(Dim().d12)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dim().d24, vertical: Dim().d4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    list[index]['image'],
                    height: Dim().d60,
                    width: index == 3 ? Dim().d120 : 0,
                  ),
                  Text(
                    list[index]['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
              'Height',
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
    for (int a = 0;
        a < list[index]['professional']['speciality_name'].length;
        a++) {
      specialityList
          .add(list[index]['professional']['speciality_name'][a]['name']);
    }
    List<Text> listPro() {
      return specialityList
          .map((e) => Text(e,
              maxLines: 1,
              style: Sty().smallText.copyWith(fontWeight: FontWeight.w400)))
          .toList();
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Dr.${list[index]['first_name']} ${list[index]['last_name']}',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w600),
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
                    if (list[index]['professional']['speciality_name']
                        .isNotEmpty)
                      SizedBox(
                        width: Dim().d200,
                        child: Text(
                            specialityList
                                .toString()
                                .replaceAll('[', '')
                                .replaceAll(']', ''),
                            maxLines: 1,
                            style: Sty()
                                .smallText
                                .copyWith(fontWeight: FontWeight.w400)),
                      ),
                    SizedBox(
                      height: Dim().d4,
                    ),
                    list[index]['languages'] == null
                        ? Container()
                        : SizedBox(
                            width: Dim().d200,
                            child: Text(
                              'Speaks : ${list[index]['languages'].toString().replaceAll('[', '').replaceAll(']', '')}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Sty()
                                  .smallText
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                    SizedBox(
                      height: Dim().d4,
                    ),
                    Text(
                      'Starts at : ₹ ${list[index]['appointment_details'][0]['charges']}',
                      style:
                          Sty().smallText.copyWith(fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: Dim().d4,
                    ),
                    Text(
                      list[index]['professional'] == null
                          ? ''
                          : '${list[index]['professional']['experience']} Years of experience',
                      style:
                          Sty().smallText.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
            Wrap(
              spacing: Dim().d12,
              children: [
                if (typelist.contains('Online Consultation'))
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SvgPicture.asset('assets/online_consultation.svg'),
                      SizedBox(
                        width: Dim().d4,
                      ),
                      Text(
                        'Online',
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                if (typelist.contains('OPD'))
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SvgPicture.asset('assets/opd.svg'),
                      SizedBox(
                        width: Dim().d4,
                      ),
                      Text(
                        'OPD',
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                if (typelist.contains('Home Visit'))
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SvgPicture.asset('assets/home_visit.svg'),
                      SizedBox(
                        width: Dim().d4,
                      ),
                      Text(
                        'Home Visit',
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(
              height: Dim().d52,
              width: Dim().d300,
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
  Widget medicineLayout(ctx, index, list) {
    return SizedBox(
      width: Dim().d180,
      child: Card(
        elevation: 0.6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Clr().borderColor)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim().d12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: Dim().d2,
              ),
              InkWell(
                onTap: () {
                  STM().redirect2page(
                      ctx,
                      ProductPage(
                        details: list[index],
                      ));
                },
                child: SizedBox(
                  height: Dim().d72,
                  width: double.infinity,
                  child: STM().imageDisplay(
                      list: list[index]['image'], url: list[index]['image']),
                ),
              ),
              Text(
                '${list[index]['name'].toString()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Sty().smallText.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
              Row(
                children: [
                  Text(
                    '₹ ${list[index]['selling_price']}',
                    style: Sty().mediumText.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  SizedBox(
                    width: Dim().d8,
                  ),
                  Text(
                    '₹ ${list[index]['price']}',
                    style: Sty().microText.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Color(0xffC2C2C2),
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: Dim().d36,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _refreshData();
                        addToCart
                                .map((e) => e['medicine_id'])
                                .contains(list[index]['id'])
                            ? Fluttertoast.showToast(
                                msg: 'Item is already added in cart',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER)
                            : _addItem(
                                list[index]['id'],
                                list[index]['medicine_variant'][0]['id'],
                                list[index]['medicine_variant'][0]
                                        ['variant_name']
                                    .toString(),
                                list[index]['image'].toString(),
                                list[index]['medicine_variant'][0]
                                        ['selling_price']
                                    .toString(),
                                list[index]['medicine_variant'][0]
                                        ['selling_price']
                                    .toString(),
                                1,
                              ).then((value) {
                                _refreshData();
                                Fluttertoast.showToast(
                                    msg: 'Item added to cart',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER);
                              });
                      });
                      // STM().redirect2page(ctx, MyCart());
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        side: BorderSide(width: 1, color: Clr().primaryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Add to Cart',
                      style: Sty().smallText.copyWith(
                          fontSize: Dim().d14,
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w400),
                    )),
              ),
              SizedBox(
                height: Dim().d2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Lablist
  Widget labLayout(ctx, index, list) {
    return SizedBox(
      width: Dim().d180,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Clr().borderColor)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dim().d12, vertical: Dim().d12),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dim().d12),
                  child: STM().imageDisplay(
                      url: list[index]['image_path'],
                      list: list[index]['image_path'],
                      h: Dim().d80,
                      w: double.infinity)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d12),
              child: Text(
                '${list[index]['name'].toString()}',
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Sty().smallText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined),
                  Flexible(
                    child: Text(
                      '${list[index]['location'].toString()}',
                      style: Sty().smallText.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                STM().redirect2page(
                    context, LabsDetails(labDetails: list[index]));
              },
              child: Container(
                width: MediaQuery.of(context).size.height / 4.9,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Clr().grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 25,
                        offset: Offset(12, 0.5), // changes position of shadow
                      ),
                    ],
                    color: Clr().primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                child: Center(
                  child: Text(
                    'Book',
                    style: Sty().mediumText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Clr().white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Upcoming Appointment
  Widget appointmentLayout(ctx, index, list) {
    return InkWell(
      onTap: () {
        list[index]['appointment_type'] == "2"
            ? STM().redirect2page(
                ctx,
                TeleCallAppointmentDetails(
                  details: list[index],
                  time: time,
                ))
            : list[index]['appointment_type'] == "1"
                ? STM().redirect2page(
                    ctx,
                    AppointmentolDetails(
                      details: list[index],
                      time: time,
                    ))
                : STM().redirect2page(
                    ctx,
                    HomeVisitAptDetails(
                      details: list[index],
                      time: time,
                    ));
      },
      child: SizedBox(
        width: Dim().d300,
        child: Card(
          margin: const EdgeInsets.only(right: 10),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Clr().primaryColor,
          child: Padding(
            padding: EdgeInsets.all(Dim().d8),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(Dim().d56),
                        child: STM().imageDisplay(
                            url: list[index]['hcp']['profile_pic'],
                            list: list[index]['hcp']['profile_pic'],
                            h: Dim().d80,
                            w: Dim().d80)),
                    SizedBox(
                      width: Dim().d14,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${list[index]['hcp']['first_name']} ${list[index]['hcp']['last_name']}',
                            style: Sty().mediumText.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Clr().white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: Dim().d8,
                          ),
                          if (list[index]['hcp']['professional']
                                  ['speciality_name'] !=
                              null)
                            Text(
                                list[index]['hcp']['professional']
                                    ['speciality_name'][0]['name'],
                                style: TextStyle(
                                    color: Clr().white, fontSize: Dim().d14)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Dim().d8,
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
                  height: Dim().d4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/calendar.svg'),
                        SizedBox(
                          width: Dim().d4,
                        ),
                        Text(
                            list[index]['is_reschedule'] == 1
                                ? DateFormat('EEE, dd MMMM').format(
                                    DateTime.parse(list[index]
                                            ['reschedule_date']
                                        .toString()))
                                : DateFormat('EEE, dd MMMM').format(
                                    DateTime.parse(list[index]['booking_date']
                                        .toString())),
                            style: TextStyle(
                                fontSize: Dim().d14, color: Clr().white)),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/clock.svg'),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                            list[index]['is_reschedule'] == 1
                                ? DateFormat.jm().format(DateTime.parse(
                                    '${list[index]['reschedule_date'].toString()} ${list[index]['reschedule_slot']['slot']}'))
                                : DateFormat.jm().format(DateTime.parse(
                                    '${list[index]['booking_date'].toString()} ${list[index]['slot']['slot']}')),
                            style: TextStyle(
                                fontSize: Dim().d14, color: Clr().white)),
                      ],
                    ),
                  ],
                )
              ],
            ),
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Sty().smallText.copyWith(),
        )
      ],
    );
  }

  void getHome() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'uuid': sUUID ?? "",
      'latitude': sp.getString('lat'),
      'longitude': sp.getString('lng'),
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
        getMedicine();
        labDetails();
        getBooking('');
      });
    }
  }

  Future<void> permissionHandle() async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      getLocation();
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      STM().displayToast('Location permission is required');
      await Geolocator.openAppSettings();
    }
  }

  // getLocation
  getLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    dialog = STM().loadingDialog(ctx, 'Fetching location');
    dialog!.show();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() async {
        sp.setString('lat', position.latitude.toString());
        sp.setString('lng', position.longitude.toString());
        STM().displayToast('Current location is selected');
        dialog!.dismiss();
        getSession();
      });
    }).catchError((e) {
      dialog!.dismiss();
    });
  }

  void getMedicine() async {
    var result = await STM()
        .getWithoutDialogToken(ctx, 'get_medicine', usertoken, 'customer');
    var success = result['success'];
    if (success) {
      setState(() {
        medicineList = result['medicines'];
      });
    }
  }

  // labs details
  void labDetails() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'latitude': sp.getString('lat').toString(),
      'longitude': sp.getString('lng').toString(),
    });
    var result = await STM().postWithTokenWithoutDailog(
        ctx, 'get_labs', body, usertoken, 'customer');
    var success = result['success'];
    if (success) {
      setState(() {
        Lablist = result['labs'];
      });
    }
  }

  void getBooking(id) async {
    FormData body = FormData.fromMap({
      'patient_id': id,
    });
    var result = await STM().postWithTokenWithoutDailog(
        ctx, 'appointment_history', body, usertoken, 'customer');
    var success = result['success'];
    if (success) {
      setState(() {
        appointmentList = result['upcoming_appointments'];
        time = result['time'];
      });
    }
  }
}
