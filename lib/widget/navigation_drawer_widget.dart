import 'dart:async';
import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:essentiel/api/my_api.dart';
import 'package:essentiel/data/drawer_items.dart';
import 'package:essentiel/models/drawer_item.dart';
import 'package:essentiel/pages/attendance.dart';
import 'package:essentiel/pages/billing_information.dart';
import 'package:essentiel/pages/class_schedule.dart';
import 'package:essentiel/pages/report_card.dart';
import 'package:essentiel/pages/school_calendar.dart';
import 'package:essentiel/pages/semester_information.dart';
import 'package:essentiel/pages/student_profile.dart';
import 'package:essentiel/provider/navigation_provider.dart';
import 'package:essentiel/signup_login/sign_in.dart';
import 'package:essentiel/user/user.dart';
import 'package:essentiel/user/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:essentiel/pages/dash.dart';

class NavigationDrawerWidget extends StatefulWidget {
  final Function(Widget, String) updateData;
  const NavigationDrawerWidget({super.key, required this.updateData});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  User user = UserData.myUser;
  String host = CallApi().getImage();
  String selectedNav = '';
  bool isValid = false;
  var schoolcolor = 0;
  var schoolabbv = '';
  var schoollogo = '';
  bool isExpanded = false;

  @override
  void initState() {
    getUser();
    getProviderFiles();
    super.initState();
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final json = preferences.getString('user');

    if (mounted) {
      setState(() {
        user = User.fromJson(jsonDecode(json!));
        schoolcolor = preferences.getInt('schoolcolor') ?? 0;
        schoolabbv = preferences.getString('schoolabbv') ?? '';
        schoollogo = filterImage(preferences.getString('schoollogo'));
      });
    }
  }

  filterImage(url) {
    int questionMarkIndex = url.indexOf("?");

    if (questionMarkIndex != -1) {
      // Remove everything starting from the question mark
      String newUrl = url.substring(0, questionMarkIndex);

      // print("New URL: $newUrl");
      return newUrl;
    } else {
      // If there is no question mark in the URL
      // print("URL doesn't contain a question mark");
      return url;
    }
  }

