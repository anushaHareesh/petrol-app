import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:petrol/screen/search/supplier_info_table.dart';
import 'package:provider/provider.dart';

import '../../bottomSheet/search_data_sheet.dart';
import '../../controller/controller.dart';

class SearchScreen extends StatefulWidget {
  String cType;
  SearchScreen({super.key, required this.cType});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.cType == "1" ? "Item Search" : "Supplier Search"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.11,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextField(
                    autofocus: true,
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: widget.cType == "1"
                            ? 'Search Item Here...'
                            : 'Search Supplier Here...',
                        border: InputBorder.none),
                    onChanged: (val) {
                      // print("vczczxc--$val");
                      Provider.of<Controller>(context, listen: false)
                          .searchPdctSupplier(context, widget.cType, val);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                      Provider.of<Controller>(context, listen: false)
                          .searchPdctSupplier(
                              context, widget.cType, controller.text);
                    },
                  ),
                ),
              ),
            ),
          ),
          // SizedBox(height: size.height * 0.01),

          Consumer<Controller>(
            builder: (context, value, child) =>
                widget.cType == "1" && value.searchPdSupplier.isEmpty ||
                        widget.cType == "2" && value.searchPdSupplier.isEmpty
                    ? LottieBuilder.asset("assets/searchLott.json",
                        height: size.height * 0.2)
                    : Expanded(
                        child: ListView.builder(
                        itemCount: value.searchPdSupplier.length,
                        itemBuilder: (context, index) {
                          if (widget.cType == "1") {
                            return itemSearchCard(index);
                          } else {
                            return supplierSearchCard(index);
                          }
                        },
                      )),
          )
        ],
      ),
    );
  }

  // Widget itemSearchCard(int index) {
  //   return Consumer<Controller>(
  //     builder: (context, value, child) => Card(
  //       elevation: 4,
  //       child: ExpansionTile(
  //         onExpansionChanged: (values) {
  //           print("values----$values");
  //           value.searchPdSupplierDetails.clear();

  //           if (values && value.boolExpansion[index] == false) {
  //             Provider.of<Controller>(context, listen: false)
  //                 .fetch_Suppl_prdct_data(context, widget.cType,
  //                     value.searchPdSupplier[index]["product_id"], index);
  //           }
  //         },
  //         // title:Text( "jzjsbcdjhzdc mnzbmdmdnmd, ,mnzm,ndm,ndm,fn dsdxdfxdfdfgv fsdfdf" ),
  //         title: Text(value.searchPdSupplier[index]["p_name"]),
  //         children: [
  //           value.supDetailLoading[index]
  //               ? SpinKitCircle(
  //                   color: Theme.of(context).primaryColor,
  //                 )
  //               : SupplierInfoTable()
  //         ],
  //       ),

  //     ),
  //   );
  // }
  Widget itemSearchCard(int index) {
    return Consumer<Controller>(
      builder: (context, value, child) => Card(
          elevation: 4,
          child: InkWell(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            value.searchPdSupplier[index]["p_name"],
                            // "djdskbdjk sjbjsbcz ckjsbffffffffffjk sjsjsjsjsjsjsjsjsjsjsjsjsjsjsjsj jhjhjhjhjhjhjh",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Provider.of<Controller>(context, listen: false)
                                .toggleExpansion(
                              index,
                            );
                            Provider.of<Controller>(context, listen: false)
                                .toggleData(
                              index,
                            );
                            Provider.of<Controller>(context, listen: false)
                                .fetch_Suppl_prdct_data(
                                    context,
                                    widget.cType,
                                    value.searchPdSupplier[index]["product_id"],
                                    index);
                          },
                          child: value.boolExpansion[index]
                              ? const Icon(
                                  Icons.arrow_drop_up,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.arrow_drop_down,
                                  // actionIcon.icon,
                                  size: 30,
                                ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  value.boolExpansion[index]
                      ? Visibility(
                          visible: value.boolExpansion[index],
                          child: value.supDetailLoading[index]
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      // height: 40,
                                      child: SpinKitCircle(
                                    color: Theme.of(context).primaryColor,
                                  )),
                                )
                              : SupplierInfoTable())
                      : Visibility(
                          visible: value.boolvisible[index],
                          // child:Text("haiii")

                          child: Container()),
                  // value.boolExpansion[index]
                  //     ? value.supDetailLoading[index]
                  //         ? SpinKitCircle(
                  //             color: Theme.of(context).primaryColor,
                  //           )
                  //         : SupplierInfoTable()
                  //     : Container()
                ],
              ),
            ),
          )),
    );
  }

  Widget supplierSearchCard(int index) {
    return Consumer<Controller>(
      builder: (context, value, child) => Card(
        elevation: 4,
        child: ListTile(
          onTap: () {
            Provider.of<Controller>(context, listen: false)
                .fetch_Suppl_prdct_data(context, widget.cType,
                    value.searchPdSupplier[index]["c_id"], index);
            SearchDataSheet search = SearchDataSheet();
            search.showSearchDataSheet(context, "2", index);
          },
          title: Text(
            value.searchPdSupplier[index]["c_name"],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 16),
            // "jfzhfnfzdn m ffkzndfjk gxdmgnjkzfjd gdkzjggd dszdzsdzsdszd"
          ),
          subtitle: Column(
            children: [
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 20,
                    child: Icon(
                      Icons.phone,
                      color: Colors.green,
                      size: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text("Ph 1 : "),
                      Text(
                        "${value.searchPdSupplier[index]["phone"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[600]),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 20,
                    child: Icon(
                      Icons.phone,
                      color: Colors.green,
                      size: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text("Ph 2 : "),
                      Text(
                        "${value.searchPdSupplier[index]["phone2"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[600]),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
