import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../providers/common_state.dart';
import '../helpers.dart';

class ResizeableContainer extends StatefulWidget {
  const ResizeableContainer({super.key});

  @override
  State<ResizeableContainer> createState() => _ResizeableContainerState();
}

class _ResizeableContainerState extends State<ResizeableContainer> {
  late CommonState _commonState;
  Float64List matrix4 = Matrix4.identity().storage;
  late Future<ui.Image> imgFuture =
      loadImageFromFile("asset/img/weather_img_sunset.jpg");

  // New helper function
  Future<ui.Image> loadImageFromFile(String path) async {
    var fileData = Uint8List.sublistView(await rootBundle.load(path));
    return await decodeImageFromList(fileData);
  }

  @override
  void initState() {
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
      child: Column(
        children: [
          Text(
            '${_commonState.currentData.current?.temp?.toTemp(Temp.n)}°',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            '${_commonState.currentData.current?.weather![0].description?.toUpperCase()}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            _commonState.selectedLoc.name.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            _commonState.selectedLoc.secondaryName.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}

//  FutureBuilder<dynamic>(
//           future: imgFuture,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Text(
//                 '${_commonState.currentData.current?.temp?.toTemp(Temp.f)}',
//                 style: TextStyle(
//                     fontSize: 150,
//                     foreground: Paint()
//                       ..shader = ImageShader(snapshot.data, TileMode.mirror,
//                           TileMode.mirror, matrix4)
//                       ..style = ui.PaintingStyle.fill),
//               );
//             } else {
//               return const CircularProgressIndicator();
//             }
//           },
//         ),