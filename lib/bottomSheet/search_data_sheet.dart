import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:petrol/controller/controller.dart';
import 'package:provider/provider.dart';

class SearchDataSheet {
  showSearchDataSheet(BuildContext context, String cType, int index) {
    Size size = MediaQuery.of(context).size;

    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            // <-- SEE HERE
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0)),
      ),
      builder: (BuildContext mycontext) {
        return Consumer<Controller>(builder: (context, value, child) {
          // value.qty[index].text=qty.toString();

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              size: 23,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cType == "1"
                              ? "Supplier List".toString().toUpperCase()
                              : "Product List".toString().toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const Divider(),
                    value.supDetailLoading[index]
                        ? SpinKitCircle(
                            color: Theme.of(context).primaryColor,
                          )
                        : value.searchPdSupplierDetails.isEmpty
                            ? Text(
                                "No data",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: value.searchPdSupplierDetails.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.02,
                                      ),
                                      Image.asset(
                                        "assets/right.png",
                                        height: size.height * 0.03,
                                        color: Colors.green,
                                      ),
                                      Flexible(
                                        child: Text(
                                          cType == "1"
                                              ? value.searchPdSupplierDetails[
                                                  index]["c_name"]
                                              : value.searchPdSupplierDetails[
                                                  index]["p_name"],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700]),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                    SizedBox(
                      height: size.height * 0.07,
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
