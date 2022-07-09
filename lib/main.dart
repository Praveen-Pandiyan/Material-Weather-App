import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'pages/home.dart';
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
            textTheme: TextTheme(
              headline1: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 72.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              headline2: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black)),
              headline6:
                  const TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              bodyText2: GoogleFonts.getFont('Lexend Giga')
                  .copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.white),
        darkTheme: ThemeData.dark().copyWith(
          backgroundColor: Colors.black,
        ),
        themeMode: ThemeMode.light,
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