  navigateToSignIn() {
    EasyLoading.showSuccess('Logged out');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const SignIn(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.clear();
    navigateToSignIn();
  }

  getProviderFiles() async {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    if (mounted) {
      setState(() {
        var link = provider.activeNav;
        if (link.isNotEmpty) {
          selectedNav = link;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    final provider = Provider.of<NavigationProvider>(context);
    var isCollapsed = provider.isCollapsed;
    setState(() {
      isExpanded = provider.isExpanded;
    });
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white, // Lighter shade of green
            Color(schoolcolor), // Darker shade of green
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var isWide = constraints.maxWidth > 800;
          return Drawer(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 0).add(safeArea),
                      width: double.infinity,
                      // color: Colors.white12,
                      child: !isWide && schoollogo.isNotEmpty
                          ? buildHeader(isCollapsed)
                          : null,
                    ),
                    const Divider(),
                    if (user.picurl.isNotEmpty) buildProfileCircle(isCollapsed),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.black26,
                    ),
                    const SizedBox(height: 20),
                    buildList(items: itemsFirst, isCollapsed: isCollapsed),
                    ListTile(
                      tileColor: Colors.transparent,
                      title: !isCollapsed
                          ? ExpansionTile(
                              onExpansionChanged: (bool expanded) {
                                setState(() {
                                  isExpanded = expanded;
                                  provider.toggleExpanded();
                                });
                              },
                              initiallyExpanded: isExpanded,
                              collapsedBackgroundColor: Colors.transparent,
                              tilePadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              title: Text(
                                'See more',
                                style: GoogleFonts.prompt(
                                    color: Colors.black, fontSize: 16),
                              ),
                              children: [
                                Builder(
                                  builder: (BuildContext childContext) {
                                    return Column(
                                      children: itemFirstContinuation
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final index = entry.key;
                                        final item = entry.value;
                                        return ListTile(
                                          tileColor: selectedNav == item.title
                                              ? Color(schoolcolor)
                                              : null,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.only(left: 20),
                                          leading: Icon(
                                            item.icon,
                                            color: selectedNav == item.title
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                          title: Text(
                                            item.title,
                                            style: GoogleFonts.prompt(
                                              color: selectedNav == item.title
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          onTap: () {
                                            selectItem2(
                                                context, index, item.title);
                                            if (mounted) {
                                              setState(() {
                                                selectedNav = item
                                                    .title; // Update the selected index
                                                final provider = Provider.of<
                                                        NavigationProvider>(
                                                    context,
                                                    listen: false);
                                                provider
                                                    .setActiveNav(item.title);
                                              });
                                            }
                                          },
                                          selected: selectedNav == item.title,
                                          selectedTileColor: Color(schoolcolor),
                                          focusColor: Color(schoolcolor),
                                          hoverColor: Color(schoolcolor),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ],
                            )
                          : null,
                    ),

                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.black26,
                    ),
                    buildLogout(items: itemsFirst2, isCollapsed: isCollapsed),
                    const SizedBox(height: 20),
                    !isCollapsed
                        ? Center(
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.copyright_outlined,
                                    color: Colors.black45,
                                    size: 18.0,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Text(
                                    'Copyright 2023',
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Powered by',
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset(
                                      "images/cklogo.png",
                                      height: 25,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  buildCollapseIcon(context, isCollapsed),
                                ],
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(
                              "images/cklogo.png",
                              height: 25,
                            ),
                          ),
                    isCollapsed
                        ? buildCollapseIcon(context, isCollapsed)
                        : const SizedBox(height: 0),
                    const SizedBox(height: 50),

                    // buildCollapseIcon(context, isCollapsed),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void selectItem2(BuildContext context, int index, String title) {
    if (mounted) {
      setState(() {
        selectedNav = title;
        final provider =
            Provider.of<NavigationProvider>(context, listen: false);

        provider.setActiveNav(title);
      });
    }

    Navigator.of(context).pop();

    switch (index) {
      case 0:
        widget.updateData(const Billing(), "Billing Information");
        // navigateTo(const Billing());
        break;
      case 1:
        widget.updateData(const SchoolCalendar(), "School Calendar");
        // navigateTo(const SchoolCalendar());
        break;
      case 2:
        widget.updateData(
            const SemesterInformation(), "Enrollment Information");
        // navigateTo(const SemesterInformation());
        break;
      case 3:
        widget.updateData(const StudentProfile(), "Student Profile");
        // navigateTo(const StudentProfile());
        break;
    }
  }

  // Main Nav tile
  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 0),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () =>
                selectItem(context, indexOffset + index, item.title),
          );
        },
      );

  void selectItem(BuildContext context, int index, String title) {
    if (mounted) {
      setState(() {
        selectedNav = title;
        final provider =
            Provider.of<NavigationProvider>(context, listen: false);

        provider.setActiveNav(title);
      });
    }

    Navigator.of(context).pop();
    switch (index) {
      case 0:
        widget.updateData(Dash(updateData: widget.updateData), "Dashboard");
        // navigateTo(const Home());
        break;
      case 1:
        widget.updateData(const Attendance(), "Attendance");
        // navigateTo(const AttendancePage());
        break;
      case 2:
        widget.updateData(const ReportCard(), "Report Card");
        // navigateTo(const ReportCard());
        break;
      case 3:
        widget.updateData(const ClassSchedPage(), "Class Schedule");
        // navigateTo(const ClassSchedule());
        break;
    }
  }

  Widget buildMenuItem({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              selected: selectedNav.toLowerCase() == text.toLowerCase(),
              selectedTileColor: Color(schoolcolor),
              title: Icon(icon,
                  color: selectedNav == text ? Colors.white : Colors.black87),
            )
          : ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              selected: selectedNav == text,
              selectedTileColor: Color(schoolcolor),
              leading: Icon(icon,
                  color: selectedNav == text ? Colors.white : Colors.black87),
              title: Text(
                text,
                style: GoogleFonts.prompt(
                  fontWeight: FontWeight.w600,
                  color: selectedNav == text ? Colors.white : Colors.black87,
                  fontSize: 17,
                ),
              ),
              onTap: onClicked,
            ),
    );
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    const double size = 30;
    final icon = isCollapsed
        ? Icons.arrow_forward_ios_rounded
        : Icons.arrow_back_ios_rounded;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    // final margin = isCollapsed ? null : const EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      // margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: SizedBox(
            width: width,
            height: size,
            child: Icon(
              icon,
              color: Colors.black,
              size: 20,
            ),
          ),
          onTap: () {
            final provider =
                Provider.of<NavigationProvider>(context, listen: false);

            provider.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) {
    try {
      if (isCollapsed) {
        return Container(
          padding: const EdgeInsets.only(bottom: 10, top: 20),
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 23,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 23,
              // backgroundImage: AssetImage("images/spctLogo.jpg"),
              backgroundImage: NetworkImage('$host$schoollogo'),
            ),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.only(bottom: 10, top: 20),
          child: Row(
            children: [
              const SizedBox(width: 24),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  // backgroundImage: AssetImage("images/spctLogo.jpg"),
                  backgroundImage: NetworkImage('$host$schoollogo'),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                schoolabbv,
                style: GoogleFonts.prompt(
                  fontSize: 25,
                  color: Color(schoolcolor),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Handle the error here
      // print('Error loading image: $error');
      // You can return an alternative widget or display an error message here
      return Container(
        padding: const EdgeInsets.only(bottom: 10, top: 20),
        child: const Text('Error loading image'),
      );
    }
  }

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.poppins(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog and do nothing (cancel logout)
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog and perform logout
                Navigator.of(context).pop();
                logout();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ),
                    (Route<dynamic> route) => false);
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildLogout({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
              isCollapsed: isCollapsed,
              text: item.title,
              icon: item.icon,
              onClicked: () => showLogoutConfirmationDialog(context));
        },
      );

  Widget buildProfileCircle(bool isCollapsed) => Column(
        children: [
          const SizedBox(height: 24),
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: "$host${user.picurl}",
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: isCollapsed ? 30 : 40,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => Center(
                  child: CircleAvatar(
                    backgroundColor: Color(schoolcolor),
                    radius: isCollapsed ? 30 : 40,
                    child: const CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: isCollapsed ? 30 : 40,
                  backgroundImage: const AssetImage("images/anonymous.jpg"),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          if (!isCollapsed)
            Center(
              child: Text(
                textAlign: TextAlign.center,
                // user.name.toUpperCase(),
                '${user.firstname} ${user.middlename} ${user.lastname} ${user.suffix}'
                    .toUpperCase(),
                style: GoogleFonts.prompt(
                  fontSize: 20,
                  color: Color(schoolcolor),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          if (!isCollapsed)
            Text(
              user.sid,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
        ],
      );

  Widget buildEditIcon(Color color, double size, double pad) => buildCircle(
      all: pad,
      child: Icon(
        Icons.safety_check,
        color: color,
        size: size,
      ));

  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
          child: Container(
        padding: EdgeInsets.all(all),
        // color: const Color(0xFFE91E63),
        child: child,
      ));
}
