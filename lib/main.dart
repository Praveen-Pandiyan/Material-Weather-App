import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class MainRouter extends StatefulWidget {
  const MainRouter({Key? key}) : super(key: key);

  @override
  State<MainRouter> createState() => _MainRouterState();
}

class _MainRouterState extends State<MainRouter> {
  bool isFirst = true;
  CurrentPage _currentPage = CurrentPage.search;
  late CommonState commonState;
  @override
  Widget build(BuildContext context) {
    commonState = Provider.of<CommonState>(context);
    return SlidingDrawer(
      isOpen: commonState.isDrawerOpen,
      onCloseDrawer: () => setState(() {
        commonState.isDrawerOpen = false;
      }),
      drawer: Column(
        children: List.generate(
            10,
            (index) => InkWell(
                onTap: () {
                  setState(() {
                    _currentPage = CurrentPage.search;
                  });
                },
                child: Text("$index"))),
      ),
      child: () {
        switch (_currentPage) {
          case CurrentPage.home:
            return const MyHomePage();
          case CurrentPage.search:
            return const SearchPage();
          default:
        }
      }() as Widget,
    );
  }
}
