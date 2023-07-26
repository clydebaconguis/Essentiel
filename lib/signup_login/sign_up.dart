// import 'package:ebooks/components/text_widget.dart';
// import 'package:ebooks/signup_login/sign_in.dart';
// import 'package:flutter/material.dart';
//
// class SignUp extends StatefulWidget {
//   const SignUp({super.key});
//
//   @override
//   State<SignUp> createState() => _SignUpState();
// }
//
// class _SignUpState extends State<SignUp> {
//   TextEditingController passController = TextEditingController();
//
//   TextEditingController repassController = TextEditingController();
//
//   TextEditingController emailController = TextEditingController();
//
//   TextEditingController nameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     final double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: const Color(0xFFffffff),
//       body: Container(
//         padding: const EdgeInsets.only(left: 30, right: 40),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: height * 0.1),
//               Container(
//                 padding: const EdgeInsets.only(left: 0, right: 30),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   // children: [
//                   //   IconButton(
//                   //     padding: EdgeInsets.zero,
//                   //     constraints: const BoxConstraints(),
//                   //     icon: const Icon(Icons.arrow_back_ios,
//                   //         color: Color(0xFF363f93)),
//                   //     onPressed: () =>
//                   //         Navigator.of(context, rootNavigator: true)
//                   //             .pop(context),
//                   //   )
//                   // ],
//                 ),
//               ),
//               SizedBox(height: height * 0.1),
//               const TextWidget(
//                   color: Color(0xffcf167f),
//                   text: "New here?",
//                   fontSize: 26,
//                   isUnderLine: false),
//               const TextWidget(
//                   color: Color(0xffcf167f),
//                   text: "Sign up in Minutes",
//                   fontSize: 26,
//                   isUnderLine: false),
//               SizedBox(height: height * 0.1),
//               TextInput(
//                   textString: "Name",
//                   textController: nameController,
//                   hint: "Name"),
//               SizedBox(
//                 height: height * .05,
//               ),
//               TextInput(
//                   textString: "Email",
//                   textController: emailController,
//                   hint: "Email"),
//               SizedBox(
//                 height: height * .05,
//               ),
//               TextInput(
//                 textString: "Password",
//                 textController: passController,
//                 hint: "Password",
//                 obscureText: true,
//               ),
//               SizedBox(
//                 height: height * .05,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const TextWidget(
//                       color: Color(0xffcf167f),
//                       text: "Sign up",
//                       fontSize: 22,
//                       isUnderLine: false),
//                   GestureDetector(
//                     onTap: () {
//                       // _login();
//                     },
//                     child: Container(
//                       height: 60,
//                       width: 60,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xffcf167f),
//                       ),
//                       child: const Icon(Icons.arrow_forward,
//                           color: Colors.white, size: 30),
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: height * .1,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const SignIn()));
//                     },
//                     child: const TextWidget(
//                         color: Color(0xffcf167f),
//                         text: "Sign in",
//                         fontSize: 16,
//                         isUnderLine: true),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (context) => const SignIn()));
//                     },
//                     child: const TextWidget(
//                         color: Color(0xffcf167f),
//                         text: "Forgot Password",
//                         fontSize: 16,
//                         isUnderLine: true),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // _register() async {
//   //   var data = {
//   //     'name': nameController.text,
//   //     'email': emailController.text,
//   //     'password': passController.text,
//   //   };
//   //   debugPrint(nameController.text);
//   //   debugPrint(emailController.text);
//   //   debugPrint(passController.text);
//   //   debugPrint(repassController.text);
//
//   //   var res = await CallApi().postData(data, 'register');
//   //   var body = json.decode(res.body);
//
//   //   if (body['success']) {
//   //     SharedPreferences localStorage = await SharedPreferences.getInstance();
//   //     localStorage.setString('token', body['token']);
//   //     localStorage.setString(
//   //       'user',
//   //       json.encode(
//   //         body['user'],
//   //       ),
//   //     );
//   //     _navigateToBooks();
//   //   } else {
//   //     _showMsg(body['message']);
//   //   }
//   // }
// }
//
// class TextInput extends StatelessWidget {
//   final String textString;
//   final TextEditingController textController;
//   final String hint;
//   final bool obscureText;
//   const TextInput(
//       {Key? key,
//       required this.textString,
//       required this.textController,
//       required this.hint,
//       this.obscureText = false})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       style: const TextStyle(color: Color(0xFF000000)),
//       cursorColor: const Color(0xFF9b9b9b),
//       controller: textController,
//       keyboardType: TextInputType.text,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xffcf167f),
//           ),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xffcf167f),
//           ),
//         ),
//         hintText: textString,
//         hintStyle: const TextStyle(
//             color: Color(0xFF9b9b9b),
//             fontSize: 15,
//             fontWeight: FontWeight.normal),
//       ),
//     );
//   }
// }
