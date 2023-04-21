import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hcp/hcpappointmentavailability.dart';
import 'hcp/hcpeducational.dart';
import 'hcp/hcphome.dart';
import 'hcp/hcppersonalinfo.dart';
import 'hcp/hcpprofessional.dart';
import 'home.dart';
import 'log_in.dart';
import 'physical_details.dart';
import 'select_location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool login = sp.getBool('login') ?? false;
  bool personal = sp.getBool('personal') ?? false;
  bool physical = sp.getBool('physical') ?? false;
  bool location = sp.getBool('location') ?? false;
  bool hcppersonal = sp.getBool('hcp_personalinfo') ?? false;
  bool hcpprofessional = sp.getBool('hcp_professionalinfo') ?? false;
  bool hcpeducational = sp.getBool('hcp_educationalinfo') ?? false;
  bool hcpaccount = sp.getBool('hcpaccount') ?? false;
  bool hcplogin = sp.getBool('hcplogin') ?? false;

  await Future.delayed(const Duration(seconds: 3));
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: login
          ? Home()
          : personal
              ? physical
                  ? SelectLocation()
                  : PhysicalDetails()
              : hcplogin
                  ? HomeVisit()
                  : hcppersonal
                      ? hcpeducational
                          ? ApptAvailability()
                          : hcpprofessional
                              ? EducationalInfo()
                              : ProfessionalInfo()
                      : hcpaccount
                          ? hcp_Personalinfo()
                          : SignIn(),
    ),
  );
}
