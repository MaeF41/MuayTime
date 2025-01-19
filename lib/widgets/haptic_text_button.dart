import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HapticTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const HapticTextButton({
    required this.onTap,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black.withAlpha(50),
                width: 2,
              ),
              left: BorderSide(
                color: Colors.black.withAlpha(50),
                width: 1,
              ),
              right: BorderSide(
                color: Colors.black.withAlpha(50),
                width: 1,
              ),
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
