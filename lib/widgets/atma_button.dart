import 'package:atmakitchen_mobile/constants/palettes.dart';
import 'package:flutter/material.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class AtmaButton extends StatelessWidget {
  final String textButton;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double iconGap;
  final double btnHeight;
  final double btnWidth;
  final double btnRadius;
  final bool outlined;
  final ButtonStyle? style;

  const AtmaButton(
      {Key? key,
      required this.textButton,
      required this.onPressed,
      this.icon,
      this.iconGap = 4.0,
      this.btnHeight = 48.0,
      this.btnWidth = double.infinity,
      this.btnRadius = 8.0,
      this.outlined = false,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: btnWidth,
        height: btnHeight,
        child: ElevatedButton(
          style: style ??
              ElevatedButton.styleFrom(
                surfaceTintColor: outlined ? Colors.white : APalette.primary,
                shadowColor: Colors.transparent,
                backgroundColor: outlined ? Colors.white : APalette.primary,
                side: BorderSide(
                    width: 1,
                    color: outlined
                        ? TW3Colors.slate.shade200
                        : Colors.transparent),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(btnRadius)),
              ),
          onPressed: onPressed,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (icon != null) ...[
              icon!,
              SizedBox(
                width: iconGap,
              )
            ],
            Text(
              textButton,
              style: TextStyle(
                  color: outlined ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600),
            )
          ]),
        ));
  }
}
