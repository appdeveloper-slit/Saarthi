import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'your_cart.dart';
class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late BuildContext ctx;
  // List<dynamic> sliderList = [];
  CarouselController sliderCtrl = CarouselController();
  // List<dynamic> sliderList = ['assets/mybooking.png'];
  final List<String> sliderList = ["assets/myoders.png"];
  int selectedSlider = 0;
  String AppointmentValue = 'Online Appointment';
  List<String> AppointmentList = [
    'Online Appointment',
    'Home Visit',
  ];


  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
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
        centerTitle: true,
        title: Text(
          'Dolo 650 mg 15 Tablets',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0.6,
              child: Column(
                children: [
                  SizedBox(
                    height: Dim().d12,
                  ),
                  CarouselSlider(
                    carouselController: sliderCtrl,
                    options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        viewportFraction: 1,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            selectedSlider = index;
                          });
                        }),
                    items: sliderList.map((e) =>  ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        fit: StackFit.loose,
                        children: <Widget>[
                          Image.asset(
                            e,width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        ],
                      ),
                    ))
                        .toList(),
                  ),

                  SizedBox(
                    height: Dim().d8,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sliderList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: Dim().d8,
                          height: Dim().d8,
                          margin: EdgeInsets.only(
                            right: Dim().d8,
                          ),
                          decoration: BoxDecoration(
                            color: selectedSlider == index
                                ? Clr().primaryColor
                                : Color(0xffB3B3B3),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dim().d12,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: Text(
                    'Dolo 650 mg 15 Tablets',
                    style: Sty()
                        .mediumText
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 25,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          // STM().redirect2page(ctx, MyCart());
                        },
                        child: Text(
                          'Pack Of 25',
                          style: TextStyle(fontSize: 15, color: Color(0xffA6A6A6)),
                        ),
                        style: ElevatedButton.styleFrom( elevation: 0,
                            backgroundColor: Colors.white,
                            side: BorderSide(width: 1,color: Color(0xffA6A6A6)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)))),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          // STM().redirect2page(ctx, OTP());
                        },
                        style: ElevatedButton.styleFrom( elevation: 0,
                            backgroundColor: Clr().primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: Text(
                          'Pack Of 50',
                          style: Sty().mediumText.copyWith(
                              color: Clr().white,
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration:  BoxDecoration(

                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset: Offset(0, 0), // changes position of shadow

                              ),
                            ],
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Inclusive of all taxes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  )), SizedBox(height: Dim().d8,),
                              Row(
                                children: [
                                  Text(
                                    '₹ 28.98',
                                    style: Sty()
                                        .mediumText
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: Dim().d8,),
                                  Text(' ₹ 700',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2,
                                      )),
                                  SizedBox(width: Dim().d8,),
                                  Text(
                                    '15%OFF',
                                    style: Sty()
                                        .mediumText
                                        .copyWith(fontSize: 16, color: Clr().red),
                                  ),

                                ],
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        height: 46,
                        width: 120,
                        child: ElevatedButton(
                            onPressed: () {
                              STM().redirect2page(ctx, MyCart());
                            },
                            style: ElevatedButton.styleFrom( elevation: 0,
                              backgroundColor: Clr().primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            child: Text(
                              'Add to Cart',
                              style: Sty().smallText.copyWith(
                                  color: Clr().white, fontWeight: FontWeight.w600),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:EdgeInsets.symmetric(horizontal: Dim().d16),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Clr().borderColor)
                    ),
                    // shape: Border.all(
                    //     color: Colors.black12),
                    child: Padding(
                      padding: EdgeInsets.only(top:Dim().d16,bottom:Dim().d16,left: Dim().d8,right: Dim().d8 ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: Dim().d4),
                            child: Text(
                              'Check Delivery Availability',
                              style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(

                            // controller: mobileCtrl,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              filled: true,

                              border: OutlineInputBorder( borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),


                              fillColor: Clr().white,

                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Clr().primaryColor, width: 1.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              // label: Text('Enter Your Number'),

                              hintText: "Enter Pincode Here",
                              suffixIcon:Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('Check',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                              ),
                              hintStyle: Sty()
                                  .mediumText
                                  .copyWith(color: Clr().shimmerColor, fontSize: 14),
                              counterText: "",
                            ),
                          ),
                          SizedBox(
                            height: Dim().d12,
                          ),
                          Padding(
                            padding:  EdgeInsets.only(left: Dim().d4),
                            child: Text(
                              'Yeah! We deliver at this Pincode',
                              style: Sty()
                                  .smallText
                                  .copyWith(fontSize: 12, color: Clr().primaryColor),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dim().d8,horizontal:Dim().d16 ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  Text(
                    'What is Dolo 650 Tablet used for?',
                    style: TextStyle(fontWeight: FontWeight.w600,decoration: TextDecoration.underline,
                      shadows: [Shadow(offset: Offset(0, 0), color: Colors.black)],),
                  ),

                  Text(
                    'Dolo 650 is a well-known and widely used medicine for fever and pain relief. It frequently used to treat low and moderate pain conditions such as headaches, toothaches, migraines, menstrual cramps, and sprains. It is a safe drug and can be used to treat conditions where people must take painkillers for a longer time, such as musculoskeletal pain.',
                    style: Sty()
                        .smallText
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  Text(
                    'What is Dolo 650 Tablet used for?',
                    style: TextStyle(fontWeight: FontWeight.w600,decoration: TextDecoration.underline,
                      shadows: [Shadow(offset: Offset(0, 0), color: Colors.black)],),
                  ),

                  Text(
                    'Dolo 650 is a well-known and widely used medicine for fever and pain relief. It frequently used to treat low and moderate pain conditions such as headaches, toothaches, migraines, menstrual cramps, and sprains. It is a safe drug and can be used to treat conditions where people must take painkillers for a longer time, such as musculoskeletal pain.',
                    style: Sty()
                        .smallText
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  Text(
                    'What is Dolo 650 Tablet used for?',
                    style: TextStyle(fontWeight: FontWeight.w600,decoration: TextDecoration.underline,
                      shadows: [Shadow(offset: Offset(0, 0), color: Colors.black)],),
                  ),

                  Text(
                    'Dolo 650 is a well-known and widely used medicine for fever and pain relief. It frequently used to treat low and moderate pain conditions such as headaches, toothaches, migraines, menstrual cramps, and sprains. It is a safe drug and can be used to treat conditions where people must take painkillers for a longer time, such as musculoskeletal pain.',
                    style: Sty()
                        .smallText
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 30,
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
                      '₹ 590.00',
                      style: Sty().mediumText.copyWith(
                        fontSize: 18,
                          fontWeight: FontWeight.w600, color: Clr().white),
                    ),
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: ElevatedButton(
                          onPressed: () {
                            STM().redirect2page(ctx, MyCart());
                          },
                          style: ElevatedButton.styleFrom( elevation: 0,
                            backgroundColor: Clr().white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Text(
                            'Continue',
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
  Widget itemSlider(e) {
    return Image.asset(
      e['image_path'],
      height: 140,
      width: 100,
      fit: BoxFit.fill,
    );
  }
}
