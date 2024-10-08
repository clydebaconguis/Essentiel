import 'dart:async';
import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:essentiel/api/my_api.dart';
import 'package:essentiel/components/copyright.dart';
import 'package:essentiel/data/drawer_items.dart';
import 'package:essentiel/models/drawer_item.dart';
import 'package:essentiel/pages/attendance.dart';
import 'package:essentiel/pages/billing_information.dart';
import 'package:essentiel/pages/class_schedule.dart';
import 'package:essentiel/pages/diocese/dashboard.dart';
import 'package:essentiel/pages/diocese/school/pages/enrollment_statistics.dart';
import 'package:essentiel/pages/diocese/school/pages/finance/accounts_receivable.dart';
import 'package:essentiel/pages/diocese/school/pages/finance/cashier_transactions.dart';
import 'package:essentiel/pages/diocese/school/pages/home.dart';
import 'package:essentiel/pages/diocese/school/pages/hresource/employee_profile.dart';
import 'package:essentiel/pages/home.dart';
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

class NavigationDrawerWidget2 extends StatefulWidget {
  final String activenav;
  final Function(Widget, String) updateData;
  const NavigationDrawerWidget2({
    super.key,
    required this.updateData,
    required this.activenav,
  });

  @override
  State<NavigationDrawerWidget2> createState() =>
      _NavigationDrawerWidget2State();
}

class _NavigationDrawerWidget2State extends State<NavigationDrawerWidget2> {
  User user = UserData.myUser;
  String host = CallApi().getImage();
  String selectedNav = '';
  bool isValid = false;
  var schoolcolor = 0;
  var schoolabbv = '';
  var schoollogo = '';
  bool isExpanded = false;
  bool isExpanded2 = false;

