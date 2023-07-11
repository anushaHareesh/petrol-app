import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:petrol/screen/header_widget.dart';
import 'package:provider/provider.dart';
import '../components/external_dir.dart';
import '../controller/registration_controller.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String? manufacturer;
  String? model;
  final _formKey = GlobalKey<FormState>();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Map<String, dynamic> _deviceData = <String, dynamic>{};
  ExternalDir externalDir = ExternalDir();

  FocusNode? fieldFocusNode;
  TextEditingController codeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final double _headerHeight = 300;

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        manufacturer = deviceData["manufacturer"];
        model = deviceData["model"];
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'manufacturer': build.manufacturer,
      'model': build.model,
    };
  }

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Consumer<RegistrationController>(
          builder: (context, value, child) => Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: _headerHeight,
                  child: HeaderWidget(_headerHeight, true,
                      Icons.person), //let's create a common header widget
                ),
                SizedBox(height: size.height * 0.1),
                Text(
                  'Company Registration',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                // customTextField("Customer Code", custCode, "code", context),
                customTextField(
                    "Company key", codeController, "company key", context),
                customTextField(
                    "Phone number", phoneController, "phone", context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                InkWell(
                  onTap: () async {
                    String deviceInfo = "$manufacturer" + '' + "$model";
                    if (_formKey.currentState!.validate()) {
                      String tempFp1 = await externalDir.fileRead();
                      // ignore: use_build_context_synchronously
                      Provider.of<RegistrationController>(context,
                              listen: false)
                          .postRegistration(codeController.text, tempFp1,
                              phoneController.text, deviceInfo, context);
                    }
                  },
                  child: Container(
                    // alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 1.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: const Alignment(-0.95, 0.0),
                        end: const Alignment(1.0, 0.0),
                        colors: [
                          Theme.of(context).primaryColor,
                          const Color(0xff64b6ff)
                        ],
                        stops: [0.0, 1.0],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "REGISTER",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          value.isLoading
                              ? const SpinKitCircle(
                                  size: 18,
                                  color: Colors.white,
                                )
                              : const ImageIcon(
                                  AssetImage("assets/ic_forward.png"),
                                  size: 30,
                                  color: Colors.white,
                                ),
                        ],
                      ),
                    ),
                    // padding: EdgeInsets.only(top: 16, bottom: 16),
                  ),
                ),
                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget customTextField(String hinttext, TextEditingController controllerValue,
    String type, BuildContext context) {
  double topInsets = MediaQuery.of(context).viewInsets.top;
  Size size = MediaQuery.of(context).size;
  return SizedBox(
    // height: size.height * 0.1,
    child: Padding(
      padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
      child: TextFormField(
        keyboardType: type == "phone" ? TextInputType.number : null,
        scrollPadding: EdgeInsets.only(bottom: topInsets + size.height * 0.18),
        controller: controllerValue,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            prefixIcon: type == "company key"
                ? Icon(
                    Icons.business,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(
                    Icons.phone,
                    color: Theme.of(context).primaryColor,
                  ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(25.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(
                width: 1,
                color: Colors.red,
              ),
            ),
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.red,
                )),
            hintStyle: const TextStyle(
              fontSize: 15,
              // color: P_Settings.loginPagetheme,
            ),
            hintText: hinttext.toString()),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please Enter $hinttext';
          } else if (type == "phone" && text.length != 10) {
            return 'Please Enter Valid Phone No ';
          }
          return null;
        },
      ),
    ),
  );
}
