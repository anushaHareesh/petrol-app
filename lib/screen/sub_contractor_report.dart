import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:petrol/controller/registration_controller.dart';
import 'package:petrol/screen/login.dart';
import 'package:petrol/screen/search/itemSearch.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/controller.dart';

class SubContractorReport extends StatefulWidget {
  const SubContractorReport({super.key});

  @override
  State<SubContractorReport> createState() => _SubContractorReportState();
}

class _SubContractorReportState extends State<SubContractorReport> {
  TextEditingController controller = TextEditingController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  // void _onRefresh() async {
  //   await Future.delayed(const Duration(milliseconds: 1000));
  //   // ignore: use_build_context_synchronously
  //   Provider.of<Controller>(context, listen: false)
  //       .adminReportData(context, '');
  //   _refreshController.refreshCompleted();
  // }

  @override
  void initState() {
    super.initState();
    Provider.of<Controller>(context, listen: false).subContractorReport(
      context,
    );
    Provider.of<RegistrationController>(context, listen: false).getUserData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Consumer<RegistrationController>(
            builder: (context, value, child) => Row(
              children: [
                Image.asset(
                  "assets/man2.png",
                  height: size.height * 0.036,
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                value.name == null
                    ? const SpinKitChasingDots(
                        size: 12,
                        color: Colors.white,
                      )
                    : Flexible(
                        child: Text(
                          value.name.toString().toUpperCase(),
                          // 'anush ah vayakalail house thottada kannurfffxx dggggg hhhhh kkkk llll ',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      )
              ],
            ),
          ),
          // leading: Consumer<RegistrationController>(
          //   builder: (context, value, child) =>Text(value.name.toString())
          //   //  Row(
          //   //   children: [
          //   //     // Image.asset(
          //   //     //   "assets/man2.png",
          //   //     //   height: size.height * 0.036,
          //   //     // ),
          //   //     Text(value.name.toString())
          //   //   ],
          //   // ),
          // ),
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            PopupMenuButton(
                icon: const Icon(Icons.more_vert,
                    color: Colors.white), // add this line
                itemBuilder: (_) => <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                          child: Container(
                              width: 100,
                              // height: 30,
                              child: Text(
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
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Consumer<Controller>(
          builder: (context, value, child) => Column(
            children: [
              Container(
                height: size.height * 0.09,
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        value.searchPdSupplier.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen(
                                    cType: "1",
                                  )),
                        );
                      },
                      child: Container(
                          width: size.width * 0.43,
                          height: size.height * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Item Search",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: size.width * 0.012,
                              ),
                              Image.asset(
                                "assets/search.png",
                                height: size.height * 0.023,
                              )
                              // Icon(
                              //   Icons.search,
                              //   color: Colors.white,
                              // )
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        value.searchPdSupplier.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen(
                                    cType: "2",
                                  )),
                        );
                      },
                      child: Container(
                          width: size.width * 0.43,
                          height: size.height * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Supplier Search",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: size.width * 0.012,
                              ),

                              Image.asset(
                                "assets/search.png",
                                height: size.height * 0.023,
                              )
                              // Icon(
                              //   Icons.search,
                              //   color: Colors.white,
                              // )
                            ],
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        value.setIssearch(false);
                        controller.clear();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
                    hintText: "Search with Pa no: or contractor name",
                    fillColor: Colors.white70,
                  ),
                  onChanged: (val) {
                    // print("vaaaaa----$val");
                    Provider.of<Controller>(context, listen: false)
                        .subConReportSearchHistory(context, val);
                  },
                ),
              ),
              // new Container(
              //   // color: Theme.of(context).primaryColor,
              //   child: new Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: new Card(
              //       shape: RoundedRectangleBorder(
              //         side: BorderSide(color: Colors.grey, width: 1),
              //         borderRadius: BorderRadius.circular(20.0),
              //       ),
              //       child: new ListTile(
              //         leading: new Icon(Icons.search),
              //         title: new TextField(
              //           controller: controller,
              //           decoration: new InputDecoration(
              //               hintText: 'Search ', border: InputBorder.none),
              //           onChanged: (val) {
              //             print("vaaaaa----$val");
              //             Provider.of<Controller>(context, listen: false)
              //                 .subConReportSearchHistory(context, val);
              //           },
              //         ),
              //         trailing: new IconButton(
              //           icon: new Icon(Icons.cancel),
              //           onPressed: () {
              //             value.setIssearch(false);
              //             controller.clear();
              //           },
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: size.height * 0.01,
              ),
              value.isReportLoading
                  ? SpinKitCircle(
                      color: Theme.of(context).primaryColor,
                    )
                  : value.issearching
                      ? SpinKitCircle(
                          color: Theme.of(context).primaryColor,
                        )
                      : value.isSearch && value.newSubReportList.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 14, left: 13),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                          : value.sub_contractor_report.length == 0
                              ? SizedBox(
                                  height: size.height * 0.65,
                                  child: Center(
                                    child: LottieBuilder.asset(
                                      "assets/noData.json",
                                      height: size.height * 0.2,
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                      itemCount: value.isSearch &&
                                              value.newSubReportList.isNotEmpty
                                          ? value.newSubReportList.length
                                          : value.sub_contractor_report.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, right: 4),
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              // side: BorderSide(color: Colors.white70, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: size.height * 0.06,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red[400],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                                              topRight: Radius
                                                                  .circular(
                                                                      15))),
                                                  child: Center(
                                                      child: Text(
                                                    value.isSearch &&
                                                            value
                                                                .newSubReportList
                                                                .isNotEmpty
                                                        ? value.newSubReportList[
                                                            index]["pa_no"]
                                                        : value.sub_contractor_report[
                                                            index]["pa_no"],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 17),
                                                  )),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 8,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/man.png",
                                                            height:
                                                                size.height *
                                                                    0.016,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.3,
                                                            child: Text(
                                                              "Contractor",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          value.isSearch &&
                                                                  value
                                                                      .newSubReportList
                                                                      .isNotEmpty
                                                              ? ": ${value.newSubReportList[index]["c_name"]}"
                                                              : ": ${value.sub_contractor_report[index]["c_name"]}",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 3,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/date.png",
                                                            height:
                                                                size.height *
                                                                    0.016,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.3,
                                                            child: Text(
                                                              "Start Date",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          value.isSearch &&
                                                                  value
                                                                      .newSubReportList
                                                                      .isNotEmpty
                                                              ? ": ${value.newSubReportList[index]["strt_date"]}"
                                                              : ": ${value.sub_contractor_report[index]["strt_date"]}",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 3,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/date.png",
                                                            height:
                                                                size.height *
                                                                    0.016,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.3,
                                                            child: Text(
                                                              "Completion Date",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          value.isSearch &&
                                                                  value
                                                                      .newSubReportList
                                                                      .isNotEmpty
                                                              ? ": ${value.newSubReportList[index]["cmpltn_dt"]}"
                                                              : ": ${value.sub_contractor_report[index]["cmpltn_dt"]}",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 3,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/notes.png",
                                                            height:
                                                                size.height *
                                                                    0.016,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.3,
                                                            child: Text(
                                                              "Decription",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          value.isSearch &&
                                                                  value
                                                                      .newSubReportList
                                                                      .isNotEmpty
                                                              ? ": ${value.newSubReportList[index]["descrpt"]}"
                                                              : ": ${value.sub_contractor_report[index]["descrpt"]}",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 3,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/money.png",
                                                            height:
                                                                size.height *
                                                                    0.016,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.3,
                                                            child: Text(
                                                              "Est. Cost : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          value.isSearch &&
                                                                  value
                                                                      .newSubReportList
                                                                      .isNotEmpty
                                                              ? ": \u{20B9}${value.newSubReportList[index]["est_cost"]}"
                                                              : ": \u{20B9}${value.sub_contractor_report[index]["est_cost"]}",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 3,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/money.png",
                                                            height:
                                                                size.height *
                                                                    0.016,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.3,
                                                            child: Text(
                                                              "Paid",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          value.isSearch &&
                                                                  value
                                                                      .newSubReportList
                                                                      .isNotEmpty
                                                              ? ": \u{20B9}${value.newSubReportList[index]["con_paid"]}"
                                                              : ": \u{20B9}${value.sub_contractor_report[index]["con_paid"]}",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 3,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/money.png",
                                                            height:
                                                                size.height *
                                                                    0.016,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.3,
                                                            child: Text(
                                                              "Paid To Labour",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          value.isSearch &&
                                                                  value
                                                                      .newSubReportList
                                                                      .isNotEmpty
                                                              ? ": \u{20B9}${value.newSubReportList[index]["lab_paid"]}"
                                                              : ": \u{20B9}${value.sub_contractor_report[index]["lab_paid"]}",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 3,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/money.png",
                                                            height:
                                                                size.height *
                                                                    0.016,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.3,
                                                            child: Text(
                                                              "Paid Total",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          value.isSearch &&
                                                                  value
                                                                      .newSubReportList
                                                                      .isNotEmpty
                                                              ? ": \u{20B9}${value.newSubReportList[index]["tot_paid"]}"
                                                              : ": \u{20B9}${value.sub_contractor_report[index]["tot_paid"]}",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 3,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/money.png",
                                                            height:
                                                                size.height *
                                                                    0.016,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.01,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.3,
                                                            child: Text(
                                                              "Supplier Paid",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          value.isSearch &&
                                                                  value
                                                                      .newSubReportList
                                                                      .isNotEmpty
                                                              ? ": \u{20B9}${value.newSubReportList[index]["sup_paid"]}"
                                                              : ": \u{20B9}${value.sub_contractor_report[index]["sup_paid"]}",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                        // return Card(
                                        //     elevation: 4,
                                        //     child: ExpansionTile(
                                        //       title: Text(
                                        //         value.isSearch &&
                                        //                 value.newSubReportList.length > 0
                                        //             ? value.newSubReportList[index]
                                        //                 ["pa_no"]
                                        //             : value.sub_contractor_report[index]
                                        //                 ["pa_no"],
                                        //         style: TextStyle(
                                        //             fontSize: 15,
                                        //             fontWeight: FontWeight.bold),
                                        //       ),
                                        //       children: [
                                        //         Padding(
                                        //           padding: const EdgeInsets.only(
                                        //               left: 8.0, right: 8),
                                        //           child: Row(
                                        //             children: [
                                        //               Container(
                                        //                 width: size.width * 0.3,
                                        //                 child: Text(
                                        //                   "Start Date",
                                        //                   style: TextStyle(
                                        //                       color: Colors.grey),
                                        //                 ),
                                        //               ),
                                        //               Flexible(
                                        //                 child: Text(
                                        //                   value.isSearch &&
                                        //                           value.newSubReportList
                                        //                                   .length >
                                        //                               0
                                        //                       ? ": ${value.newSubReportList[index]["strt_date"]}"
                                        //                       : ": ${value.sub_contractor_report[index]["strt_date"]}",
                                        //                   style: TextStyle(fontSize: 15),
                                        //                 ),
                                        //               )
                                        //             ],
                                        //           ),
                                        //         ),
                                        //         SizedBox(
                                        //           height: size.height * 0.004,
                                        //         ),
                                        //         Padding(
                                        //           padding: const EdgeInsets.only(
                                        //               left: 8.0, right: 8),
                                        //           child: Row(
                                        //             children: [
                                        //               Container(
                                        //                 width: size.width * 0.3,
                                        //                 child: Text(
                                        //                   "Completion Date",
                                        //                   style: TextStyle(
                                        //                       color: Colors.grey),
                                        //                 ),
                                        //               ),
                                        //               Flexible(
                                        //                 child: Text(
                                        //                   value.isSearch &&
                                        //                           value.newSubReportList
                                        //                                   .length >
                                        //                               0
                                        //                       ? ": ${value.newSubReportList[index]["cmpltn_dt"]}"
                                        //                       : ": ${value.sub_contractor_report[index]["cmpltn_dt"]}",
                                        //                   style: TextStyle(fontSize: 15),
                                        //                 ),
                                        //               )
                                        //             ],
                                        //           ),
                                        //         ),
                                        //         SizedBox(
                                        //           height: size.height * 0.004,
                                        //         ),
                                        //         Padding(
                                        //           padding: const EdgeInsets.only(
                                        //               left: 8.0, right: 8),
                                        //           child: Row(
                                        //             children: [
                                        //               Container(
                                        //                 width: size.width * 0.3,
                                        //                 child: Text(
                                        //                   "Decription",
                                        //                   style: TextStyle(
                                        //                       color: Colors.grey),
                                        //                 ),
                                        //               ),
                                        //               Flexible(
                                        //                 child: Text(
                                        //                   value.isSearch &&
                                        //                           value.newSubReportList
                                        //                                   .length >
                                        //                               0
                                        //                       ? ": ${value.newSubReportList[index]["descrpt"]}"
                                        //                       : ": ${value.sub_contractor_report[index]["descrpt"]}",
                                        //                   style: TextStyle(fontSize: 15),
                                        //                 ),
                                        //               )
                                        //             ],
                                        //           ),
                                        //         ),
                                        //         Divider(),
                                        //         Padding(
                                        //           padding: const EdgeInsets.only(
                                        //               left: 8.0, right: 8),
                                        //           child: Row(
                                        //             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //             children: [
                                        //               Expanded(
                                        //                 child: Row(
                                        //                   children: [
                                        //                     Text(
                                        //                       "Est. Cost : ",
                                        //                       style: TextStyle(
                                        //                           color: Colors.grey[500],
                                        //                           fontWeight:
                                        //                               FontWeight.bold),
                                        //                     ),
                                        //                     Flexible(
                                        //                       child: Text(
                                        //                         value.isSearch &&
                                        //                                 value.newSubReportList
                                        //                                         .length >
                                        //                                     0
                                        //                             ? "\u{20B9}${value.newSubReportList[index]["est_cost"]}"
                                        //                             : "\u{20B9}${value.sub_contractor_report[index]["est_cost"]}",
                                        //                         style: TextStyle(
                                        //                             color: Colors.red,
                                        //                             fontWeight:
                                        //                                 FontWeight.bold),
                                        //                       ),
                                        //                     )
                                        //                   ],
                                        //                 ),
                                        //               ),
                                        //               // Spacer(),
                                        //               Expanded(
                                        //                 child: Row(
                                        //                   mainAxisAlignment:
                                        //                       MainAxisAlignment.end,
                                        //                   children: [
                                        //                     Text(
                                        //                       "Total : ",
                                        //                       style: TextStyle(
                                        //                           color: Colors.grey[500],
                                        //                           fontWeight:
                                        //                               FontWeight.bold),
                                        //                     ),
                                        //                     Flexible(
                                        //                       child: Text(
                                        //                         value.isSearch &&
                                        //                                 value.newSubReportList
                                        //                                         .length >
                                        //                                     0
                                        //                             ? "\u{20B9}${value.newSubReportList[index]["tot_paid"]}"
                                        //                             : "\u{20B9}${value.sub_contractor_report[index]["tot_paid"]}",
                                        //                         style: TextStyle(
                                        //                             color: Colors.red,
                                        //                             fontWeight:
                                        //                                 FontWeight.bold),
                                        //                       ),
                                        //                     )
                                        //                   ],
                                        //                 ),
                                        //               )
                                        //             ],
                                        //           ),
                                        //         ),
                                        //         SizedBox(
                                        //           height: size.height * 0.004,
                                        //         ),
                                        //       ],
                                        //     ));
                                      }),
                                ),
            ],
          ),
        ),
        // body: List,
      ),
    );
  }

  // Widget customCard(Map<String, dynamic> map, int index, Size size) {
  //   // print("jcjcz-----$map");
  //   return Card(
  //                                 elevation: 4,
  //                                 child: ExpansionTile(
  //                                   title: Text(
  //                                     value.isSearch &&
  //                                             value.newSubReportList.length > 0
  //                                         ? value.newSubReportList[index]
  //                                             ["pa_no"]
  //                                         : value.sub_contractor_report[index]
  //                                             ["pa_no"],
  //                                     style: TextStyle(
  //                                         fontSize: 15,
  //                                         fontWeight: FontWeight.bold),
  //                                   ),
  //                                   children: [
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(
  //                                           left: 8.0, right: 8),
  //                                       child: Row(
  //                                         children: [
  //                                           Container(
  //                                             width: size.width * 0.3,
  //                                             child: Text(
  //                                               "Start Date",
  //                                               style: TextStyle(
  //                                                   color: Colors.grey),
  //                                             ),
  //                                           ),
  //                                           Flexible(
  //                                             child: Text(
  //                                               value.isSearch &&
  //                                                       value.newSubReportList
  //                                                               .length >
  //                                                           0
  //                                                   ? ": ${value.newSubReportList[index]["strt_date"]}"
  //                                                   : ": ${value.sub_contractor_report[index]["strt_date"]}",
  //                                               style: TextStyle(fontSize: 15),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       height: size.height * 0.004,
  //                                     ),
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(
  //                                           left: 8.0, right: 8),
  //                                       child: Row(
  //                                         children: [
  //                                           Container(
  //                                             width: size.width * 0.3,
  //                                             child: Text(
  //                                               "Completion Date",
  //                                               style: TextStyle(
  //                                                   color: Colors.grey),
  //                                             ),
  //                                           ),
  //                                           Flexible(
  //                                             child: Text(
  //                                               value.isSearch &&
  //                                                       value.newSubReportList
  //                                                               .length >
  //                                                           0
  //                                                   ? ": ${value.newSubReportList[index]["cmpltn_dt"]}"
  //                                                   : ": ${value.sub_contractor_report[index]["cmpltn_dt"]}",
  //                                               style: TextStyle(fontSize: 15),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       height: size.height * 0.004,
  //                                     ),
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(
  //                                           left: 8.0, right: 8),
  //                                       child: Row(
  //                                         children: [
  //                                           Container(
  //                                             width: size.width * 0.3,
  //                                             child: Text(
  //                                               "Decription",
  //                                               style: TextStyle(
  //                                                   color: Colors.grey),
  //                                             ),
  //                                           ),
  //                                           Flexible(
  //                                             child: Text(
  //                                               value.isSearch &&
  //                                                       value.newSubReportList
  //                                                               .length >
  //                                                           0
  //                                                   ? ": ${value.newSubReportList[index]["descrpt"]}"
  //                                                   : ": ${value.sub_contractor_report[index]["descrpt"]}",
  //                                               style: TextStyle(fontSize: 15),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     Divider(),
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(
  //                                           left: 8.0, right: 8),
  //                                       child: Row(
  //                                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Expanded(
  //                                             child: Row(
  //                                               children: [
  //                                                 Text(
  //                                                   "Est. Cost : ",
  //                                                   style: TextStyle(
  //                                                       color: Colors.grey[500],
  //                                                       fontWeight:
  //                                                           FontWeight.bold),
  //                                                 ),
  //                                                 Flexible(
  //                                                   child: Text(
  //                                                     value.isSearch &&
  //                                                             value.newSubReportList
  //                                                                     .length >
  //                                                                 0
  //                                                         ? "\u{20B9}${value.newSubReportList[index]["est_cost"]}"
  //                                                         : "\u{20B9}${value.sub_contractor_report[index]["est_cost"]}",
  //                                                     style: TextStyle(
  //                                                         color: Colors.red,
  //                                                         fontWeight:
  //                                                             FontWeight.bold),
  //                                                   ),
  //                                                 )
  //                                               ],
  //                                             ),
  //                                           ),
  //                                           // Spacer(),
  //                                           Expanded(
  //                                             child: Row(
  //                                               mainAxisAlignment:
  //                                                   MainAxisAlignment.end,
  //                                               children: [
  //                                                 Text(
  //                                                   "Total : ",
  //                                                   style: TextStyle(
  //                                                       color: Colors.grey[500],
  //                                                       fontWeight:
  //                                                           FontWeight.bold),
  //                                                 ),
  //                                                 Flexible(
  //                                                   child: Text(
  //                                                     value.isSearch &&
  //                                                             value.newSubReportList
  //                                                                     .length >
  //                                                                 0
  //                                                         ? "\u{20B9}${value.newSubReportList[index]["tot_paid"]}"
  //                                                         : "\u{20B9}${value.sub_contractor_report[index]["tot_paid"]}",
  //                                                     style: TextStyle(
  //                                                         color: Colors.red,
  //                                                         fontWeight:
  //                                                             FontWeight.bold),
  //                                                   ),
  //                                                 )
  //                                               ],
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       height: size.height * 0.004,
  //                                     ),
  //                                   ],
  //                                 ));
  // }

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
