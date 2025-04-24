import 'dart:math';

import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String image;
  final bool isFlipped;
  final VoidCallback onTap;

  const CustomCard(
      {super.key,
      required this.image,
      required this.onTap,
      required this.isFlipped});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant CustomCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped && _animation.value == 0.0) {
      _controller.forward();
    } else if (!widget.isFlipped && _animation.value == 1.0) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: widget.onTap,
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..rotateY(pi * _animation.value),
        child: Card(
          child: _animation.value <= 0.5
              ? Container(
                  color: Color(0xFF0266B7),
                  width: width / 6,
                  height: width / 6 + 60,
                  child: const Center(
                      child: Text(
                    '?',
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  )),
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: Container(
                    width: width / 6,
                    height: width / 6 + 60,
                    color: Colors.grey,
                    child: Image.asset(
                      "assets/images/${widget.image}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
