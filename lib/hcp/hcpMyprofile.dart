import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarathi/hcp/hcpBankDetails.dart';
import 'package:saarathi/hcp/hcpeducational.dart';
import 'package:saarathi/hcp/hcphome.dart';
import 'package:saarathi/hcp/hcppersonalinfo.dart';
import 'package:saarathi/hcp/hcpprofessional.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../log_in.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'hcpEditProfile.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late BuildContext ctx;
  String? hcptoken;
  dynamic userdetails;
  Map<String, dynamic> personalinfodata = {};

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      hcptoken = sp.getString('hcptoken') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getProfile();
        print(hcptoken);
      }
    });
  }

  List<String> nameList = [
    "Personal Information",
    "Professional Information",
    "Educational Information",
    "Bank Details"
  ];

  @override
  void initState() {
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, HomeVisit());
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().white,
        appBar: appbarLayout(),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              profileContainer(), // profile Container
              listview(),
              SizedBox(
                height: Dim().d220,
              ),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      sp.clear();
                      STM().finishAffinity(context, SignIn());
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Clr().white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Clr().red),
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Logout',
                      style: Sty().mediumText.copyWith(
                            color: Clr().red,
                            fontWeight: FontWeight.w600,
                          ),
                    )),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              Text(
                'Delete my account',
                style: Sty().mediumText.copyWith(
                      color: Clr().red,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  // profile container
  Widget profileContainer() {
    return Padding(
      padding: EdgeInsets.only(bottom: Dim().d20),
      child: Column(
        children: [
          userdetails == null
              ? Container()
              : Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Clr().borderColor)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dim().d16, vertical: Dim().d16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${userdetails['first_name']} ${userdetails['last_name']}',
                              style: Sty()
                                  .mediumText
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            InkWell(
                                onTap: () {
                                  STM().redirect2page(
                                      ctx,
                                      EditProfile(
                                        userdetils: [
                                          {
                                            'mobile': userdetails['mobile'],
                                            'firstname':
                                                userdetails['first_name'],
                                            'lastname':
                                                userdetails['last_name'],
                                            'emailid': userdetails['email'],
                                            'city': userdetails['city_id'],
                                            'state': userdetails['state_id'],
                                          }
                                        ],
                                      ));
                                },
                                child: SvgPicture.asset(
                                    'assets/edit_myprofile.svg'))
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: Dim().d20,
                          height: Dim().d2,
                          color: Color(0xffFFC107),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          '${userdetails['email']}',
                          style: Sty()
                              .smallText
                              .copyWith(color: Clr().dottedColor),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          '${userdetails['city']['name']}',
                          style: Sty()
                              .smallText
                              .copyWith(color: Clr().dottedColor),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // list of personal and professional
  Widget listview() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: nameList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                child: InkWell(
                  onTap: () {
                    Click(ctx, index);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        nameList[index],
                        style: Sty().mediumText,
                      ),
                      SvgPicture.asset('assets/profile_arrow.svg')
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d8,
              ),
              index == 3 ? Container() : const Divider(),
              SizedBox(height: Dim().d8),
            ],
          );
        });
  }

  // appbar
  AppBar appbarLayout() {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Clr().white,
      leading: InkWell(
        onTap: () {
          STM().finishAffinity(ctx, HomeVisit());
        },
        child: Icon(
          Icons.arrow_back_rounded,
          color: Clr().appbarTextColor,
        ),
      ),
      centerTitle: true,
      title: Text(
        'My Profile',
        style: Sty().largeText.copyWith(
            color: Clr().appbarTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  // this funtion use for personal and professional and educational edit
  void Click(ctx, index) {
    index == 0
        ? STM().redirect2page(
            ctx,
            hcp_Personalinfo(
              pagetype: 'edit',
              data: personalinfodata,
            ))
        : index == 1
            ? STM().redirect2page(
                ctx,
                ProfessionalInfo(
                    pagetype: 'edit', data: userdetails['professional']))
            : index == 2
                ? STM().redirect2page(
                    ctx,
                    EducationalInfo(
                      pagetype: 'edit',
                      data: userdetails['education'],
                      professionaldata: userdetails['professional'],
                    ))
                : STM().redirect2page(ctx, AddBankDetails());
  }

  // getprofile
  void getProfile() async {
    var result = await STM()
        .getWithTokenUrl(ctx, Str().loading, 'get_profile', hcptoken, 'hcp');
    var success = result['success'];
    if (success) {
      setState(() {
        userdetails = result['hcp_user'];
        personalinfodata.addAll({
          'profile': userdetails['profile_pic'],
          'languages': userdetails['languages'],
          'dob': userdetails['dob'],
          'gender': userdetails['gender'],
          'aadharfront': userdetails['aadhaar_first_page'],
          'aadharback': userdetails['aadhaar_second_page'],
          'signaturephoto': userdetails['signature'],
        });
      });
    }
  }
}
