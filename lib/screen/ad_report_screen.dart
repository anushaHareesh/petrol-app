import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../controller/controller.dart';
import 'admin_deta_table.dart';

class AdMInReportContentScreen extends StatefulWidget {
  int index;
  String po_con_number;
  String po_no;
  AdMInReportContentScreen(
      {super.key,
      required this.index,
      required this.po_con_number,
      required this.po_no});

  @override
  State<AdMInReportContentScreen> createState() =>
      _AdMInReportContentScreenState();
}

class _AdMInReportContentScreenState extends State<AdMInReportContentScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Po Con No : ",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              widget.po_con_number.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        leading: IconButton(
            onPressed: () {
              // SystemChrome.setPreferredOrientations(
              //     [DeviceOrientation.portraitUp]);
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<Controller>(
        builder: (context, value, child) => value.iscontentLoading[widget.index]
            ? SpinKitCircle(
                color: Colors.black,
              )
            : SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Po No : ",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                              Text(
                                widget.po_no.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // Text("/"),

                              // Text("dsknsknzsf sznfkzfnzsf nsfknfk fksfnkf ")
                            ],
                          ),
                          // Text(
                          //   widget.po_con_number.toString(),
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //     decoration: TextDecoration.underline,
                          //     decorationColor: Colors.blue,
                          //   ),
                          // ),
                          Lottie.asset("assets/swipe.json", height: 53),
                        ],
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     // Text(
                    //     //   "Swipe Left",
                    //     //   style: TextStyle(
                    //     //       fontSize: 13,
                    //     //       fontStyle: FontStyle.italic,
                    //     //       color: Colors.red),
                    //     // ),
                    //     Lottie.asset("assets/swipe.json",height: 53)
                    //   ],
                    // ),

                    value.adminReportContents.length == 0
                        ? Container(
                            height: size.height * 0.67,
                            child: Center(
                                child: LottieBuilder.asset(
                              "assets/noData.json",
                              height: size.height * 0.2,
                            )))
                        : TableData(index: widget.index),
                  ],
                ),
              ),
      ),
    );
  }
}
