import 'package:flutter/material.dart';

class AnimatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.decoration,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    final radius =
        decoration.borderRadius?.resolve(TextDirection.ltr) ?? BorderRadius.zero;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: Ink(
        decoration: decoration,
        child: InkWell
          (
          borderRadius: radius,
          splashFactory: InkRipple.splashFactory,
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.08),
          onTap: onPressed,
          child: Padding(
            padding: padding,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

