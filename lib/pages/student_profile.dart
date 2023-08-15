import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:essentiel/api/my_api.dart';
import 'package:essentiel/user/user.dart';
import 'package:essentiel/user/user_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  User user = UserData.myUser;
  String host = CallApi().getImage();
  bool isValid = false;

  @override
  void initState() {
    getUserInfo();
    isImageUrlValid();
    super.initState();
  }

  getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final json = preferences.getString('user');

    setState(() {
      user = json == null ? UserData.myUser : User.fromJson(jsonDecode(json));
    });
  }

  void isImageUrlValid() async {
    try {
      final response = await http.head(Uri.parse('$host${user.picurl}'));
      setState(() {
        isValid = response.statusCode == 200;
      });
    } catch (e) {
      setState(() {
        isValid = false; // An error occurred, so the URL is considered invalid
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 13.0,
                              spreadRadius: 4.0,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 5),
                              user.picurl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: "$host${user.picurl}",
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 70,
                                        backgroundImage: imageProvider,
                                      ),
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 70,
                                        backgroundImage:
                                            AssetImage("images/anonymous.jpg"),
                                      ),
                                    )
                                  : const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 70,
                                      backgroundImage:
                                          AssetImage("images/anonymous.jpg"),
                                    ),
                              const SizedBox(height: 16.0),
                              Text(
                                '${user.firstname} ${user.middlename} ${user.lastname}',
                                style: GoogleFonts.prompt(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'ID: ${user.sid}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'LRN: ${user.lrn}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 13.0,
                              spreadRadius: 4.0,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Address:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              ListTile(
                                leading: const Icon(Icons.location_on),
                                title: const Text('Street'),
                                subtitle: Text(user.street),
                              ),
                              ListTile(
                                leading: const Icon(Icons.location_city),
                                title: const Text('Barangay'),
                                subtitle: Text(user.barangay),
                              ),
                              ListTile(
                                leading: const Icon(Icons.location_city),
                                title: const Text('City'),
                                subtitle: Text(user.city),
                              ),
                              ListTile(
                                leading: const Icon(Icons.location_city),
                                title: const Text('Province'),
                                subtitle: Text(user.province),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 13.0,
                              spreadRadius: 4.0,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Parent / Guardian Information:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Father:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text('Full Name'),
                                subtitle: Text(user.fathername),
                              ),
                              ListTile(
                                leading: const Icon(Icons.work),
                                title: const Text('Occupation'),
                                subtitle: Text(user.foccupation),
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text('Contact Number'),
                                subtitle: Text(user.fcontactno),
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Mother:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text('Full Name'),
                                subtitle: Text(user.mothername),
                              ),
                              ListTile(
                                leading: const Icon(Icons.work),
                                title: const Text('Occupation'),
                                subtitle: Text(user.moccupation),
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text('Contact Number'),
                                subtitle: Text(user.mcontactno),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 13.0,
                              spreadRadius: 4.0,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Guardian Information:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text('Full Name'),
                                subtitle: Text(user.guardianname),
                              ),
                              ListTile(
                                leading: const Icon(Icons.people),
                                title: const Text('Relationship'),
                                subtitle: Text(user.guardianname),
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text('Contact Number'),
                                subtitle: Text(user.gcontactno),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 13.0,
                              spreadRadius: 4.0,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'In Case of Emergency, Call:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              user.ismothernum != 0
                                  ? ListTile(
                                      leading: const Icon(Icons.phone),
                                      title: const Text('Mother'),
                                      subtitle: Text(user.mcontactno),
                                    )
                                  : user.isfathernum != 0
                                      ? ListTile(
                                          leading: const Icon(Icons.phone),
                                          title: const Text('Father'),
                                          subtitle: Text(user.fcontactno),
                                        )
                                      : ListTile(
                                          leading: const Icon(Icons.phone),
                                          title: const Text('Guardian'),
                                          subtitle: Text(user.gcontactno),
                                        )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
