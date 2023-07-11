import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../bottomSheet/search_data_sheet.dart';
import '../components/common_data.dart';
import '../components/network_connectivity.dart';
import '../screen/ad_report_screen.dart';

class Controller extends ChangeNotifier {
  double tot_billd_ioc = 0.0;
  double tot_paid_ioc = 0.0;
  double sup_billd = 0.0;
  double sup_paid = 0.0;
  double con_billd = 0.0;
  double con_paid = 0.0;
  double lab_paid = 0.0;
  double total = 0.0;
  bool isSearch = false;
  bool issearching = false;
  bool searchingapi = false;

  var jsonEncoded;
  List<Map<String, dynamic>> list = [];
  List<Map<String, dynamic>> adminReport = [];
  List<Map<String, dynamic>> adminReportContents = [];
  List<Map<String, dynamic>> adminReportTotal = [];
  List<Map<String, dynamic>> sub_contractor_report = [];
  List<Map<String, dynamic>> newSubReportList = [];
  List<Map<String, dynamic>> newadminbReportList = [];

  List<Map<String, dynamic>> searchPdSupplier = [];
  List<Map<String, dynamic>> searchPdSupplierDetails = [];
  List iscontentLoading = [];
  List isExpanded = [];
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
  adminReportData(BuildContext context, String rowId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = prefs.getString("cid");
    String? userId = prefs.getString("user_id");
    var map;
    // ignore: use_build_context_synchronously
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isReportLoading = true;
          notifyListeners();
          Uri url = Uri.parse("$apiurl/load_po_index.php");
          Map body = {"row_id": rowId,};
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
          isExpanded = List.generate(adminReport.length, (index) => false);
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
  adminReportDetails(
      BuildContext context, String podAId, int index, String poCoNo,String poNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? cid = prefs.getString("cid");
    String? userId = prefs.getString("user_id");
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          iscontentLoading[index] = true;
          notifyListeners();
          Uri url = Uri.parse("$apiurl/load_dash_po.php");
          Map body = {"row_id": podAId};
          print("body----$body");
          http.Response response = await http.post(url, body: body);
          var map = jsonDecode(response.body);
          print("load_dash_po -----$map");
          adminReportContents.clear();
          for (var item in map) {
            adminReportContents.add(item);
          }
          if (adminReportContents.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 5),
              content: Text('No Data !!!!'),
            ));
          } else {
            calculateSum(adminReportContents);
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdMInReportContentScreen(
                      index: index, po_con_number: poCoNo,po_no: poNo,)),
            );
          }
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

  ///////////////////////////////////////////////////////////////////
  subContractorReport(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = prefs.getString("cid");
    String? userId = prefs.getString("user_id");
    var map;
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) { 
        try {
          isReportLoading = true;
          notifyListeners();
          Uri url = Uri.parse("$apiurl/load_contrct_dash.php");
          Map body = {"user_id": userId};
          print("body----$body");
          http.Response response = await http.post(url, body: body);
          var map = jsonDecode(response.body);
          print("load_contrct_dash-----$map");
          sub_contractor_report.clear();
          for (var item in map) {
            sub_contractor_report.add(item);
          }
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

  setIssearch(bool val) {
    isSearch = val;
    notifyListeners();
  }
//////////////////////////////////////////////////////////////////////////////
  subConReportSearchHistory(BuildContext context, String text) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          issearching = true;
          notifyListeners();
          if (text.isNotEmpty) {
            isSearch = true;
            notifyListeners();
            newSubReportList = sub_contractor_report
                .where((e) =>
                    e["pa_no"].toLowerCase().contains(text.toLowerCase()) ||
                    e["c_name"].toLowerCase().contains(text.toLowerCase()))
                .toList();
          } else {
            newSubReportList = sub_contractor_report;
          }
          issearching = false;
          notifyListeners();
          print("new list----$newSubReportList");
        } catch (e) {
          // return null;
          return [];
        }
      }
    });
  }
///////////////////////////////////////////////////////////////////////////
  adminReportSearchHistory(BuildContext context, String text) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          issearching = true;
          notifyListeners();
          if (text.isNotEmpty) {
            isSearch = true;
            notifyListeners();
            newadminbReportList = adminReport
                .where((e) =>
                    e["po_con_no"].toLowerCase().contains(text.toLowerCase()) ||
                    e["po_no"].toLowerCase().contains(text.toLowerCase()))
                .toList();
          } else {
            newadminbReportList = adminReport;
          }
          issearching = false;
          notifyListeners();
          print("new adminReport---$newadminbReportList");
        } catch (e) {
          // return null;
          return [];
        }
      }
    });
  }

  ///////////////////////////////////////////////////////////////////////
  searchPdctSupplier(BuildContext context, String cType, String cName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = prefs.getString("cid");
    String? userId = prefs.getString("user_id");
    var map;
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          print("sdjhfjhbf-----$cType");
          searchingapi = true;
          notifyListeners();
          Uri url = Uri.parse("$apiurl/fetch_all_sup_and_pdt.php");
          Map body = {"c_type": cType, "c_name": cName};
          print("item search  body----$body");
          http.Response response = await http.post(url, body: body);
          var map = jsonDecode(response.body);
          print("fetch_all_sup_and_pdt-----$map");
          searchPdSupplier.clear();
          for (var item in map) {
            searchPdSupplier.add(item);
          }
          searchingapi = false;

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

  ///////////////////////////////////////////////////////////////////
  fetch_Suppl_prdct_data(
      BuildContext context, String type, String rowId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = prefs.getString("cid");
    String? userId = prefs.getString("user_id");
    var map;
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          Uri url = Uri.parse("$apiurl/fetch_sup_pdt.php");
          Map body = {"row_id": rowId, "type": type};
          print("search det body----$body");
          http.Response response = await http.post(url, body: body);
          var map = jsonDecode(response.body);
          // print("suppl and prdct data-----$map");
          searchPdSupplierDetails.clear();
          for (var item in map) {
            searchPdSupplierDetails.add(item);
          }
          if (searchPdSupplierDetails.isNotEmpty) {
            SearchDataSheet searchsheet = SearchDataSheet();
            // ignore: use_build_context_synchronously
            searchsheet.showSearchDataSheet(context, type);
          }
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
}
