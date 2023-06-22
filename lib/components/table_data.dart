import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../controller/controller.dart';

class TableData extends StatefulWidget {
  int index;
  TableData({required this.index});

  // TableData({
  //   required this.list,
  // });

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
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
      builder: (context, value, child) => value.iscontentLoading[widget.index]
          ? SpinKitCircle(
              color: Colors.black,
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columnSpacing: 20,
                  headingRowHeight: 39,
                  dataRowHeight: 42,
                  headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  dataTextStyle: TextStyle(color: Colors.grey[800]),
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => Colors.yellow),
                  columns: [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('IOCL Billed')),
                    DataColumn(label: Text('IOCL Collected')),
                    DataColumn(label: Text('Supplier Billed')),
                    DataColumn(label: Text('Paid To Supplier')),
                    DataColumn(label: Text('Contractor Billed')),
                    DataColumn(label: Text('Paid To Contractor')),
                    DataColumn(label: Text('Labour Paid')),
                    DataColumn(label: Text('Total')),
                  ],
                  rows: initRows(value.adminReportTotal)),
            ),
    );
  }

  List<DataRow> initRows(List<Map<String, dynamic>> listmap) {
    List<DataRow> items = [];
    var itemList = listmap;
    for (var i = 0; i < itemList.length; i++) {
      items.add(DataRow(
        color: i == itemList.length - 1
            ? MaterialStateProperty.all(Theme.of(context).primaryColor)
            : i % 2 == 0
                ? MaterialStateProperty.all(Color.fromARGB(255, 245, 236, 236))
                : MaterialStateProperty.all(Colors.grey[100]),
        cells: <DataCell>[
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child: Text(
              itemList[i]["t_date"].toString(),
              style: TextStyle(
                  color: i == itemList.length - 1
                      ? Colors.white
                      : Colors.grey[800]),
            ),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(itemList[i]["tot_billd_ioc"].toString(),
                style: TextStyle(
                    color: i == itemList.length - 1
                        ? Colors.white
                        : Colors.grey[800])),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(itemList[i]["tot_paid_ioc"].toString(),
                style: TextStyle(
                    color: i == itemList.length - 1
                        ? Colors.white
                        : Colors.grey[800])),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(itemList[i]["sup_billd"].toString(),
                style: TextStyle(
                    color: i == itemList.length - 1
                        ? Colors.white
                        : Colors.grey[800])),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(itemList[i]["sup_paid"].toString(),
                style: TextStyle(
                    color: i == itemList.length - 1
                        ? Colors.white
                        : Colors.grey[800])),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(itemList[i]["con_billd"].toString(),
                style: TextStyle(
                    color: i == itemList.length - 1
                        ? Colors.white
                        : Colors.grey[800])),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(itemList[i]["con_paid"].toString(),
                style: TextStyle(
                    color: i == itemList.length - 1
                        ? Colors.white
                        : Colors.grey[800])),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(itemList[i]["lab_paid"].toString(),
                style: TextStyle(
                    color: i == itemList.length - 1
                        ? Colors.white
                        : Colors.grey[800])),
          )),
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(itemList[i]["total"].toString(),
                style: TextStyle(
                    color: i == itemList.length - 1
                        ? Colors.white
                        : Colors.grey[800])),
          )),
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
