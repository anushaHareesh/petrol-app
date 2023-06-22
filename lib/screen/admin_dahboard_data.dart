import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/table_data.dart';
import '../controller/controller.dart';

class AdminDashboardData extends StatefulWidget {
  const AdminDashboardData({super.key});

  @override
  State<AdminDashboardData> createState() => _AdminDashboardDataState();
}

class _AdminDashboardDataState extends State<AdminDashboardData> {
  int selectedTile = -1;
  @override
  void initState() {
    super.initState();
    Provider.of<Controller>(context, listen: false).adminReportData(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<Controller>(
        builder: (context, value, child) => ListView.builder(
          itemCount: value.adminReport.length,
          itemBuilder: (context, index) {
            return customCard(value.adminReport[index], index);
          },
        ),
      ),
    );
  }

  Widget customCard(Map<String, dynamic> map, int index) {
    return Consumer<Controller>(
      builder: (context, value, child) => ExpansionTile(
        initiallyExpanded: index == selectedTile,
        onExpansionChanged: (val) {
          if (val)
            setState(() {
              selectedTile = index;
            });
          else
            setState(() {
              selectedTile = -1;
            });
          print("val ----$val");
          if (val == true) {
            Provider.of<Controller>(context, listen: false)
                .adminReportDetails(context, map["pod_a_id"], index);
          }
        },
        title: Text(map["po_con_no"]),
        children: [
          TableData(index: index),
        ],
      ),
    );
  }
}