  @override
  void initState() {
    // getUser();
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
        var link = provider.activeNav2;
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
    if (mounted) {
      setState(() {
        isExpanded = provider.isExpanded2;
        isExpanded2 = provider.isExpanded3;
      });
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var isWide = constraints.maxWidth > 800;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade800, // Lighter shade of green
              Colors.grey.shade800, // Darker shade of green
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        width: isCollapsed && !isWide
            ? MediaQuery.of(context).size.width * 0.2
            : isCollapsed && isWide
                ? constraints.maxWidth * 0.2
                : null,
        child: Drawer(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0).add(safeArea),
                  width: double.infinity,
                  // color: Colors.white12,
                  child: !isWide ? buildHeader(isCollapsed) : null,
                ),
                if (!isWide)
                  const Divider(
                    color: Colors.grey,
                  ),
                // if (user.picurl.isNotEmpty)
                buildProfileCircle(isCollapsed),
                const SizedBox(height: 15),
                const Divider(
                  color: Colors.white70,
                ),
                const SizedBox(height: 20),
                buildList(
                    items: dioceseItems,
                    isCollapsed: isCollapsed,
                    isWide: isWide),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  tileColor: Colors.transparent,
                  title: !isCollapsed
                      ? ExpansionTile(
                          shape: Border.all(color: Colors.transparent),
                          // tilePadding:
                          //     const EdgeInsets.symmetric(horizontal: 12),
                          leading: const Icon(
                            Icons.account_balance,
                            color: Colors.white60,
                          ),
                          onExpansionChanged: (bool expanded) {
                            setState(() {
                              isExpanded = expanded;
                              provider.toggleExpanded2();
                            });
                          },
                          initiallyExpanded: isExpanded,
                          collapsedBackgroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          iconColor: Colors.white70,
                          collapsedIconColor: Colors.white70,
                          title: Text(
                            'Finance Reports',
                            style: GoogleFonts.prompt(
                                color: Colors.white70, fontSize: 16),
                          ),
                          children: [
                            Builder(
                              builder: (BuildContext childContext) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:
                                      finance.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    return ListTile(
                                      // contentPadding:
                                      //     const EdgeInsets.symmetric(
                                      // horizontal: 22),
                                      tileColor: !isWide
                                          ? selectedNav == item.title
                                              ? Colors.white70
                                              : null
                                          : widget.activenav == item.title
                                              ? Colors.white70
                                              : null,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      leading: Icon(
                                        selectedNav == item.title
                                            ? Icons.lightbulb_circle
                                            : item.icon,
                                        color: !isWide
                                            ? selectedNav == item.title
                                                ? Colors.green.shade800
                                                : Colors.white70
                                            : widget.activenav == item.title
                                                ? Colors.green.shade800
                                                : Colors.white70,
                                      ),
                                      title: Text(
                                        item.title,
                                        style: GoogleFonts.prompt(
                                          color: !isWide
                                              ? selectedNav == item.title
                                                  ? Colors.grey[800]
                                                  : Colors.white70
                                              : widget.activenav == item.title
                                                  ? Colors.grey[800]
                                                  : Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {
                                        selectItem2(
                                            context, index, item.title, isWide);
                                        if (mounted) {
                                          setState(() {
                                            selectedNav = item
                                                .title; // Update the selected index
                                            final provider =
                                                Provider.of<NavigationProvider>(
                                                    context,
                                                    listen: false);
                                            provider.setActiveNav(item.title);
                                          });
                                        }
                                      },
                                      selected: !isWide
                                          ? selectedNav == item.title
                                          : widget.activenav == item.title,
                                      selectedTileColor: Colors.white70,
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        )
                      : null,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  tileColor: Colors.transparent,
                  title: !isCollapsed
                      ? ExpansionTile(
                          shape: Border.all(color: Colors.transparent),
                          // tilePadding:
                          //     const EdgeInsets.symmetric(horizontal: 12),
                          leading: const Icon(
                            Icons.people_alt,
                            color: Colors.white60,
                          ),
                          onExpansionChanged: (bool expanded) {
                            setState(() {
                              isExpanded2 = expanded;
                              provider.toggleExpanded3();
                            });
                          },
                          initiallyExpanded: isExpanded2,
                          collapsedBackgroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          iconColor: Colors.white70,
                          collapsedIconColor: Colors.white70,
                          title: Text(
                            'Human Resource',
                            style: GoogleFonts.prompt(
                                color: Colors.white70, fontSize: 16),
                          ),
                          children: [
                            Builder(
                              builder: (BuildContext childContext) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:
                                      hresource.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    return ListTile(
                                      // contentPadding:
                                      //     const EdgeInsets.symmetric(
                                      // horizontal: 22),
                                      tileColor: !isWide
                                          ? selectedNav == item.title
                                              ? Colors.white70
                                              : null
                                          : widget.activenav == item.title
                                              ? Colors.white70
                                              : null,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      leading: Icon(
                                        selectedNav == item.title
                                            ? Icons.lightbulb_circle
                                            : item.icon,
                                        color: !isWide
                                            ? selectedNav == item.title
                                                ? Colors.green.shade800
                                                : Colors.white70
                                            : widget.activenav == item.title
                                                ? Colors.green.shade800
                                                : Colors.white70,
                                      ),
                                      title: Text(
                                        item.title,
                                        style: GoogleFonts.prompt(
                                          color: !isWide
                                              ? selectedNav == item.title
                                                  ? Colors.grey[800]
                                                  : Colors.white70
                                              : widget.activenav == item.title
                                                  ? Colors.grey[800]
                                                  : Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {
                                        selectItem2(
                                            context, 2, item.title, isWide);
                                        // if (mounted) {
                                        //   setState(() {
                                        //     selectedNav = item
                                        //         .title; // Update the selected index
                                        //     final provider =
                                        //         Provider.of<NavigationProvider>(
                                        //             context,
                                        //             listen: false);
                                        //     provider.setActiveNav(item.title);
                                        //   });
                                        // }
                                      },
                                      selected: !isWide
                                          ? selectedNav == item.title
                                          : widget.activenav == item.title,
                                      selectedTileColor: Colors.white70,
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        )
                      : null,
                ),
                ListTile(
                  tileColor: !isWide
                      ? selectedNav == 'Enrollment Statistics'
                          ? Colors.white70
                          : null
                      : widget.activenav == 'Enrollment Statistics'
                          ? Colors.white70
                          : null,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  horizontalTitleGap: 17,
                  leading: Icon(
                    Icons.bar_chart_rounded,
                    color: !isWide
                        ? selectedNav == 'Enrollment Statistics'
                            ? Colors.green.shade800
                            : Colors.white70
                        : widget.activenav == 'Enrollment Statistics'
                            ? Colors.green.shade800
                            : Colors.white70,
                  ),
                  title: Text(
                    'Enrollment Statistics',
                    style: GoogleFonts.prompt(
                        color: selectedNav == 'Enrollment Statistics'
                            ? Colors.grey.shade800
                            : Colors.white70,
                        fontSize: 16),
                  ),
                  selected: !isWide
                      ? selectedNav == 'Enrollment Statistics'
                      : widget.activenav == 'Enrollment Statistics',
                  selectedTileColor: Colors.white70,
                  onTap: () {
                    selectItem2(context, 3, 'Enrollment Statistics', isWide);
                    // if (mounted) {
                    //   setState(() {
                    //     selectedNav =
                    //         'Enrollment Statistics'; // Update the selected index
                    //     final provider = Provider.of<NavigationProvider>(
                    //         context,
                    //         listen: false);
                    //     provider.setActiveNav('Enrollment Statistics');
                    //   });
                    // }
                  },
                ),
                const SizedBox(height: 20),
                const Divider(
                  color: Colors.white54,
                ),
                Wrap(
                  runSpacing: 20.0,
                  children: [
                    buildLogout(
                      items: itemsFirst2,
                      isCollapsed: isCollapsed,
                      isWide: isWide,
                    ),
                    Copyright(
                      labelColor: Colors.white54,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void selectItem2(BuildContext context, int index, String title, bool isWide) {
    if (mounted) {
      setState(() {
        selectedNav = title;
        final provider =
            Provider.of<NavigationProvider>(context, listen: false);

        provider.setActiveNav(title);
      });
    }

    !isWide ? Navigator.of(context).pop() : null;

    switch (index) {
      case 0:
        widget.updateData(const Cashier(), "Cashier Transactions");
        break;
      case 1:
        widget.updateData(const AccountReceivable(), "Account Receivable");
        break;
      case 2:
        widget.updateData(const EmployeeProfile(), "Employee Profile");
        break;
      case 3:
        widget.updateData(const EnrollmentStat(), "Enrollment Statistics");
        break;
    }
  }

  // Main Nav tile
  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    required bool isWide,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 0),
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
                selectItem(context, indexOffset + index, item.title, isWide),
            isWide: isWide,
          );
        },
      );

  void selectItem(BuildContext context, int index, String title, bool isWide) {
    if (mounted) {
      setState(() {
        selectedNav = title;
        final provider =
            Provider.of<NavigationProvider>(context, listen: false);

        provider.setActiveNav(title);
      });
    }

    !isWide ? Navigator.of(context).pop() : null;
    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      case 1:
        widget.updateData(const HomeDio(), "Home");
        break;
    }
  }

  Widget buildMenuItem({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
    required bool isWide,
  }) {
    return Material(
        color: Colors.transparent,
        child: isCollapsed && !isWide
            ? ListTile(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                selected: selectedNav.toLowerCase() == text.toLowerCase(),
                selectedTileColor: Colors.white70,
                title: Icon(icon,
                    color: selectedNav == text ? Colors.white : Colors.white70),
              )
            : isCollapsed && isWide
                ? ListTile(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    selected:
                        widget.activenav.toLowerCase() == text.toLowerCase(),
                    // selectedTileColor: Color(schoolcolor),
                    selectedTileColor: Colors.white70,
                    title: Icon(icon,
                        color: widget.activenav == text
                            ? Colors.grey[800]
                            : Colors.white70),
                  )
                : !isCollapsed && !isWide
                    ? ListTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        selected: selectedNav == text,
                        selectedTileColor: Colors.white70,
                        leading: Icon(icon,
                            color: selectedNav == text
                                ? Colors.grey[800]
                                : Colors.white70),
                        title: Text(
                          text,
                          style: GoogleFonts.prompt(
                            color: selectedNav == text
                                ? Colors.grey[800]
                                : Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        onTap: onClicked,
                      )
                    : !isCollapsed && isWide
                        ? ListTile(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            selected: widget.activenav == text,
                            // selectedTileColor: Color(schoolcolor),
                            selectedTileColor: Colors.white70,
                            leading: Icon(icon,
                                color: widget.activenav == text
                                    ? Colors.grey[800]
                                    : Colors.white70),
                            title: Text(
                              text,
                              style: GoogleFonts.prompt(
                                color: widget.activenav == text
                                    ? Colors.grey[800]
                                    : Colors.white70,
                                fontSize: 17,
                              ),
                            ),
                            onTap: onClicked,
                          )
                        : null);
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
          child: const CircleAvatar(
            backgroundColor: Colors.red,
            radius: 23,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 23,
              backgroundImage: AssetImage("images/spctLogo.jpg"),
              // backgroundImage: NetworkImage('$host$schoollogo'),
            ),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.only(bottom: 10, top: 20),
          child: Row(
            children: [
              const SizedBox(width: 24),
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  backgroundImage: AssetImage("images/spctLogo.jpg"),
                  // backgroundImage: NetworkImage('$host$schoollogo'),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HSA',
                    style: GoogleFonts.prompt(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'SCHOOL ADMIN PORTAL',
                    style: GoogleFonts.prompt(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
    required bool isWide,
  }) =>
      ListView.separated(
        padding: isCollapsed
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 0),
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
              isCollapsed: isCollapsed,
              text: item.title,
              icon: Icons.exit_to_app,
              onClicked: () => showLogoutConfirmationDialog(context),
              isWide: isWide);
        },
      );

  Widget buildProfileCircle(bool isCollapsed) => Column(
        children: [
          const SizedBox(height: 24),
          Stack(
            children: [
              // CachedNetworkImage(
              //   imageUrl: "$host${user.picurl}",
              //   imageBuilder: (context, imageProvider) => CircleAvatar(
              //     radius: isCollapsed ? 30 : 40,
              //     backgroundImage: imageProvider,
              //   ),
              //   placeholder: (context, url) => Center(
              //     child: CircleAvatar(
              //       // backgroundColor: Color(schoolcolor),
              //       backgroundColor: Colors.white,
              //       radius: isCollapsed ? 30 : 40,
              //       child: const CircularProgressIndicator(),
              //     ),
              //   ),
              //   errorWidget: (context, url, error) => CircleAvatar(
              //     backgroundColor: Colors.white,
              //     radius: isCollapsed ? 30 : 35,
              //     backgroundImage: const AssetImage("images/anonymous.jpg"),
              //   ),
              // )
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: isCollapsed ? 30 : 35,
                backgroundImage: const AssetImage("images/anonymous.jpg"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (!isCollapsed)
            Center(
              child: Text(
                textAlign: TextAlign.center,
                // user.name.toUpperCase(),
                // '${user.firstname} ${user.middlename} ${user.lastname} ${user.suffix}'
                'FR. PITOK BATOLATA'.toUpperCase(),
                style: GoogleFonts.prompt(
                  fontSize: 16,
                  // color: Color(schoolcolor),
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (!isCollapsed)
            const Text(
              // user.sid,
              'SCHOOL HEAD',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white54,
                fontSize: 13,
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
