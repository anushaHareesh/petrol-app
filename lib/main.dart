import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petrol/controller/controller.dart';
import 'package:petrol/screen/admin_dahboard_data.dart';
import 'package:petrol/screen/login.dart';
import 'package:petrol/screen/registration.dart';
import 'package:petrol/screen/sub_contractor_report.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/registration_controller.dart';

bool isLoggedIn = false;
bool isRegistered = false;
String? user_type;
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// contractor key----RP67MBTRBGBC
//user--satish,pwd--123 
// admin key -----RP67MBTRBGBE
//user---user,pwd---123456
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  isLoggedIn = await checkLogin();
  isRegistered = await checkRegistration();
  requestPermission();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Controller()),
      ChangeNotifierProvider(create: (_) => RegistrationController()),
    ],
    child: MyApp(),
  ));
  FlutterNativeSplash.remove();
}

void requestPermission() async {
  // var statusbl= await Permission.bluetooth.status;

  var status1 = await Permission.manageExternalStorage.status;

  if (!status1.isGranted) {
    await Permission.storage.request();
  }
  if (!status1.isGranted) {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      await Permission.bluetooth.request();
    } else {
      openAppSettings();
    }
    // await Permission.app
  }
  if (!status1.isRestricted) {
    await Permission.manageExternalStorage.request();
  }
  if (!status1.isPermanentlyDenied) {
    await Permission.manageExternalStorage.request();
  }
}

checkLogin() async {
  bool isAuthenticated = false;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setString("st_uname", "anu");
  // prefs.setString("st_pwd", "anu");
  final stUname = prefs.getString("st_uname");
  final stPwd = prefs.getString("st_pwd");
  user_type = prefs.getString("user_type");
  // print("user----$user_type");
  if (stUname != null && stPwd != null) {
    isAuthenticated = true;
  } else {
    isAuthenticated = false;
  }
  return isAuthenticated;
}

checkRegistration() async {
  bool isAuthenticated = false;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setString("st_uname", "anu");
  // prefs.setString("st_pwd", "anu");
  final cid = prefs.getString("cid");

  if (cid != null) {
    isAuthenticated = true;
  } else {
    isAuthenticated = false;
  }
  return isAuthenticated;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // print("user----$user_type");
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 2, 48, 87),
          secondaryHeaderColor: const Color.fromARGB(255, 100, 178, 241),
          // primaryColor: Colors.red[400],
          // accentColor: Color.fromARGB(255, 248, 137, 137),
          scaffoldBackgroundColor: Colors.white,
          // fontFamily: 'Roboto Mono sample',
          visualDensity: VisualDensity.adaptivePlatformDensity,

          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
          // scaffoldBackgroundColor: P_Settings.bodycolor,
          // textTheme: const TextTheme(
          //   headline1: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          //   headline6: TextStyle(
          //     fontSize: 25.0,
          //   ),
          //   bodyText2: TextStyle(
          //     fontSize: 14.0,
          //   ),
          // ),
        ),
        navigatorKey: navigatorKey,
        // home: Login());
        home: isRegistered
            ? isLoggedIn && user_type == "BE"
                ? const AdminDashboardData()
                : isLoggedIn && user_type == "BC"
                    ? const SubContractorReport()
                    : Login()
            : const Registration());
  }
}
