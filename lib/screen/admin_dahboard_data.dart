import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:petrol/controller/registration_controller.dart';
import 'package:petrol/screen/ad_report_screen.dart';
import 'package:petrol/screen/login.dart';
import 'package:petrol/screen/search/itemSearch.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_deta_table.dart';
import '../controller/controller.dart';
import 'admin_report_table.dart';

class AdminDashboardData extends StatefulWidget {
  const AdminDashboardData({super.key});

  @override
  State<AdminDashboardData> createState() => _AdminDashboardDataState();
}

class _AdminDashboardDataState extends State<AdminDashboardData> {
  int selectedTile = -1;
  TextEditingController controller = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? formattedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary:
                    Theme.of(context).primaryColor, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold) // button text color
                    ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
        Provider.of<Controller>(context, listen: false)
            .adminReportData(context, formattedDate.toString());
      });
    }
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // ignore: use_build_context_synchronously
    Provider.of<Controller>(context, listen: false)
        .adminReportData(context, '');
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    Provider.of<RegistrationController>(context, listen: false).getUserData();

    Provider.of<Controller>(context, listen: false)
        .adminReportData(context, '');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Consumer<RegistrationController>(
            builder: (context, value, child) => Row(
              children: [
                Image.asset(
                  "assets/man2.png",
                  height: size.height * 0.036,
                ),
                SizedBox(
                  width: size.width * 0.01,
                ),
                value.name == null
                    ? const SpinKitChasingDots(
                        size: 12,
                        color: Colors.white,
                      )
                    : Flexible(
                        child: Text(
                          // 'anush ah vayakalail house thottada kannur ',
                          value.name.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      )
              ],
            ),
          ),
          actions: [
            PopupMenuButton(
                icon: const Icon(Icons.more_vert,
                    color: Colors.white), // add this line
                itemBuilder: (_) => <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                          child: Container(
                              width: 100,
                              // height: 30,
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )),
                          value: 'logout'),
                    ],
                onSelected: (index) async {
                  switch (index) {
                    case 'logout':
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('st_uname');
                      await prefs.remove('st_pwd');
                      // ignore: use_build_context_synchronously
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Login();
                          },
                        ),
                        (_) => false,
                      );
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => Login()));
                    // break;
                  }
                })
          ],
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Consumer<Controller>(
            builder: (context, value, child) => value.isReportLoading
                ? const SpinKitCircle(
                    color: Colors.black,
                  )
                : SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    onRefresh: _onRefresh,
                    child: Column(
                      children: [
                        Container(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                leading: const Icon(Icons.search),
                                title: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(
                                      hintText:
                                          'Search with PO no: or PO Con no: ',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none),
                                  onChanged: (val) {
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .adminReportSearchHistory(context, val);
                                  },
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () {
                                    value.setIssearch(false);
                                    controller.clear();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   height: size.height * 0.09,
                        //   decoration: BoxDecoration(
                        //       color: Theme.of(context).primaryColor),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       InkWell(
                        //         onTap: () {
                        //           value.searchPdSupplier.clear();
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => SearchScreen(
                        //                       c_type: "1",
                        //                     )),
                        //           );
                        //         },
                        //         child: Container(
                        //             width: size.width * 0.43,
                        //             height: size.height * 0.05,
                        //             decoration: BoxDecoration(
                        //               color: Colors.green,
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //                 Text(
                        //                   "Item Search",
                        //                   style: TextStyle(
                        //                       color: Colors.white,
                        //                       fontWeight: FontWeight.bold),
                        //                 ),
                        //                 SizedBox(
                        //                   width: size.width * 0.012,
                        //                 ),
                        //                 Image.asset(
                        //                   "assets/search.png",
                        //                   height: size.height * 0.023,
                        //                 )
                        //                 // Icon(
                        //                 //   Icons.search,
                        //                 //   color: Colors.white,
                        //                 // )
                        //               ],
                        //             )),
                        //       ),
                        //       InkWell(
                        //         onTap: () {
                        //           value.searchPdSupplier.clear();
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => SearchScreen(
                        //                       c_type: "2",
                        //                     )),
                        //           );
                        //         },
                        //         child: Container(
                        //             width: size.width * 0.43,
                        //             height: size.height * 0.05,
                        //             decoration: BoxDecoration(
                        //               color: Colors.green,
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //                 Text(
                        //                   "Supplier Search",
                        //                   style: TextStyle(
                        //                       color: Colors.white,
                        //                       fontWeight: FontWeight.bold),
                        //                 ),
                        //                 SizedBox(
                        //                   width: size.width * 0.012,
                        //                 ),

                        //                 Image.asset(
                        //                   "assets/search.png",
                        //                   height: size.height * 0.023,
                        //                 )
                        //                 // Icon(
                        //                 //   Icons.search,
                        //                 //   color: Colors.white,
                        //                 // )
                        //               ],
                        //             )),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: size.height * 0.01,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _selectDate(context);
                                      },
                                      icon: Image.asset("assets/calendar.png")),
                                  Text(
                                    "$formattedDate",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              // Lottie.asset("assets/swipe.json", height: 53),
                              // Container(
                              //   decoration: new BoxDecoration(
                              //     color: Colors.blue,
                              //     shape: BoxShape.circle,
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: Center(
                              //       child: Image.asset(
                              //         "assets/right_arrow.png",
                              //         height: 18,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        value.adminReport.isEmpty
                            ? SizedBox(
                                height: size.height * 0.65,
                                child: Center(
                                  child: LottieBuilder.asset(
                                    "assets/noData.json",
                                    height: size.height * 0.2,
                                  ),
                                ),
                              )
                            // : AdminTableData(),
                            : value.issearching
                                ? SpinKitCircle(
                                    color: Theme.of(context).primaryColor,
                                  )
                                : value.isSearch &&
                                        value.newadminbReportList.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 14, left: 13),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "No data Found !!!",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          // physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: value.isSearch &&
                                                  value.newadminbReportList
                                                      .isNotEmpty
                                              ? value.newadminbReportList.length
                                              : value.adminReport.length,
                                          itemBuilder: (context, index) {
                                            return customCard(
                                                value.adminReport[index],
                                                index,
                                                size);
                                          },
                                        ),
                                      )
                      ],
                    ),
                  )),
      ),
    );
  }

  Widget customCard(Map<String, dynamic> map, int index, Size size) {
    // print("jcjcz-----$map");
    return Consumer<Controller>(
        builder: (context, value, child) => InkWell(
              onTap: () {
                if (value.isSearch && value.newadminbReportList.isNotEmpty) {
                  Provider.of<Controller>(context, listen: false)
                      .adminReportDetails(
                          context,
                          value.newadminbReportList[index]["pod_a_id"],
                          index,
                          value.newadminbReportList[index]["po_con_no"],
                          value.newadminbReportList[index]["po_no"]);
                } else {
                  Provider.of<Controller>(context, listen: false)
                      .adminReportDetails(context, map["pod_a_id"], index,
                          map["po_con_no"], map["po_no"]);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 2.0, bottom: 2, left: 8, right: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.06,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: Center(
                            child: Text(
                          value.isSearch && value.newadminbReportList.isNotEmpty
                              ? value.newadminbReportList[index]["po_no"]
                              : map["po_no"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17),
                        )),
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Po Con  No : ",
                      //       style: TextStyle(color: Colors.grey[500]),
                      //     ),
                      //     Text(map["po_con_no"]),
                      //   ],
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 5, top: 5),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/po_num.png",
                              height: size.height * 0.02,
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            SizedBox(
                              width: size.width * 0.3,
                              child: Row(
                                children: [
                                  Text(
                                    "Po Con No ",
                                    style: TextStyle(
                                        color: Colors.grey[500], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                value.isSearch &&
                                        value.newadminbReportList.isNotEmpty
                                    ? ": ${value.newadminbReportList[index]["po_con_no"]}"
                                    : ": ${map["po_con_no"]}",
                                // "sjfkzsnfjkzssfn fsnfjkjfjkn fmnfjkxfjd fmfnjxfjkxnf xfnfj",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Text(map['po_date'])
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 5, top: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/date.png",
                              height: size.height * 0.02,
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            SizedBox(
                              width: size.width * 0.3,
                              child: Text(
                                "Date",
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                value.isSearch &&
                                        value.newadminbReportList.isNotEmpty
                                    ? ": ${value.newadminbReportList[index]["po_date"]}"
                                    : ": ${map["po_date"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 5, top: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/money.png",
                              height: size.height * 0.02,
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            SizedBox(
                              width: size.width * 0.3,
                              child: Text(
                                "Po Amount",
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                value.isSearch &&
                                        value.newadminbReportList.isNotEmpty
                                    ? ": \u{20B9}${value.newadminbReportList[index]["po_amount1"]}"
                                    : ": \u{20B9}${map["po_amount1"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 5, top: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/money.png",
                              height: size.height * 0.02,
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            SizedBox(
                              width: size.width * 0.3,
                              child: Text(
                                "Billed Value",
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                value.isSearch &&
                                        value.newadminbReportList.isNotEmpty
                                    ? ": \u{20B9}${value.newadminbReportList[index]["tot_billd1"]}"
                                    : ": \u{20B9}${map["tot_billd1"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 5, top: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/money.png",
                              height: size.height * 0.02,
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            SizedBox(
                              width: size.width * 0.3,
                              child: Text(
                                "Total Paid",
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                value.isSearch &&
                                        value.newadminbReportList.isNotEmpty
                                    ? ": \u{20B9}${value.newadminbReportList[index]["tot_paid1"]}"
                                    : ": \u{20B9}${map["tot_paid1"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 5, top: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/money.png",
                              height: size.height * 0.02,
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            SizedBox(
                              width: size.width * 0.3,
                              child: Text(
                                "Balance Amount",
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                value.isSearch &&
                                        value.newadminbReportList.isNotEmpty
                                    ? ": \u{20B9}${value.newadminbReportList[index]["bal_amt"]}"
                                    : ": \u{20B9}${map["bal_amt"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 5, top: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/date.png",
                              height: size.height * 0.02,
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            SizedBox(
                              width: size.width * 0.3,
                              child: Text(
                                "Est. Completion Date",
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                value.isSearch &&
                                        value.newadminbReportList.isNotEmpty
                                    ? ": \u{20B9}${value.newadminbReportList[index]["est_comp_date"]}"
                                    : ": ${map["est_comp_date"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, top: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/expenses.png",
                              height: size.height * 0.02,
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            SizedBox(
                              width: size.width * 0.3,
                              child: Text(
                                "Total Expense",
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                value.isSearch &&
                                        value.newadminbReportList.isNotEmpty
                                    ? ": \u{20B9}${value.newadminbReportList[index]["tot_exp1"]}"
                                    : ": \u{20B9}${map["tot_exp1"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),

                      value.isSearch && value.newadminbReportList.isNotEmpty
                          ? value.newadminbReportList[index]["flag"] != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/status.png",
                                            height: size.height * 0.02,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.01,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "Pay Status",
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(": "),
                                      value.newadminbReportList[index]
                                                  ["flag"] !=
                                              null
                                          ? value.newadminbReportList[index]
                                                          ["flag"] ==
                                                      "1" ||
                                                  value.newadminbReportList[
                                                          index]["flag"] ==
                                                      "2"
                                              ? Container(
                                                  // width: size.width * 0.2,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.green),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "In Progress",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  width: size.width * 0.2,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.red),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Pending",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  ))
                                          : Container()
                                    ],
                                  ),
                                )
                              : Container()
                          :
                          ///////////////////////////////////////
                          map["flag"] != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/status.png",
                                            height: size.height * 0.02,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.01,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: Text(
                                              "Pay Status",
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(": "),
                                      map["flag"] != null
                                          ? map["flag"] == "1" ||
                                                  map["flag"] == "2"
                                              ? Container(
                                                  // width: size.width * 0.2,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.green),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "In Progress",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  width: size.width * 0.2,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.red),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Pending",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  ))
                                          : Container()
                                    ],
                                  ),
                                )
                              : Container(),
                      SizedBox(
                        height: size.height * 0.01,
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  // // Widget customCard(Map<String, dynamic> map, int index) {
  // //   return Consumer<Controller>(
  // //     builder: (context, value, child) => ExpansionTile(
  // //       initiallyExpanded: index == selectedTile,
  // //       onExpansionChanged: (val) {
  // //         if (val)
  // //           setState(() {
  // //             selectedTile = index;
  // //           });
  // //         else
  // //           setState(() {
  // //             selectedTile = -1;
  // //           });
  // //         print("val ----$val");
  // //         if (val == true) {
  // //           Provider.of<Controller>(context, listen: false)
  // //               .adminReportDetails(context, map["pod_a_id"], index);
  // //         }
  // //       },
  // //       title: Text(map["po_con_no"]),
  // //       children: [
  // //         TableData(index: index),
  // //       ],
  // //     ),
  // //   );
  // // }
  Future<bool> _onBackPressed(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to exit from this app'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }
}
