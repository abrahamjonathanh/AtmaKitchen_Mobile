import 'package:atmakitchen_mobile/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class AtmaListTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;

  const AtmaListTile({Key? key, required this.title, this.icon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: ASize.paddingXs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 24.0,
                  color: TW3Colors.slate.shade900,
                ),
                const SizedBox(width: 8.0),
              ],
              Expanded(child: Text(title)),
            ],
          ),
        ),
      ),
    );
  }
}
