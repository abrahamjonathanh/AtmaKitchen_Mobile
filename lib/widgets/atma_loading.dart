import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AtmaLoading extends StatefulWidget {
  final String title;
  const AtmaLoading({super.key, this.title = "Loading..."});

  @override
  State<AtmaLoading> createState() => _AtmaLoadingState();
}

class _AtmaLoadingState extends State<AtmaLoading> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      LoadingAnimationWidget.horizontalRotatingDots(
        color: Colors.white,
        size: 200,
      ),
      const SizedBox(width: 4.0),
      Text(widget.title)
    ]);
  }
}
