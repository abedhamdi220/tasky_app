import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgPicture extends StatelessWidget {
  const CustomSvgPicture({
    super.key,
    required this.path,
    this.witColorFilter = true,
    this.height,
    this.width,
  });

  const CustomSvgPicture.withoutColor({
    super.key,
    required this.path,
    this.height,
    this.width,
  }) : witColorFilter = false;

  final String path;
  final bool witColorFilter;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      height: height,
      width: width,
      colorFilter: witColorFilter
          ? ColorFilter.mode(
              Theme.of(context).colorScheme.secondary,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
