import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petrol/screen/ad_report_screen.dart';
import 'package:provider/provider.dart';
import '../controller/controller.dart';

class AdminTableData extends StatefulWidget {
  @override
  State<AdminTableData> createState() => _AdminTableDataState();
}

class _AdminTableDataState extends State<AdminTableData> {
  List<dynamic> mapTabledata = [];
  List<String> tableColumn = [];
  List<dynamic> rowMap = [];
  double tot_billd_ioc = 0.0;
  double tot_paid_ioc = 0.0;
  double sup_billd = 0.0;
  double sup_paid = 0.0;
  double con_billd = 0.0;
  double con_paid = 0.0;
  double lab_paid = 0.0;
  double total = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // calculateSum(widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, value, child) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            showCheckboxColumn: false,
            columnSpacing: 20,
            // headingRowHeight: 39,
            // dataRowHeight: 42,
            headingTextStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
            dataTextStyle: TextStyle(color: Colors.grey[800]),
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.yellow),
            columns: const [
              DataColumn(label: Text('Po Number')),
              DataColumn(label: Text('Po Con Number')),
              DataColumn(label: Text('Po Date')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Est. Completion Date')),
              DataColumn(label: Text('Billed Value')),
              DataColumn(label: Text('Total Expense')),
              DataColumn(label: Text('Paid Amount')),
              DataColumn(label: Text('Balance Amt')),
              DataColumn(label: Text('Status')),
            ],
            rows: initRows(value.adminReport)),
      ),
    );
  }

  List<DataRow> initRows(List<Map<String, dynamic>> listmap) {
    List<DataRow> items = [];
    var itemList = listmap;
    for (var i = 0; i < itemList.length; i++) {
      double bal = double.parse(itemList[i]["po_amount"]) -
          double.parse(itemList[i]["tot_paid"]);
      items.add(DataRow(
        onSelectChanged: (selected) {
          // print("selected------$selected");
          if (selected!) {
            Provider.of<Controller>(context, listen: false).adminReportDetails(
              context,
              itemList[i]["pod_a_id"],
              i,
              itemList[i]["po_con_no"],
              itemList[i]["po_no"],
            );
            // if (Provider.of<Controller>(context, listen: false)
            //         .adminReportContents
            //         .length ==
            //     0) {
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     duration: Duration(seconds: 5),
            //     content: Text('No Data !!!!'),
            //   ));
            // } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdMInReportContentScreen(
                        index: i,
                        po_con_number: itemList[i]["po_con_no"],
                        po_no: itemList[i]["po_no"],
                      )),
            );
          }

          // if (MediaQuery.of(context).orientation == Orientation.portrait) {
          //   SystemChrome.setPreferredOrientations(
          //       [DeviceOrientation.landscapeRight]);
          // }
          //  else {
          //   SystemChrome.setPreferredOrientations(
          //       [DeviceOrientation.portraitUp]);
          // }
          // }
        },
        color: i % 2 == 0
            ? MaterialStateProperty.all(const Color.fromARGB(255, 188, 212, 240))
            : MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)),
        cells: <DataCell>[
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child: Text(itemList[i]["po_no"].toString(), style: const TextStyle()),
          )),
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child:
                Text(itemList[i]["po_con_no"].toString(), style: const TextStyle()),
          )),
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child: Text(itemList[i]["po_date"].toString(), style: const TextStyle()),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child:
                Text(itemList[i]["po_amount"].toString(), style: const TextStyle()),
          )),
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child: Text(itemList[i]["est_comp_date"].toString(),
                style: const TextStyle()),
          )),
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child:
                Text(itemList[i]["tot_billd"].toString(), style: const TextStyle()),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(itemList[i]["tot_exp"].toString(), style: const TextStyle()),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(itemList[i]["tot_paid"].toString(), style: const TextStyle()),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(bal.toStringAsFixed(2), style: const TextStyle()),
          )),
          DataCell(Align(
              alignment: Alignment.center,
              child: itemList[i]["flag"] != null
                  ? itemList[i]["flag"] == "1" || itemList[i]["flag"] == "2"
                      ? Container(
                          decoration: const BoxDecoration(color: Colors.green),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Paid",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(color: Colors.red),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Pending",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                  : Container())),
        ],
      ));
    }
    return items;
  }

  // List<DataRow> getRows(List<Map<String, dynamic>> listmap) {
  //   List<DataRow> list = listmap.map((element) {
  //     print("total----$total");
  //     return DataRow(
  //       // color: MaterialStateColor.resolveWith((states) {
  //       //   return listmap ? Colors.red : Colors.black; //make tha magic!
  //       // }),
  //       cells: <DataCell>[
  //         DataCell(Align(
  //           alignment: Alignment.centerLeft,
  //           child: Text(
  //             element["t_date"].toString(),
  //             textAlign: TextAlign.left,
  //           ),
  //         )),
  //         DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(
  //             element["tot_billd_ioc"].toString(),
  //             textAlign: TextAlign.right,
  //           ),
  //         )),
  //         DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(
  //             element["tot_paid_ioc"].toString(),
  //             textAlign: TextAlign.right,
  //           ),
  //         )),
  //         DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(
  //             element["sup_billd"].toString(),
  //             textAlign: TextAlign.right,
  //           ),
  //         )),
  //         DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(
  //             element["sup_paid"].toString(),
  //             textAlign: TextAlign.right,
  //           ),
  //         )),
  //         DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(
  //             element["con_billd"].toString(),
  //           ),
  //         )),
  //         DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(
  //             element["con_paid"].toString(),
  //           ),
  //         )),
  //         DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(
  //             element["lab_paid"].toString(),
  //           ),
  //         )),
  //         DataCell(Align(
  //           alignment: Alignment.centerRight,
  //           child: Text(
  //             element["total"].toString(),
  //           ),
  //         )),
  //       ],
  //     );
  //   }).toList();

  //   return list;
  // }
}
