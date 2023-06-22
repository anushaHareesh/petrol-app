import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/common_data.dart';
import '../components/network_connectivity.dart';

class Controller extends ChangeNotifier {
  double tot_billd_ioc = 0.0;
  double tot_paid_ioc = 0.0;
  double sup_billd = 0.0;
  double sup_paid = 0.0;
  double con_billd = 0.0;
  double con_paid = 0.0;
  double lab_paid = 0.0;
  double total = 0.0;
  var jsonEncoded;
  List<Map<String, dynamic>> list = [];
  List<Map<String, dynamic>> adminReport = [];
  List<Map<String, dynamic>> adminReportContents = [];
  List<Map<String, dynamic>> adminReportTotal = [];
  List iscontentLoading = [];
  // bool iscontentLoading = false;

  bool isReportLoading = false;
  getData() {
    list = [
      {
        'id': 'Bar 1',
        'data': [
          {'domain': '2019', 'measure': 3},
          {'domain': '2020', 'measure': 3},
          {'domain': '2021', 'measure': 4},
          {'domain': '2022', 'measure': 6},
          {'domain': '2023', 'measure': 0.3},
        ],
      },
      {
        'id': 'Bar 2',
        'data': [
          {'domain': '2020', 'measure': 4},
          {'domain': '2021', 'measure': 5},
          {'domain': '2022', 'measure': 2},
          {'domain': '2023', 'measure': 1},
          {'domain': '2024', 'measure': 2.5},
        ],
      },
    ];
  }

////////////////////////////////////////////////////////////////////////
  adminReportData(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = prefs.getString("cid");
    String? user_id = prefs.getString("user_id");
    var map;
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isReportLoading = true;
          notifyListeners();
          Uri url = Uri.parse("$apiurl/load_po_index.php");
          Map body = {"row_id": " "};
          print("body----$body");
          http.Response response = await http.post(url, body: body);
          var map = jsonDecode(response.body);
          print("load_po_index -----$map");
          adminReport.clear();
          for (var item in map) {
            adminReport.add(item);
          }
          iscontentLoading =
              List.generate(adminReport.length, (index) => false);
          isReportLoading = false;
          notifyListeners();
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////
  adminReportDetails(BuildContext context, String pod_a_id, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = prefs.getString("cid");
    String? user_id = prefs.getString("user_id");
    var map;
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          iscontentLoading[index] = true;
          notifyListeners();
          Uri url = Uri.parse("$apiurl/load_dash_po.php");
          Map body = {"row_id": pod_a_id};
          print("body----$body");
          http.Response response = await http.post(url, body: body);
          var map = jsonDecode(response.body);
          print("load_dash_po -----$map");
          adminReportContents.clear();
          for (var item in map) {
            adminReportContents.add(item);
          }
          calculateSum(adminReportContents);
          iscontentLoading[index] = false;
          notifyListeners();
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////
  calculateSum(List<Map<String, dynamic>> listmap) {
    tot_billd_ioc = 0.0;
    tot_paid_ioc = 0.0;
    sup_billd = 0.0;
    sup_paid = 0.0;
    con_billd = 0.0;
    con_paid = 0.0;
    lab_paid = 0.0;
    total = 0.0;
    adminReportTotal = listmap;
    print("ilist map-----$listmap");
    for (var i = 0; i < listmap.length; i++) {
      tot_billd_ioc = tot_billd_ioc + double.parse(listmap[i]["tot_billd_ioc"]);
      tot_paid_ioc = tot_paid_ioc + double.parse(listmap[i]["tot_paid_ioc"]);
      sup_billd = sup_billd + double.parse(listmap[i]["sup_billd"]);
      sup_paid = sup_paid + double.parse(listmap[i]["sup_paid"]);
      con_billd = con_billd + double.parse(listmap[i]["con_billd"]);
      con_paid = con_paid + double.parse(listmap[i]["con_paid"]);
      lab_paid = lab_paid + double.parse(listmap[i]["lab_paid"]);
      total = total + double.parse(listmap[i]["total"]);
    }
    Map<String, dynamic> map = {
      "t_date": "Total",
      "tot_paid_ioc": tot_paid_ioc.toStringAsFixed(2),
      "tot_billd_ioc": tot_billd_ioc.toStringAsFixed(2),
      "sup_billd": sup_billd.toStringAsFixed(2),
      "sup_paid": sup_paid.toStringAsFixed(2),
      "con_billd": con_billd.toStringAsFixed(2),
      "con_paid": con_paid.toStringAsFixed(2),
      "lab_paid": lab_paid.toStringAsFixed(2),
      "total": total.toStringAsFixed(2)
    };
    adminReportTotal.add(map);
    notifyListeners();
    print("total list------$listmap");
  }
}
