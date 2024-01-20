import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'components/sliding_drawer.dart';
import 'models/custome_models.dart';
import 'pages/home.dart';
import 'pages/search.dart';
import 'providers/common_state.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // locks iin potrate mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
         
            // font
            fontFamily: 'display-sans',
            //text style
            textTheme:  const TextTheme(
              displayLarge:TextStyle(
                  fontSize: 72.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              displayMedium: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
              headlineMedium:TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              titleLarge: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
            ), ),
        darkTheme: ThemeData.dark()..colorScheme.copyWith(background: Colors.black),
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
  const MainRouter({super.key});

  @override
  State<MainRouter> createState() => _MainRouterState();
}

class _MainRouterState extends State<MainRouter> {
  final LocalStorage storage = LocalStorage('search');
  bool isFirst = true;
  late CommonState commonState;
  bool drawerOpen = false;
  List<DrawerItem> drawerList = [
    DrawerItem(
        title: "Home", icons: Icons.home_rounded, page: CurrentPage.home),
    DrawerItem(title: "Search", icons: Icons.search, page: CurrentPage.search),
    DrawerItem(
        title: "About",
        icons: Icons.info_outline_rounded,
        page: CurrentPage.about)
  ];
  late final Future? myFuture;
  Future<bool?> checkCatch() async {
    return storage.ready.then((value) {
      if (value) {
        var temp = storage.getItem("lastSearch");
        if (temp == null) {
          commonState.selectedLoc = Location(
              lat: 29.949932,
              lon: -90.070116,
              name: "Orleans Parish",
              secondaryName: "");
        } else {
          commonState.selectedLoc = Location.fromJson(temp);
        }

        return true;
      } else {
        return false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    myFuture = checkCatch();
  }

  @override
  Widget build(BuildContext context) {
    commonState = Provider.of<CommonState>(context);

    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if ( snapshot.data == false) {
            return const Center(child: CircularProgressIndicator());
          }
          return SlidingDrawer(
            isOpen: drawerOpen,
            onCloseDrawer: () => setState(() {
              drawerOpen = false;
            }),
            drawer: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    "asset/img/weather_logo.png",
                  ),
                ),
                Column(
                  children: drawerList
                      .map((e) => InkWell(
                            onTap: () {
                              commonState.currentPage = e.page;
                              setState(() {
                                drawerOpen = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(e.icons),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    e.title,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
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
                  return const SearchPage();
                default:
                  return const MyHomePage();
              }
            }(),
          );
        });
  }
}
