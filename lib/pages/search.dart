import 'dart:async';

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
  TextEditingController _controller = TextEditingController();
  Timer? treshold;
  int doCallIn = 0;

  @override
  Widget build(BuildContext context) {
    CommonState commonState = Provider.of<CommonState>(context);
    _doSearch(String q) async {
      var temp = await commonState.locationSearch(q);
      setState(() {
        searchResluts = temp;
      });
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      commonState.currentPage = CurrentPage.home;
                    });
                  },
                  icon: const Icon(Icons.arrow_back)),
              Expanded(
                  child: TextField(
                controller: _controller,
                decoration: const InputDecoration.collapsed(hintText: "Search"),
                onChanged: (String val) {
                  if (treshold != null) treshold!.cancel();
                  treshold = Timer(
                      const Duration(milliseconds: 500), () => _doSearch(val));
                },
                autocorrect: true,
                onEditingComplete: () {
                  _doSearch(_controller.text);
                },
              )),
              IconButton(
                  onPressed: () {
                    _doSearch(_controller.text);
                  },
                  icon: const Icon(Icons.search)),
            ],
          ),
          if (searchResluts != null && searchResluts!.features != null)
            ...searchResluts!.features!
                .map((e) => InkWell(
                    onTap: () {
                      setState(() {
                        commonState.selectedLoc = Location(
                          lat: e.center![1],
                          lon: e.center![0],
                          name: e.context!.first.text,
                          secondaryName: e.context![1].text,
                        );
                        commonState.currentPage = CurrentPage.home;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, top: 20),
                      child: Text(e.text ?? ""),
                    )))
                .toList()
        ],
      ),
    );
  }
}
