import 'package:flutter/material.dart';
import 'package:petrol/screen/tabbar_page.dart';
import 'package:provider/provider.dart';
import '../controller/controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> tabList = [
    {"id": "1", "val": "purchase"},
    {"id": "2", "val": "sales"},
    {"id": "3", "val": "stock"}
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DefaultTabController(
                    length: tabList.length, // length of tabs
                    initialIndex: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          // color: P_Settings.bodyTabColor,
                          child: TabBar(
                              isScrollable: true,
                              // physics: NeverScrollableScrollPhysics(),
                              labelColor: Colors.red,
                              indicatorWeight: 3,
                              indicatorColor: Colors.red,
                              unselectedLabelColor: Colors.black,
                              // labelPadding:
                              //     EdgeInsets.symmetric(horizontal: 12),
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                              tabs: tabList
                                  .map(
                                    (e) => Tab(
                                      text: e["val"].toString(),
                                    ),
                                  )
                                  .toList()),
                        ),
                        Container(
                          height: size.height * 0.85, //height of TabBarView
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                          child: TabBarView(
                            physics:const NeverScrollableScrollPhysics(),
                            children: tabList.map((e) {
                              return customContainer(e["id"]);
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  Widget customContainer(String e) {
    return Consumer<Controller>(
      builder: (context, value, child) {
        return TabbarPage(
          id: e,
          // tabId: e,
          // b_id: value.brId!,
        );
      },
    );
  }
}
