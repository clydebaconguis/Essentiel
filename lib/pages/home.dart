import 'package:essentiel/api/my_api.dart';
import 'package:essentiel/components/copyright.dart';
import 'package:essentiel/provider/navigation_provider.dart';
import 'package:essentiel/util/app_util.dart';
import 'package:essentiel/widget/navigation_drawer_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:essentiel/pages/dash.dart';
// import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  const Home({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => NavigationProvider(),
        child: MaterialApp(
          // color: Colors.black12,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context)
                  .textTheme, // Apply Poppins font to the default text theme
            ),
          ),
          home: const Homepage(
            title: 'Essentiel',
          ),
        ),
      );
}

class Homepage extends StatefulWidget {
  const Homepage({super.key, required String title});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Widget currentPage = const Dash(updateData: (const ClassSchedPage(),""));
  late Widget currentPage;
  var schoolcolor = 0;
  String pageName = 'Dashboard';
  String schoollogo = '';
  String host = CallApi().getImage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  updateData(Widget page, String pName) {
    if (mounted) {
      setState(() {
        currentPage = page;
        pageName = pName;
      });
    }
  }

  @override
  void initState() {
    getSchoolInfo();
    currentPage = Dash(
      updateData: updateData,
    );
    super.initState();
  }

  getSchoolInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      schoolcolor = localStorage.getInt('schoolcolor') ?? 0;
      schoollogo = localStorage.getString('schoollogo') ?? '';
    });
    if (schoolcolor > 0 && !kIsWeb) {
      AppUtil().changeStatusBarColor(schoolcolor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var isWide = constraints.maxWidth > 800;
          return Scaffold(
            backgroundColor: Colors.white,
            drawer: !isWide
                ? NavigationDrawerWidget(
                    updateData: updateData,
                    activenav: '',
                  )
                : null,
            key: _scaffoldKey,
            appBar: AppBar(
              shadowColor: Colors.white38,
              toolbarHeight: 65,
              titleSpacing: 0,
              elevation: 4.0,
              backgroundColor: Colors.white,
              leading: !isWide
                  ? IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black, // Set the color of the icon
                      ),
                      onPressed: _openDrawer,
                    )
                  : null,
              title: Padding(
                padding: const EdgeInsets.only(
                    right: 14), // Add desired padding on the right side
                child: Row(
                  children: [
                    if (isWide)
                      SizedBox(
                        width: constraints.maxWidth * 0.02,
                      ),
                    if (schoollogo.isNotEmpty)
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 23,
                        // backgroundImage: AssetImage("images/spctLogo.jpg"),
                        backgroundImage: NetworkImage('$host$schoollogo'),
                      ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        pageName,
                        style: GoogleFonts.prompt(
                          fontSize: 22,
                          color: schoolcolor > 0
                              ? Color(schoolcolor)
                              : Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Row(
              children: [
                if (isWide)
                  NavigationDrawerWidget(
                    updateData: updateData,
                    activenav: pageName,
                  ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: isWide
                              ? const EdgeInsets.only(
                                  left: 20, right: 20, top: 10)
                              : const EdgeInsets.all(0),
                          child: currentPage ==
                                  Dash(
                                    updateData: updateData,
                                  )
                              ? Dash(
                                  updateData: updateData,
                                )
                              : currentPage,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Copyright(
                          labelColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
