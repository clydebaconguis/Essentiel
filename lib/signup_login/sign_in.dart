import 'dart:convert';
import 'package:essentiel/api/my_api.dart';
import 'package:essentiel/components/text_widget.dart';
import 'package:essentiel/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  var color = Colors.black;

  var loggedIn = false;
  // late bool _isLoading = false;
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
    // var data = {
    //   'username': emailController.text,
    //   'pword': textController.text,
    //   'token': 'askdflksadlk1293lAHSAKAS',
    // };
    // print(emailController.text);
    // print(textController.text);

    var res = await CallApi()
        .login(emailController.text.toString(), textController.text.toString());
    var body = json.decode(res.body);
    print(body);
    var studInfo = body['stud']['id'];
    print(studInfo);

    if (studInfo > 0) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', json.encode(body['stud']));
      localStorage.setString('studid', json.encode(body['stud']['id']));
      EasyLoading.showSuccess('Great Success!');
      _navigateToHome();
    } else {
      // _showMsg(body['message']);
      EasyLoading.showError('Failed to Login');
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: const EdgeInsets.only(left: 30, right: 40),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: height * 0.1),
                  const CircleAvatar(
                    radius: 70,
                    backgroundColor: Color(0xFF0A0A0A),
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFD5F6FF),
                      backgroundImage: AssetImage("images/spctLogo.jpg"),
                      radius: 70,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // const Text("Julio Pacana St., Licuan, Cagayan de Oro City"),
                  SizedBox(height: height * 0.1),
                  TextInput(
                      textString: "Username",
                      textController: emailController,
                      hint: "Username"),
                  SizedBox(
                    height: height * .05,
                  ),
                  TextInput(
                    textString: "Password",
                    textController: textController,
                    hint: "Password",
                    obscureText: true,
                  ),
                  SizedBox(
                    height: height * .05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                          color: color,
                          text: "Sign in",
                          fontSize: 22,
                          isUnderLine: false),
                      GestureDetector(
                        onTap: () {
                          if (textController.text.isEmpty ||
                              emailController.text.isEmpty) {
                            EasyLoading.showToast(
                              'Fill all fields!',
                              toastPosition: EasyLoadingToastPosition.bottom,
                            );
                          } else {
                            _login();
                          }
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff3f4fb2),
                          ),
                          child: const Icon(Icons.arrow_forward,
                              color: Colors.white, size: 30),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * .1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const SignUp(),
                          //   ),
                          // );
                          EasyLoading.showInfo(
                              'Sign up is temporarily unavailable!');
                        },
                        child: TextWidget(
                          color: color,
                          text: "Sign up",
                          fontSize: 16,
                          isUnderLine: true,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          EasyLoading.showInfo(
                              'Pls inform the authority or your teacher if you forgot your credentials!');
                        },
                        child: TextWidget(
                          color: color,
                          text: "Forgot Password",
                          fontSize: 16,
                          isUnderLine: true,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
}

class TextInput extends StatefulWidget {
  final String textString;
  final TextEditingController textController;
  final String hint;
  final bool obscureText;

  const TextInput({
    Key? key,
    required this.textString,
    required this.textController,
    required this.hint,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Color(0xFF000000)),
      cursorColor: const Color(0xFF9b9b9b),
      controller: widget.textController,
      keyboardType: TextInputType.text,
      obscureText: widget.obscureText && !showPassword,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        hintText: widget.textString,
        hintStyle: const TextStyle(
          color: Color(0xFF9b9b9b),
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        suffixIcon: widget.textString.toLowerCase() == "password"
            ? IconButton(
                icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              )
            : null,
      ),
    );
  }
}
