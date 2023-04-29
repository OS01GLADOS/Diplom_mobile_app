import 'package:flutter/material.dart';

class CustomStack extends StatefulWidget {
  final List<Widget> children;
  final Widget? background;

  const CustomStack({
    Key? key,
    required this.children,
    this.background,
  }) : super(key: key);

  @override
  _CustomStackState createState() => _CustomStackState();
}

class _CustomStackState extends State<CustomStack> {
  bool isBackgroundVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          isBackgroundVisible = !isBackgroundVisible;
        });
      },
      child: Stack(
        children: [
          if (widget.background != null && isBackgroundVisible)
            widget.background!,
          ...widget.children,
        ],
      ),
    );
  }
}