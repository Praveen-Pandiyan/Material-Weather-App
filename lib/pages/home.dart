import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:weather_app/providers/common_state.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today",
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(
              height: 10.0,
            ),
            const ResizeableContainer()
          ],
        ),
      ),
    );
  }
}

class ResizeableContainer extends StatefulWidget {
  const ResizeableContainer({Key? key}) : super(key: key);

  @override
  State<ResizeableContainer> createState() => _ResizeableContainerState();
}

class _ResizeableContainerState extends State<ResizeableContainer> {
  late CommonState _commonState;
  Float64List matrix4 = new Matrix4.identity().storage;
  late Future<ui.Image> imgFuture;

  Future<ui.Image> loadImageFromFile(String path) async {
    var fileData = Uint8List.sublistView(await rootBundle.load(path));
    return await decodeImageFromList(fileData);
  }

  @override
  void initState() {
    imgFuture =
        loadImageFromFile("asset/img/weather_img_sunset.jpg"); // Works now
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _commonState = Provider.of<CommonState>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2.5,
      constraints: const BoxConstraints(
          maxWidth: 400.0, minWidth: 80, minHeight: 50, maxHeight: 200),
      margin: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            ImageFiltered(
              imageFilter: ui.ImageFilter.blur(
                  sigmaX: 1, sigmaY: 1, tileMode: TileMode.mirror),
              child: Image.asset(
                "asset/img/weather_img_sunset.jpg",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
                child: Container(
              color: Colors.black.withOpacity(.1),
            )),
            Positioned.fill(
                child: FittedBox(
              child: Text(
                "39°",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
