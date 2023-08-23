import 'package:essentiel/components/copyright.dart';
import 'package:essentiel/pages/diocese/school/pages/home.dart';
import 'package:essentiel/provider/navigation_provider.dart';
import 'package:essentiel/widget/navigation_drawer_dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SchoolMain extends StatelessWidget {
  const SchoolMain({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => NavigationProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // primarySwatch: Colors.blue,
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context)
                  .textTheme, // Apply Poppins font to the default text theme
            ),
          ),
          home: const SchoolHomePage(),
        ),
      );
}

class SchoolHomePage extends StatefulWidget {
  const SchoolHomePage({super.key});

  @override
  State<SchoolHomePage> createState() => _SchoolHomePageState();
}

class _SchoolHomePageState extends State<SchoolHomePage> {
  Widget currentPage = const HomeDio();
  String pageName = 'Home';
  var schoolcolor = 0;
  var schoollogo = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  updateData(Widget page, String pName) {
    if (mounted) {
      setState(() {
        currentPage = page;
        pageName = pName;
      });
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var isWide = constraints.maxWidth > 800;
        return Scaffold(
          drawer: NavigationDrawerWidget2(
            updateData: updateData,
            activenav: '',
          ),
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
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 23,
                      // backgroundImage: AssetImage("images/spctLogo.jpg"),
                      backgroundImage: NetworkImage(''
                          // '$host$schoollogo',
                          ),
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
                NavigationDrawerWidget2(
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
                          child: currentPage),
                    ),
                    if (isWide)
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
      }),
    );
  }
}
