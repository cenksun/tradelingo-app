import 'package:flutter/widgets.dart';

/// Spacing scale. Every gap in the app comes from here so rhythm stays
/// consistent across screens.
class Gap {
  const Gap._();
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;
}

/// Corner radii. Rounded, but deliberately restrained so the product reads as
/// a financial tool rather than a toy.
class Radii {
  const Radii._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 999;

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius sheetRadius = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
}

class Motion {
  const Motion._();
  static const Duration fast = Duration(milliseconds: 140);
  static const Duration normal = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 420);
  static const Duration celebrate = Duration(milliseconds: 700);
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasis = Curves.easeOutBack;
}

/// Minimum touch target enforced across interactive components.
class Sizes {
  const Sizes._();
  static const double minTouch = 48;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double maxContentWidth = 560;
}

/// Vertical spacer helper.
class VGap extends StatelessWidget {
  const VGap(this.size, {super.key});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(height: size);
}

/// Horizontal spacer helper.
class HGap extends StatelessWidget {
  const HGap(this.size, {super.key});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(width: size);
}
