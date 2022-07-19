import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/common_state.dart';

import '../models/custome_models.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late CommonState commonState;
  SearchResluts? searchResluts;
  @override
  Widget build(BuildContext context) {
    commonState = Provider.of<CommonState>(context);
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
              Expanded(
                  child: TextField(
                decoration: InputDecoration.collapsed(hintText: "cdc"),
                onChanged: (String val) {
                  Future.delayed(const Duration(seconds: 1))
                      .then((value) async {
                    var temp = await commonState.locationSearch(val);
                    setState(() {
                      searchResluts = temp;
                    });
                  });
                },
              )),
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            ],
          ),
          if (searchResluts != null && searchResluts!.features != null)
            ...searchResluts!.features!.map((e) => Text(e.text ?? "")).toList()
        ],
      ),
    );
  }
}
