import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:petrol/controller/registration_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'header_widget.dart';

ValueNotifier<bool> _isObscure = ValueNotifier(true);
TextEditingController usernmae = TextEditingController();
TextEditingController custCode = TextEditingController();
TextEditingController pass = TextEditingController();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final double _headerHeight = 300;

  @override
  Widget build(BuildContext context) {
    usernmae.clear();
    custCode.clear();
    pass.clear();
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
                  'Login into your account',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                // customTextField("Customer Code", custCode, "code", context),
                customTextField("User Name", usernmae, "user", context),
                customTextField("Password", pass, "password", context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? userType = prefs.getString("user_type");
                    // print("user_type------$userType");
                    if (_formKey.currentState!.validate()) {
                      // ignore: use_build_context_synchronously
                      Provider.of<RegistrationController>(context,
                              listen: false)
                          .getLogin(usernmae.text, pass.text,
                              userType.toString(), context);
                      // usernmae.clear();
                      // custCode.clear();
                      // pass.clear();
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
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          value.isLoginLoading
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
      child: ValueListenableBuilder(
        valueListenable: _isObscure,
        builder: (context, value, child) {
          return TextFormField(
            // style: TextStyle(color: P_Settings.loginPagetheme),
            // textCapitalization: TextCapitalization.characters,
            // keyboardType: type == "phone" ? TextInputType.number : null,
            scrollPadding:
                EdgeInsets.only(bottom: topInsets + size.height * 0.18),
            obscureText: type == "password" ? _isObscure.value : false,

            controller: controllerValue,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                suffixIcon: type == "password"
                    ? IconButton(
                        icon: Icon(
                          _isObscure.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          _isObscure.value = !_isObscure.value;
                          // print("_isObscure $_isObscure");
                        },
                      )
                    : null,
                prefixIcon: type == "user"
                    ? Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      )
                    : Icon(
                        Icons.password,
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
                return 'Please Enter ${hinttext}';
              }
              return null;
            },
          );
        },
      ),
    ),
  );
}

Future<bool> _onBackPressed(BuildContext context) async {
  return await showDialog(context: context, builder: (context) => exit(0));
}
