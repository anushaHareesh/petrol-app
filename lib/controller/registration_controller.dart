import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petrol/components/custom_snackbar.dart';
import 'package:petrol/components/external_dir.dart';
import 'package:petrol/db_helper.dart';
import 'package:petrol/model/login_model.dart';
import 'package:petrol/model/registration_model.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../components/common_data.dart';
import '../components/network_connectivity.dart';

class RegistrationController extends ChangeNotifier {
  String? userName;
  bool scheduleOpend = false;
  bool isMenuLoading = false;
  bool isAdminLoading = false;
  bool isServSchedulelIstLoadind = false;
  int scheduleListCount = 0;
  String? pendingEnq;
  String? pendingQtn;
  String? cnfQut;
  String? pendingSer;
  String? cust_id;
  String? cust_name;
  List<String> servceScheduldate = [];
  bool isProdLoding = false;
  DateTime now = DateTime.now();
  String? dateToday;
  int servicescheduleListCount = 0;
  List<Map<String, dynamic>> todyscheduleList = [];
  List<Map<String, dynamic>> tomarwscheduleList = [];

  List<Map<String, dynamic>> servicescheduleList = [];
  List<Map<String, dynamic>> servicesProdList = [];
  List<bool> showComplaint = [];
  bool isSchedulelIstLoadind = false;
  String? staffName;
  bool isLoading = false;
  bool isLoginLoading = false;


  ExternalDir externalDir = ExternalDir();
  String? menuIndex;
  String? fp;
  String? cid;
  String? cname;
  String? sof;
  int? qtyinc;
  String? uid;
  List<Map<String, dynamic>> menuList = [];
  List<Map<String, dynamic>> confrmedQuotGraph = [];
  List<Map<String, dynamic>> userservDone = [];
  String? appType;
  String? bId;
  // ignore: non_constant_identifier_names
  List<CD> c_d = [];
  String? firstMenu;
///////////////////////////////////////////////////////////////////
  Future<RegistrationData?> postRegistration(
      String companyCode,
      String? fingerprints,
      String phoneno,
      String deviceinfo,
      BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      print("Text fp...$fingerprints---$companyCode---$phoneno---$deviceinfo");
      if (companyCode.length >= 0) {
        appType = companyCode.substring(10, 12);
      }
      if (value == true) {
        try {
          Uri url =
              Uri.parse("https://trafiqerp.in/order/fj/get_registration.php");
          Map body = {
            'company_code': companyCode,
            'fcode': fingerprints,
            'deviceinfo': deviceinfo,
            'phoneno': phoneno
          };
          print("body----$body");
          isLoading = true;
          notifyListeners();
          http.Response response = await http.post(
            url,
            body: body,
          );
          print("body $body");
          var map = jsonDecode(response.body);

          RegistrationData regModel = RegistrationData.fromJson(map);

          sof = regModel.sof;
          fp = regModel.fp;
          String? msg = regModel.msg;

          if (sof == "1") {
            if (appType == 'BE') {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              /////////////// insert into local db /////////////////////
              String? fp1 = regModel.fp;

              print("fingerprint......$fp1");
              prefs.setString("fp", fp!);
              String? os = regModel.os;
              regModel.c_d![0].cid;
              cid = regModel.cid;
              prefs.setString("cid", cid!);

              cname = regModel.c_d![0].cnme;
              notifyListeners();

              await externalDir.fileWrite(fp1!);

              // ignore: duplicate_ignore
              for (var item in regModel.c_d!) {
                print("ciddddddddd......$item");
                c_d.add(item);
              }
              // verifyRegistration(context, "");

              isLoading = false;
              notifyListeners();

              prefs.setString("os", os!);

              // prefs.setString("cname", cname!);

              String? user = prefs.getString("userType");

              print("fnjdxf----$user");

              await PetrolApp.instance
                  .deleteFromTableCommonQuery("companyRegistrationTable", "");
              var res = await PetrolApp.instance
                  .insertRegistrationDetails(regModel);
              // getMaxSerialNumber(os);
              // getMenuAPi(cid!, fp1, company_code, context);

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Login()),
              // );
            } else {
              CustomSnackbar snackbar = CustomSnackbar();

              snackbar.showSnackbar(context, "Invalid Apk Key", "");
            }
          }
          /////////////////////////////////////////////////////
          if (sof == "0") {
            CustomSnackbar snackbar = CustomSnackbar();
            // ignore: use_build_context_synchronously
            snackbar.showSnackbar(context, msg.toString(), "");
          }

          notifyListeners();
        } catch (e) {
          print(e);
          return null;
        }
      }
    });
  }
  //////////////////////////////////////////////////////////
    getLogin(
      String userName, String password, BuildContext context) async {
    var restaff;
    try {
      Uri url = Uri.parse("$apiurl/login.php");
      Map body = {'user': userName, 'pass': password};

      isLoginLoading = true;
      notifyListeners();
      http.Response response = await http.post(
        url,
        body: body,
      );
      print("login body ${body}");

      var map = jsonDecode(response.body);
      print("login map ${map}");
      LoginModel loginModel;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (map == null || map.length == 0) {
        CustomSnackbar snackbar = CustomSnackbar();
        snackbar.showSnackbar(context, "Incorrect Username or Password", "");
        isLoginLoading = false;
        notifyListeners();
      } else {
        prefs.setString("st_uname", userName);
        prefs.setString("st_pwd", password);

        for (var item in map) {
          loginModel = LoginModel.fromJson(item);
          prefs.setString("user_id", loginModel.userId!);
          prefs.setString("branch_id", loginModel.branchId!);
          prefs.setString("password", loginModel.pass!);
          prefs.setString("staff_name", loginModel.staffName!);
          prefs.setString("branch_name", loginModel.branchName!);
          prefs.setString("branch_prefix", loginModel.branchPrefix!);
          prefs.setString("mobile_user_type", loginModel.mobile_menu_type!);
          prefs.setString("userGroup", loginModel.usergroup!);
        }
        // getMenu(context);
      }

      // print("stafff-------${loginModel.staffName}");
      notifyListeners();
      // return staffModel;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
