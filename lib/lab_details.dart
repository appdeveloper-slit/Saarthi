import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'payment_summary.dart';

class LabsDetails extends StatefulWidget {
  final dynamic labDetails;

  const LabsDetails({super.key, this.labDetails});

  @override
  State<LabsDetails> createState() => _LabsDetailsState();
}

class _LabsDetailsState extends State<LabsDetails> {
  late BuildContext ctx;
  int? _selectedIndex;
  List clickarrow = [];
  List testids = [];
  List<Map<String, dynamic>> testdetails = [];
  final List<String> _wordName = [
    "Home Collection",
    "Lab Visit",
  ];
  int homecharges = 0;
  int labcharges = 0;
  final items = [
    'Complete urine examination',
    'Complete urine examination2',
  ];

  @override
  void initState() {
    // TODO: implement initState
    print(widget.labDetails);
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
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Icon(
            Icons.arrow_back,
            color: Clr().black,
          ),
        ),
        title: Text(
          widget.labDetails['name'].toString(),
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(Dim().d8),
            child: InkWell(
                onTap: () {
                  // STM().redirect2page(context, Pharmacy());
                },
                child: SvgPicture.asset('assets/search.svg')),
          ),
          SizedBox(
            width: 20,
          ),
        ],
        backgroundColor: Clr().white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.22,
                    color: Color(0xff80C342),
                    alignment: Alignment.center,
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.18,
                        child: Column(
                          children: [
                            Flexible(
                                flex: 2,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0xffcee8b0),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15))),
                                  child: Center(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: Dim().d20),
                                        child: Text(
                                          widget.labDetails['name'].toString(),
                                          style: Sty().mediumText.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            Flexible(
                                flex: 2,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15))),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: Dim().d20),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.labDetails['available_days']
                                                  .toString(),
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              widget.labDetails['available_time']
                                                  .toString(),
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 40,
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          itemCount: 2,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 40,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 1,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = index;
                                  index == 0 ? labcharges = 0 : homecharges = 0;
                                  testids.clear();
                                  testdetails.clear();
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _selectedIndex == index
                                      ? SvgPicture.asset('assets/myaddDot.svg')
                                      : SvgPicture.asset('assets/selectDrop.svg'),
                                  // Icon(_selectedIndex == index
                                  //     ?Icons.check_circle_outline_rounded :
                                  // Icons.circle_outlined,
                                  //     color: _selectedIndex == index
                                  //         ? Color(0xffFA3C5A)
                                  //         : Colors.grey),

                                  Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Text(_wordName[index],
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Color(0xFFFBFBFB),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Lab Address',
                                    style: Sty().largeText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          // fontFamily: Outfit
                                        ),
                                  ),
                                ),
                                SizedBox(height: Dim().d12),
                                Text(
                                  widget.labDetails['address'].toString(),
                                  style: TextStyle(
                                      fontSize: Dim().d16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d16,
                        ),
                        Card(
                          elevation: 0,
                          child: Text(
                            'Select Test :',
                            style: TextStyle(
                                fontSize: Dim().d20, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Divider(),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.labDetails['tests'].length,
                          itemBuilder: (context, index) {
                            return Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    testids.contains(widget.labDetails['tests'][index]['id'])
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                testids.remove(
                                                    widget.labDetails['tests'][index]
                                                        ['id']);
                                                _selectedIndex == 0
                                                    ? homecharges = homecharges -
                                                            widget.labDetails['tests']
                                                                [index]['home_price']
                                                        as int
                                                    : labcharges = labcharges -
                                                            widget.labDetails['tests']
                                                                [index]['lab_price']
                                                        as int;
                                                testdetails.remove(index);
                                              });
                                            },
                                            child: Icon(Icons.check_box,
                                                color: Clr().primaryColor,
                                                size: Dim().d32))
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                testids.add(widget.labDetails['tests']
                                                    [index]['id']);
                                                _selectedIndex == 0
                                                    ? homecharges = homecharges +
                                                            widget.labDetails['tests']
                                                                [index]['home_price']
                                                        as int
                                                    : labcharges = labcharges +
                                                            widget.labDetails['tests']
                                                                [index]['lab_price']
                                                        as int;
                                                _selectedIndex == 0
                                                    ? testdetails.add({
                                                        'id':
                                                            widget.labDetails['tests']
                                                                [index]['id'],
                                                        'name':
                                                            widget.labDetails['tests']
                                                                [index]['name'],
                                                        'price':
                                                            widget.labDetails['tests']
                                                                [index]['home_price']
                                                      })
                                                    : testdetails.add({
                                                        'id':
                                                            widget.labDetails['tests']
                                                                [index]['id'],
                                                        'name':
                                                            widget.labDetails['tests']
                                                                [index]['name'],
                                                        'price':
                                                            widget.labDetails['tests']
                                                                [index]['lab_price']
                                                      });
                                              });
                                            },
                                            child: Icon(Icons.check_box_outline_blank,
                                                size: Dim().d32, color: Clr().grey)),
                                    SizedBox(width: Dim().d20),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                widget.labDetails['tests'][index]
                                                        ['name']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: Dim().d16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Clr().black)),
                                            clickarrow.contains(widget
                                                    .labDetails['tests'][index]['id'])
                                                ? SizedBox(height: Dim().d4)
                                                : Container(),
                                            clickarrow.contains(widget
                                                    .labDetails['tests'][index]['id'])
                                                ? Text(
                                                    widget.labDetails['tests'][index]
                                                            ['description']
                                                        .toString(),
                                                    maxLines: 5,
                                                    style: Sty()
                                                        .mediumText
                                                        .copyWith(color: Clr().grey))
                                                : Container(),
                                          ]),
                                    ),
                                    clickarrow.contains(widget.labDetails['tests'][index]['id'])
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                clickarrow.remove(
                                                    widget.labDetails['tests'][index]
                                                        ['id']);
                                              });
                                            },
                                            child: Icon(
                                                Icons.keyboard_arrow_down_outlined,
                                                color: Clr().black,
                                                size: Dim().d32))
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                clickarrow.add(
                                                    widget.labDetails['tests'][index]
                                                        ['id']);
                                              });
                                            },
                                            child: Icon(
                                                Icons.keyboard_arrow_up_outlined,
                                                size: Dim().d32,
                                                color: Clr().grey)),
                                    if(clickarrow.contains(widget.labDetails['tests'][index]['id']))
                                         SizedBox(height: Dim().d8),
                                  ],
                                ),
                                const Divider(),
                                SizedBox(
                                  height: Dim().d8,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: Dim().d16),
                                  child: Text(
                                    'Test Requirements',
                                    style: Sty()
                                        .mediumText
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d8,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 100,
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    color: const Color(0xFFFBFBFB),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${widget.labDetails['tests'][index]['requirement'].toString()}',
                                            style: Sty().smallText.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Clr().primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: Dim().d16,
            ),
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
                    '₹ ${_selectedIndex == 0 ? homecharges : labcharges}',
                    style: Sty().mediumText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Clr().white),
                  ),
                  SizedBox(
                    height: 30,
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          if(_selectedIndex != null){
                       testdetails.isEmpty ?  STM().displayToast('Please select test') : STM().redirect2page(
                                ctx,
                                PaymentSummary(
                                  testDetails: testdetails,
                                  labdetails: [
                                    {
                                      'id': widget.labDetails['id'],
                                      'labname': widget.labDetails['name'],
                                      'dayname': widget.labDetails['available_days'],
                                      'timename': widget.labDetails['available_time'],
                                      'address': widget.labDetails['address'],
                                    }
                                  ],
                                  type: _selectedIndex,
                                  totalValue: _selectedIndex == 0
                                      ? homecharges
                                      : labcharges,
                                ));
                          }else{
                            STM().displayToast('Please Select type of visit');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Clr().white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Text(
                          'Proceed',
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
    );
  }
}
