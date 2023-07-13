import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarathi/manage/static_method.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'dr_name.dart';
import 'values/colors.dart';
import 'values/styles.dart';

class Nutritionist extends StatefulWidget {
  final id, name;

  const Nutritionist({super.key, this.id, this.name});

  @override
  State<Nutritionist> createState() => _NutritionistState();
}

class _NutritionistState extends State<Nutritionist> {
  late BuildContext ctx;
  List<dynamic> nutritionistList = [];
  String? usertoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getList();
        print(usertoken);
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
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.all(Dim().d16),
        //     child: SvgPicture.asset('assets/filter.svg'),
        //   )
        // ],
        centerTitle: true,
        title: Text(
          '${widget.name}',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            nutritionistList.isEmpty ? SizedBox(
              height: MediaQuery.of(ctx).size.height /1.3,
              child: Center(
                child: Text('No ${widget.name} found',style: Sty().mediumText,),
              ),
            ) : ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: nutritionistList.length,
              itemBuilder: (context, index) {
                return nutritionistLayout(ctx, index, nutritionistList);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget nutritionistLayout(ctx, index, list) {
    List typelist = [];
    List specialityList = [];
    typelist = list[index]['appointment_details'];
    if(list[index]['professional']['speciality_name'] != null){
      for (int a = 0;
      a < list[index]['professional']['speciality_name'].length;
      a++) {
        specialityList
            .add(list[index]['professional']['speciality_name'][a]['name']);
      }
    }
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 0.6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Clr().borderColor)),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                        Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset('assets/map_pin.svg'),
                            SizedBox(
                              width: Dim().d4,
                            ),
                            Text(
                              '${list[index]['distance']} KM',
                              textAlign: TextAlign.end,
                              style: Sty().smallText.copyWith(
                                  color: Clr().primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Text(
                          '${list[index]['first_name']} ${list[index]['last_name']}',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (list[index]['professional']['speciality_name'] != null)
                          SizedBox(
                            width: Dim().d200,
                            child: Text(specialityList.toString().replaceAll('[', '').replaceAll(']', ''),
                                maxLines: 1,
                                style: Sty()
                                    .smallText
                                    .copyWith(fontWeight: FontWeight.w400)),
                          ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        if(list[index]['languages'] != null)
                            SizedBox(
                                width: Dim().d220,
                                child: Text(
                                  'Speaks : ${list[index]['languages'].toString().replaceAll('[', '').replaceAll(']', '')}',
                                  style: Sty()
                                      .smallText
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
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
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Text(
                          '${list[index]['city']['name']}',
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
                height: Dim().d20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Booking prices',
                  style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: Dim().d12,
              ),
              GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 6/3,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  shrinkWrap: true,
                  itemCount: typelist.length,
                  itemBuilder: (context, index) {
                    var v = typelist[index];
                    return Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typelist[index]['type'] == 1
                              ? 'Online'
                              : typelist[index]['type'] == 2
                              ? 'OPD'
                              : 'Home Visit',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w600,),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            typelist[index]['type'] == 1
                                ? SvgPicture.asset(
                                'assets/online_consultation.svg')
                                : typelist[index]['type'] == 2
                                ? SvgPicture.asset('assets/opd.svg')
                                : SvgPicture.asset(
                                'assets/home_visit.svg'),
                            SizedBox(width: Dim().d4),
                            Text('₹${typelist[index]['charges']}',
                                style: Sty().smallText.copyWith( color: Clr().primaryColor)),
                          ],
                        )
                      ],
                    );
                  }),
              SizedBox(height: Dim().d20),
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
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getList() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'latitude': sp.getString('lat'),
      'longitude': sp.getString('lng'),
      'category_id': widget.id,
    });

    var result = await STM().postWithToken(
        ctx, Str().loading, 'doctor_by_category', body, usertoken, 'customer');
    var success = result['success'];
    if (success) {
      setState(() {
        nutritionistList = result['doctors'];
      });
    } else {
      // STM().errorDialog(ctx, message)
    }
  }
}
