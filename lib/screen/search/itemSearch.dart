import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(elevation: 0,
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
                child:  ListTile(
                  leading:  const Icon(Icons.search),
                  title:  TextField(
                    autofocus: true,
                    controller: controller,
                    decoration:  InputDecoration(
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
            builder: (context, value, child) => widget.cType == "1" &&
                        value.searchPdSupplier.isEmpty ||
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

  Widget itemSearchCard(int index) {
    return Consumer<Controller>(
      builder: (context, value, child) => Card(
        elevation: 4,
        child: ListTile(
          onTap: () {
            Provider.of<Controller>(context, listen: false)
                .fetch_Suppl_prdct_data(context, widget.cType,
                    value.searchPdSupplier[index]["product_id"]);
          },
          title: Text(
            value.searchPdSupplier[index]["p_name"],
            // "jfzhfnfzdn m ffkzndfjk gxdmgnjkzfjd gdkzjggd dszdzsdzsdszd"
          ),
        ),
      ),
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
                    value.searchPdSupplier[index]["c_id"]);
          },
          title: Text(
            value.searchPdSupplier[index]["c_name"],
            // "jfzhfnfzdn m ffkzndfjk gxdmgnjkzfjd gdkzjggd dszdzsdzsdszd"
          ),
        ),
      ),
    );
  }
}
