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
          vsync: this, duration: const Duration(seconds: 1));
    });
    _controller.forward();
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
      color: Colors.red,
      child: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: widget.drawer,
        ),
        Positioned(
            child: AnimatedBuilder(
          animation: _controller,
          child: widget.child,
          builder: (context, child) => Transform.translate(
              offset: Offset(
                  _controller.value * (MediaQuery.of(context).size.width * .5),
                  _controller.value * (MediaQuery.of(context).size.width * .2)),
              child: GestureDetector(
                onTap: () {
                  if (widget.isOpen) {
                    widget.onCloseDrawer();
                  }
                },
                child: child ?? Container(),
              )),
        )),
      ]),
    );
  }
}
