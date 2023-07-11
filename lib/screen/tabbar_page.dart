import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/controller.dart';

class TabbarPage extends StatefulWidget {
  String id;
  TabbarPage({super.key, required this.id});

  @override
  State<TabbarPage> createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage> {
  Color? color;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (widget.id == "1") {
    //   color = Colors.green;
    // } else if (widget.id == "2") {
    //   color = Colors.red;
    // } else {
    //   color = Colors.yellow;
    // }
    Provider.of<Controller>(context, listen: false).getData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // backgroundColor: color,
      body: Column(      
        // mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox(
          //   height: 100.0,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     physics: ClampingScrollPhysics(),
          //     scrollDirection: Axis.horizontal,
          //     itemCount: 17,
          //     itemBuilder: (context, index) {
          //       return Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: CircleAvatar(),
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return customCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget customCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<Controller>(
        builder: (context, value, child) => Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
                aspectRatio: 1.4,
                child: DChartBar(
                  data: value.list,
                  minimumPaddingBetweenLabel: 2,
                  domainLabelPaddingToAxisLine: 16,
                  axisLineTick: 2,
                  axisLinePointTick: 2,
                  axisLinePointWidth: 10,
                  // axisLineColor: Theme.of(context).primaryColor,
                  measureLabelPaddingToAxisLine: 16,
                  // domainLabelRotation:
                  //     value.graphMap["barData"][0]["data"].length > 6 ? 45 : 0,
                  barColor: (barData, index, id) => id == 'Bar 1'
                      ? Colors.green.shade300
                      : Colors.green.shade900,
                )),
          ),
        ),
      ),
    );
  }
}
