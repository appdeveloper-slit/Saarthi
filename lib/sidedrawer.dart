import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/values/colors.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'log_in.dart';
import 'manage/static_method.dart';
import 'my_address.dart';
import 'my_profile.dart';

Widget navbar(context, key) {
  return SafeArea(
    child: WillPopScope(
      onWillPop: () async {
        if (key.currentState.isDrawerOpen) {
          key.currentState.openEndDrawer();
        }
        return true;
      },
      child: Drawer(
        width: 300,
        backgroundColor: Clr().white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Dim().d44,
              ),
              Image.asset(
                'assets/logo.png',
                height: Dim().d160,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: Dim().d24,
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffABE68C)),
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/My Profile.svg',
                  ),
                  title: Text(
                    'My Profile',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    STM().redirect2page(context, MyProfile());
                    // close(key);
                  },
                ),
              ),
              const SizedBox(
                height: 0,
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffFF6363)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/My Address.svg'),
                  title: const Text(
                    'My Address',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    STM().redirect2page(context, MyAddressPage());
                    close(key);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffFAB400)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/Privacy Policy.svg'),
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    // STM().redirect2page(context, MyBooking());
                    // close(key);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffFAB400)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/Terms & Conditions.svg'),
                  title: Text(
                    'Terms & Conditions',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    // STM().redirect2page(context, MyOrders());
                    // // STM().openWeb('https://magicbuyandsell.com/Arham/privacy_policy');
                    // close(key);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffFAB400)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/Share App.svg'),
                  title: Text(
                    'Share App',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    // STM().redirect2page(context, MyCart());
                    // STM().openWeb('https://magicbuyandsell.com/Arham/terms_conditions');
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffE683F0)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/About Us.svg'),
                  title: const Text(
                    'About Us',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    // var message =
                    //     'Download The Arham App from below link\n\n https://play.google.com/store/apps/details?id=org.arhamparivar.arhamparivar';
                    // Share.share(message);
                  },
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffF1B382)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/contact.svg'),
                  title: Text(
                    'Contact Us',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    // STM().redirect2page(context, AboutUs());
                    // close(key);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffF1B382)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/Log Out.svg'),
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () async {
                    SharedPreferences sp = await SharedPreferences.getInstance();
                    sp.clear();
                    STM().finishAffinity(context, SignIn());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void close(key) {
  key.currentState.openEndDrawer();
}