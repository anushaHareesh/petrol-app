import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../controller/controller.dart';

class MultiApi extends StatefulWidget {
  const MultiApi({super.key});

  @override
  State<MultiApi> createState() => _MultiApiState();
}

class _MultiApiState extends State<MultiApi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Consumer<Controller>(
          builder: (context, value, child) => Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Provider.of<Controller>(context, listen: false)
                        .adminReportData(context, "");
                  },
                  child: const Text("send api")),
              value.isReportLoading
                  ? const SpinKitCircle(
                      color: Colors.black,
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.list.length,
                        itemBuilder: (context, index) => Card(
                          child: Text(value.list[index]["data"].toString()),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
