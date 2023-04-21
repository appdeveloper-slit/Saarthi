import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

class MyWallet extends StatefulWidget {
  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  late BuildContext ctx;
  dynamic walletbalance = 0;
  List<dynamic> walletList = [];
  String? hcptoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      hcptoken = sp.getString('hcptoken') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getWalletHistory();
        print(hcptoken);
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
          'My Wallet',
          style: Sty().largeText.copyWith(color: Clr().black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(0),
              color: Clr().primaryColor,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Dim().d16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Wallet Balance',
                        style: Sty()
                            .mediumText
                            .copyWith(fontSize: 18, color: Clr().white),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Text(
                        '₹${walletbalance}',
                        style: Sty().mediumText.copyWith(
                            fontSize: 22,
                            color: Clr().white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            walletList.isEmpty ? Center(
              child: Text('No History',style: Sty().mediumBoldText),
            ) : ListView.builder(
              itemCount: walletList.length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return walletLayout(ctx, index, walletList);
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget walletLayout(ctx, index , List){
    return Container(
      margin: EdgeInsets.only(bottom: Dim().d12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Clr().grey.withOpacity(0.1),
            spreadRadius: 0.1,
            blurRadius: 12,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: ClipPath(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: List[index]['type'] == "1" ? Clr().green : Clr().red, width: 5),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 0,left: Dim().d16,top: Dim().d16,bottom: Dim().d16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Transaction ID')),
                      SizedBox(width: Dim().d20),
                      Text(':'),
                      SizedBox(width: Dim().d32),
                      Expanded(child: Text('${List[index]['transaction_id'] == null ? '': List[index]['transaction_id']}')),
                    ],
                  ),
                  SizedBox(height: Dim().d12,),
                  Row(
                    children: [
                      Expanded(child: Text('Date')),
                      SizedBox(width: Dim().d20),
                      Text(':'),
                      SizedBox(width: Dim().d32),
                      Expanded(child: Text(List[index]['created_at'])),
                    ],
                  ),
                  SizedBox(height: Dim().d12),
                  Row(
                    children: [
                      Expanded(child: Text(List[index]['type'] == "1" ? 'credit':'debit',
                        style: Sty().smallText.copyWith(
                          color: List[index]['type'] == "1" ? Clr().green : Clr().red,
                        ),)),
                      SizedBox(width: Dim().d20),
                      Text(':'),
                      SizedBox(width: Dim().d32),
                      Expanded(child: Text(List[index]['type'] == "1" ? '+${List[index]['amount'].toString()}' : '-${List[index]['amount'].toString()}',
                        style: Sty().smallText.copyWith(color: List[index]['type'] == "1" ? Clr().green : Clr().red),)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
        ),
      ),
    );
  }


  // wallet history
 void getWalletHistory() async{
    var result = await STM().getWithTokenUrl(ctx, Str().loading, 'get_wallet_history', hcptoken, 'hcp');
    var success = result['success'];
    if(success){
      setState(() {
        walletbalance = result['total_amount'];
        walletList = result['get_wallet'];
      });
   }
 }
}
