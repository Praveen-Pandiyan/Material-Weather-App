import 'package:flutter/material.dart';

class SlidingDrawer extends StatefulWidget {
  final Widget child;
  final bool isOpen;
  final Widget? drawer;
  final Function onCloseDrawer;
  const SlidingDrawer(
      {Key? key,
      required this.child,
      required this.isOpen,
      this.drawer,
      required this.onCloseDrawer})
      : super(key: key);
  @override
  State<SlidingDrawer> createState() => _SlidingDrawerState();
}

class _SlidingDrawerState extends State<SlidingDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    setState(() {
      _controller = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400));
    });
    // _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value == 0 && widget.isOpen == true) {
      _controller.forward();
    } else if (_controller.value == 1 && widget.isOpen == false) {
      _controller.reverse();
    }
    return Material(
      color: Color.fromARGB(255, 129, 166, 225),
      child: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .55,
          child: widget.drawer,
        ),
        Positioned(
            child: AnimatedBuilder(
          animation: _controller,
          child: widget.child,
          builder: (context, child) => Transform.translate(
              offset: Offset(
                  _controller.value * (MediaQuery.of(context).size.width * .45),
                  _controller.value *
                      (MediaQuery.of(context).size.height * .02)),
              child: Transform.scale(
                scale: ((_controller.value * .2) - 1).abs(),
                child: GestureDetector(
                  onTap: () {
                    if (widget.isOpen) {
                      widget.onCloseDrawer();
                    }
                  },
                  onHorizontalDragUpdate: (val) {},
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(_controller.value * 15.0),
                        border: Border.all(
                          width: _controller.value * 5.0,
                          color: Color.fromARGB(255, 30, 30, 30),
                        ),
                      ),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(_controller.value * 8.0),
                          child: child ?? Container())),
                ),
              )),
        )),
      ]),
    );
  }
}
