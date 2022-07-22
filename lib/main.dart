import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/current_data.dart';

import 'components/sliding_drawer.dart';
import 'pages/home.dart';
import 'pages/search.dart';
import 'providers/common_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CommonState(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            // UI
            brightness: Brightness.light,
            primaryColor: Colors.lightBlue[800],
            accentColor: Colors.cyan[600],
            // font
            fontFamily: 'Georgia',
            //text style
            textTheme: const TextTheme(
              headline1: TextStyle(
                  fontSize: 72.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              headline2: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
              headline4: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
            ),
            backgroundColor: Colors.white),
        darkTheme: ThemeData.dark().copyWith(
          backgroundColor: Colors.black,
        ),
        themeMode: ThemeMode.light,
        home: const MainRouter(),
      ),
    );
  }
}

class DrawerItem {
  String title;
  CurrentPage page;
  IconData icons;
  DrawerItem({required this.title, required this.page, required this.icons});
}

class MainRouter extends StatefulWidget {
  const MainRouter({Key? key}) : super(key: key);

  @override
  State<MainRouter> createState() => _MainRouterState();
}

class _MainRouterState extends State<MainRouter> {
  bool isFirst = true;
  CommonState? commonState;
  bool drawerOpen = false;
  List<DrawerItem> drawerList = [
    DrawerItem(title: "Home", icons: Icons.home, page: CurrentPage.home),
    DrawerItem(title: "Search", icons: Icons.search, page: CurrentPage.search)
  ];
  @override
  Widget build(BuildContext context) {
    CommonState commonState = Provider.of<CommonState>(context);
    return SlidingDrawer(
      isOpen: drawerOpen,
      onCloseDrawer: () => setState(() {
        drawerOpen = false;
      }),
      drawer: Column(
        children: drawerList
            .map((e) => InkWell(
                  onTap: () {
                    commonState.currentPage = e.page;
                    setState(() {
                      drawerOpen = false;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(e.icons),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        e.title,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
      child: () {
        switch (commonState.currentPage) {
          case CurrentPage.home:
            return MyHomePage(
              triggerDrawer: (val) {
                setState(() {
                  drawerOpen = val;
                });
              },
            );
          case CurrentPage.search:
            return SearchPage();
          default:
            return const MyHomePage();
        }
      }(),
    );
  }
}
