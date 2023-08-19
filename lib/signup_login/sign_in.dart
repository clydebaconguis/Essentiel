import 'dart:convert';
import 'package:essentiel/pages/diocese/dashboard.dart';
import 'package:essentiel/util/app_util.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:essentiel/api/my_api.dart';
import 'package:essentiel/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

const snackBar2 = SnackBar(
  content: Text('Fill all fields!'),
);

class _SignInState extends State<SignIn> {
  var loggedIn = false;
  var schoolcolor = 0;
  var schoollogo = '';
  var schoolname = '';
  var schoolabbv = '';
  var schooladdress = '';
  bool isValid = false;
  bool isVisible = true;
  bool isButtonEnabled = true;
  var host = CallApi().getImage();
  late SharedPreferences localStorage;
  TextEditingController textController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  _navigateToHome() {
    EasyLoading.dismiss();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
        (Route<dynamic> route) => false);
  }

  _login() async {
    EasyLoading.show(status: 'loading...');
    try {
      var res = await CallApi().login(
          emailController.text.toString(), textController.text.toString());
      var body = res != null ? json.decode(res.body) : '';
      var studInfo = body['stud']['id'] ?? 0;

      if (studInfo > 0) {
        localStorage.setString('user', json.encode(body['stud']));
        localStorage.setString('studid', json.encode(body['stud']['id']));
        localStorage.setInt('schoolcolor', schoolcolor);
        localStorage.setString('schoollogo', schoollogo);
        localStorage.setString('schoolname', schoolname);
        localStorage.setString('schoolabbv', schoolabbv);
        EasyLoading.showSuccess('Successfully logged in!');
        _navigateToHome();
      } else {
        // _showMsg(body['message']);
        EasyLoading.showError('Failed to Login');
        EasyLoading.dismiss();
      }
    } catch (e) {
      // print('Error during login: $e');
      EasyLoading.showError('Failed to Login');
    } finally {
      EasyLoading.dismiss();
    }
    if (mounted) {
      setState(() {
        isButtonEnabled = true;
      });
    }
  }

  getSchoolInfo() async {
    localStorage = await SharedPreferences.getInstance();
    var res = await CallApi().getSchoolInfo();
    var body = json.decode(res.body);
    // print(body);
    if (body[0]['schoolid'] != null) {
      if (mounted) {
        setState(() {
          schoolcolor = AppUtil().hexToColor(body[0]['schoolcolor']);
          schoollogo = body[0]['picurl'] ?? '';
          schoolabbv = body[0]['abbreviation'] ?? '';
          schoolname = body[0]['schoolname'] ?? '';
          schooladdress = body[0]['address'] ?? '';
          if (kIsWeb) {
            AppUtil().changeStatusBarColor(schoolcolor);
          }
        });
      }
      final response = await http.head(Uri.parse('$host$schoollogo'));
      if (mounted) {
        setState(() {
          isValid = response.statusCode == 200;
        });
      }
    }
  }

  @override
  void initState() {
    getSchoolInfo();
    super.initState();
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87),
          ),
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              TextField(
                controller:
                    title == "Username" ? emailController : textController,
                obscureText: title == "Password" ? isVisible : false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                ),
              ),
              if (title == "Password")
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: isButtonEnabled
          ? () {
              if (textController.text.isEmpty || emailController.text.isEmpty) {
                EasyLoading.showToast(
                  'Fill all fields!',
                  toastPosition: EasyLoadingToastPosition.bottom,
                );
              } else {
                setState(() {
                  isButtonEnabled = false;
                });
                _login();
              }
            }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: isButtonEnabled
                ? Color(schoolcolor)
                : const Color.fromARGB(255, 209, 208, 208)),
        child: Text(
          'Login',
          style: GoogleFonts.poppins(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Determine whether the layout width is wider than a threshold (e.g., 600)
            bool isWideScreen = constraints.maxWidth > 700;
            return Container(
              constraints: BoxConstraints(
                maxHeight: isWideScreen ? 700 : double.infinity,
                maxWidth: 500,
              ), // Set max width for larger screens
              decoration: isWideScreen
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          offset: const Offset(0.0, 0.0),
                          blurRadius: isWideScreen ? 25 : 15.0,
                          spreadRadius: isWideScreen ? 10 : 4.0,
                        )
                      ],
                    )
                  : null,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    schoollogo.isNotEmpty
                        ? CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFFD5F6FF),
                              backgroundImage: NetworkImage('$host$schoollogo'),
                              radius: 60,
                            ),
                          )
                        : const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: CircularProgressIndicator(),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      schoolname,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: Color(schoolcolor),
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      schooladdress,
                      style: GoogleFonts.prompt(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    _emailPasswordWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        child: Text('Forgot Password ?',
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        onTap: () {
                          EasyLoading.showInfo(
                              'Please inform the school authority or your teacher for further assistance.');
                        },
                      ),
                    ),
                    GestureDetector(
                      child: Text('School Admin',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const Dashboard(),
                            ),
                            (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
