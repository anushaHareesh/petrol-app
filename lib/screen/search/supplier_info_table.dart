import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../controller/controller.dart";

class SupplierInfoTable extends StatefulWidget {
  const SupplierInfoTable({super.key});

  @override
  State<SupplierInfoTable> createState() => _SupplierInfoTableState();
}

class _SupplierInfoTableState extends State<SupplierInfoTable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Consumer<Controller>(
        builder: (context, value, child) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            value.searchPdSupplierDetails.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const  [
                        Text(
                          "SUPPLIER LIST",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
            const  SizedBox(
              height: 10,
            ),
            value.searchPdSupplierDetails.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const  [
                    Text(
                        "No data !!!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  )
                : DataTable(
                    horizontalMargin: 13,
                    columnSpacing: 40,
                    headingRowHeight: 39,
                    dataRowHeight: 42,
                    headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    dataTextStyle: TextStyle(color: Colors.grey[800]),
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromARGB(255, 228, 226, 226)),
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Supplier',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Phone1',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Phone2',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows: initRows(value.searchPdSupplierDetails)),
          ],
        ),
      ),
    );
  }

  List<DataRow> initRows(List<Map<String, dynamic>> listmap) {
    List<DataRow> items = [];
    var itemList = listmap;
    for (var i = 0; i < itemList.length; i++) {
      items.add(DataRow(
        // color: i == itemList.length - 1
        //     ? MaterialStateProperty.all(Theme.of(context).primaryColor)
        //     : i % 2 == 0
        //         ? MaterialStateProperty.all(Color.fromARGB(255, 188, 212, 240))
        //         : MaterialStateProperty.all(Color.fromARGB(255, 255, 255, 255)),
        cells: <DataCell>[
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child: Text(itemList[i]["c_name"].toString(),
                style: TextStyle(color: Colors.grey[800])),
          )),
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: itemList[i]["address"] != null
                  ? itemList[i]["address"].length < 10
                      ? 50
                      : 120
                  : 50,
              child: Text(
                  // "Global vilage , kannur ,thottada",
                  itemList[i]["address"] == null
                      ? " "
                      : itemList[i]["address"].toString(),
                  style: TextStyle(color: Colors.grey[800])),
            ),
          )),
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child: Text(itemList[i]["phone"].toString(),
                style: TextStyle(color: Colors.grey[800])),
          )),
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child: Text(itemList[i]["phone2"].toString(),
                style: TextStyle(color: Colors.grey[800])),
          )),
        ],
      ));
    }
    return items;
  }
}
